import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../providers.dart';
import 'glass_morphism_container.dart';

class CacheManagerWidget extends ConsumerStatefulWidget {
  const CacheManagerWidget({super.key});

  @override
  ConsumerState<CacheManagerWidget> createState() => _CacheManagerWidgetState();
}

class _CacheManagerWidgetState extends ConsumerState<CacheManagerWidget> {
  Map<String, dynamic> _cacheStats = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCacheStatistics();
  }

  Future<void> _loadCacheStatistics() async {
    setState(() => _isLoading = true);
    
    final cacheRepository = ref.read(cacheRepositoryProvider);
    final stats = await cacheRepository.getCacheStatistics();
    
    if (mounted) {
      setState(() {
        _cacheStats = stats;
        _isLoading = false;
      });
    }
  }

  Future<void> _clearCache() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.shadowGray,
        title: Text(
          'Clear Cache',
          style: AppTextStyles.dialogTitle.copyWith(color: AppColors.mysticPurple),
        ),
        content: const Text(
          'This will clear all cached data including AI interpretations and reading history cache. Are you sure?',
          style: AppTextStyles.dialogContent,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      setState(() => _isLoading = true);
      
      final cacheRepository = ref.read(cacheRepositoryProvider);
      await cacheRepository.clearAllCache();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cache cleared successfully'),
            backgroundColor: AppColors.spiritGlow,
          ),
        );
        
        await _loadCacheStatistics();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GlassMorphismContainer(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Cache Management',
                  style: AppTextStyles.sectionTitle.copyWith(
                    color: AppColors.mysticPurple,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  color: AppColors.mysticPurple,
                  onPressed: _loadCacheStatistics,
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: AppColors.mysticPurple,
                ),
              )
            else ...[
              _buildStatItem(
                'AI Interpretations',
                '${_cacheStats['aiInterpretations'] ?? 0} cached',
                Icons.psychology,
              ),
              const SizedBox(height: 12),
              
              _buildStatItem(
                'Reading Histories',
                '${_cacheStats['readingHistories'] ?? 0} users',
                Icons.history,
              ),
              const SizedBox(height: 12),
              
              _buildStatItem(
                'Cached Images',
                '${_cacheStats['cachedImages'] ?? 0} images',
                Icons.image,
              ),
              const SizedBox(height: 12),
              
              _buildStatItem(
                'Total Size',
                '${_cacheStats['totalSizeMB'] ?? '0.00'} MB',
                Icons.storage,
              ),
              const SizedBox(height: 12),
              
              _buildStatItem(
                'Last Cleanup',
                _cacheStats['lastCleanup'] ?? 'Never',
                Icons.access_time,
              ),
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _clearCache,
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Clear All Cache'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.withAlpha(204),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Note: Clearing cache will not delete your saved readings or account data.',
                style: AppTextStyles.contentText.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.mysticPurple,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.contentText.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.contentText.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}