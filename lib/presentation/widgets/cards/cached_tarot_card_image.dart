import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_logger.dart';

/// A widget that displays tarot card images with automatic caching
class CachedTarotCardImage extends ConsumerWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String? cardId;
  
  const CachedTarotCardImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.cardId,
  });
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check if this is a network image or asset
    if (imagePath.startsWith('http')) {
      return _buildNetworkImage();
    } else {
      return _buildAssetImage();
    }
  }
  
  Widget _buildAssetImage() {
    return Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        AppLogger.error('Failed to load asset image: $imagePath', error);
        return _buildErrorWidget();
      },
    );
  }
  
  Widget _buildNetworkImage() {
    return FutureBuilder<FileInfo?>(
      future: _getCachedImage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingWidget();
        }
        
        if (snapshot.hasError || snapshot.data == null) {
          // Try to download and cache the image
          return _downloadAndCacheImage();
        }
        
        // Image is cached, display it
        return Image.file(
          snapshot.data!.file,
          width: width,
          height: height,
          fit: fit,
          errorBuilder: (context, error, stackTrace) {
            AppLogger.error('Failed to load cached image', error);
            return _downloadAndCacheImage();
          },
        );
      },
    );
  }
  
  Future<FileInfo?> _getCachedImage() async {
    try {
      final cacheKey = cardId != null ? 'tarot_card_$cardId' : imagePath;
      return await DefaultCacheManager().getFileFromCache(cacheKey);
    } catch (e) {
      AppLogger.error('Failed to get cached image', e);
      return null;
    }
  }
  
  Widget _downloadAndCacheImage() {
    return FutureBuilder<FileInfo>(
      future: _downloadImage(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingWidget();
        }
        
        if (snapshot.hasError) {
          AppLogger.error('Failed to download image', snapshot.error);
          return _buildErrorWidget();
        }
        
        if (snapshot.hasData) {
          return Image.file(
            snapshot.data!.file,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) {
              return _buildErrorWidget();
            },
          );
        }
        
        return _buildErrorWidget();
      },
    );
  }
  
  Future<FileInfo> _downloadImage() async {
    final cacheKey = cardId != null ? 'tarot_card_$cardId' : imagePath;
    return await DefaultCacheManager().downloadFile(
      imagePath,
      key: cacheKey,
    );
  }
  
  Widget _buildLoadingWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.blackOverlay40,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.mysticPurple),
          strokeWidth: 2,
        ),
      ),
    );
  }
  
  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.blackOverlay40,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.cardBorder,
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_not_supported,
            color: AppColors.fogGray,
            size: width != null ? width! * 0.3 : 48,
          ),
          const SizedBox(height: 8),
          Text(
            'Image not available',
            style: TextStyle(
              color: AppColors.fogGray,
              fontSize: width != null ? width! * 0.06 : 12,
            ),
          ),
        ],
      ),
    );
  }
}