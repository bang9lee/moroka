import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tarot_reading_model.dart';
import '../models/user_model.dart';

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
  Future<List<TarotReadingModel>> getUserReadings({
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
    return querySnapshot.docs
        .map((doc) => TarotReadingModel.fromFirestore(doc))
        .toList();
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
    final readings = await getUserReadings(userId: userId, limit: 100);
    
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
  
  // Update user's total readings count
  Future<void> incrementReadingCount(String userId) async {
    await _usersCollection.doc(userId).update({
      'totalReadings': FieldValue.increment(1),
    });
  }
}