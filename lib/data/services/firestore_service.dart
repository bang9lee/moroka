import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tarot_reading_model.dart';
import '../models/user_model.dart';
import '../../core/utils/app_logger.dart';
import '../../core/constants/app_constants.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collections
  CollectionReference<Map<String, dynamic>> get _usersCollection =>
      _firestore.collection('users');
  
  CollectionReference<Map<String, dynamic>> get _readingsCollection =>
      _firestore.collection('readings');

  // User operations
  Future<void> createOrUpdateUser(UserModel user) async {
    await _usersCollection.doc(user.uid).set(
      user.toFirestore(),
      SetOptions(merge: true),
    );
  }

  Future<UserModel?> getUser(String uid) async {
    final doc = await _usersCollection.doc(uid).get();
    if (doc.exists) {
      return UserModel.fromFirestore(doc);
    }
    return null;
  }

  Stream<UserModel?> userStream(String uid) {
    return _usersCollection.doc(uid).snapshots().map((doc) {
      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    });
  }

  // Tarot reading operations
  Future<String> saveTarotReading(TarotReadingModel reading) async {
    // Check if user has reached the limit
    const int historyLimit = AppConstants.freeUserHistoryLimit; // TODO: Check premium status for premiumUserHistoryLimit
    
    // Get user's current readings count
    final userReadingsQuery = await _readingsCollection
        .where('userId', isEqualTo: reading.userId)
        .orderBy('createdAt', descending: true)
        .get();
    
    final currentCount = userReadingsQuery.docs.length;
    
    // If user has reached the limit, delete the oldest reading
    if (currentCount >= historyLimit) {
      // Get all readings sorted by date (newest first)
      final readingsToDelete = userReadingsQuery.docs
          .skip(historyLimit - 1) // Keep only the newest (historyLimit - 1) readings
          .toList();
      
      // Delete the oldest readings
      for (final doc in readingsToDelete) {
        await _readingsCollection.doc(doc.id).delete();
      }
    }
    
    // Save the new reading
    final docRef = await _readingsCollection.add(reading.toFirestore());
    return docRef.id;
  }

  Future<void> updateTarotReading(String readingId, Map<String, dynamic> updates) async {
    await _readingsCollection.doc(readingId).update(updates);
  }

  Future<TarotReadingModel?> getTarotReading(String readingId) async {
    final doc = await _readingsCollection.doc(readingId).get();
    if (doc.exists) {
      return TarotReadingModel.fromFirestore(doc);
    }
    return null;
  }

  // Get user's tarot readings with pagination
  Future<({List<TarotReadingModel> readings, DocumentSnapshot? lastDoc})> getUserReadings({
    required String userId,
    int limit = 10,
    DocumentSnapshot? lastDocument,
  }) async {
    Query query = _readingsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .limit(limit);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    final querySnapshot = await query.get();
    final readings = querySnapshot.docs
        .map((doc) => TarotReadingModel.fromFirestore(doc))
        .toList();
    
    final lastDoc = querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null;
    
    return (readings: readings, lastDoc: lastDoc);
  }

  // Get user's readings stream
  Stream<List<TarotReadingModel>> userReadingsStream(String userId) {
    return _readingsCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => TarotReadingModel.fromFirestore(doc))
            .toList());
  }

  // Add chat exchange to existing reading
  Future<void> addChatExchange({
    required String readingId,
    required ChatExchange exchange,
  }) async {
    await _readingsCollection.doc(readingId).update({
      'chatHistory': FieldValue.arrayUnion([exchange.toMap()]),
    });
  }

  // Get reading statistics
  Future<Map<String, dynamic>> getUserStatistics(String userId) async {
    final result = await getUserReadings(userId: userId, limit: 100);
    final readings = result.readings;
    
    // Calculate statistics
    final totalReadings = readings.length;
    final cardFrequency = <String, int>{};
    final moodFrequency = <String, int>{};
    
    for (final reading in readings) {
      cardFrequency[reading.cardName] = (cardFrequency[reading.cardName] ?? 0) + 1;
      moodFrequency[reading.userMood] = (moodFrequency[reading.userMood] ?? 0) + 1;
    }
    
    // Find most frequent card
    String? mostFrequentCard;
    int maxCardCount = 0;
    cardFrequency.forEach((card, cardCount) {
      if (cardCount > maxCardCount) {
        maxCardCount = cardCount;
        mostFrequentCard = card;
      }
    });
    
    return {
      'totalReadings': totalReadings,
      'mostFrequentCard': mostFrequentCard,
      'cardFrequency': cardFrequency,
      'moodFrequency': moodFrequency,
      'lastReadingDate': readings.isNotEmpty ? readings.first.createdAt : null,
    };
  }

  // Delete reading
  Future<void> deleteReading(String readingId) async {
    await _readingsCollection.doc(readingId).delete();
  }

  // Delete all user readings
  Future<void> deleteAllUserReadings(String userId) async {
    int deletedCount = 0;
    
    try {
      // Get all user readings in batches
      QuerySnapshot snapshot;
      do {
        snapshot = await _readingsCollection
            .where('userId', isEqualTo: userId)
            .limit(500) // Firestore batch limit
            .get();
        
        if (snapshot.docs.isNotEmpty) {
          final batch = _firestore.batch();
          for (var doc in snapshot.docs) {
            batch.delete(doc.reference);
            deletedCount++;
          }
          await batch.commit();
        }
      } while (snapshot.docs.length == 500);
      
      AppLogger.debug('Deleted $deletedCount readings for user: $userId');
    } catch (e) {
      AppLogger.error('Error deleting all user readings', e);
      rethrow;
    }
  }
  
  // Update user's total readings count
  Future<void> incrementReadingCount(String userId) async {
    await _usersCollection.doc(userId).update({
      'totalReadings': FieldValue.increment(1),
    });
  }
}