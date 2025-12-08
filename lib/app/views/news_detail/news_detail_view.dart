import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/theme/app_colors.dart';
import '../../models/article.dart';
import '../../routes/app_routes.dart';

class NewsDetailView extends StatelessWidget {
  const NewsDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final article = Get.arguments as Article?;

    if (article == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          title: const Text('Error'),
        ),
        body: const Center(child: Text('Article not found')),
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.chat),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.chat_bubble, color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.network(
                  article.imageUrl ?? 'https://picsum.photos/400/300',
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 300,
                      width: double.infinity,
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                              : null,
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 300,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Image not available',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(100),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withAlpha(100),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.bookmark_border,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${article.source} • ${article.timeAgo}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textHint,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentOrange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Hot',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (article.description.isNotEmpty) ...[
                    Text(
                      article.description,
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (article.url.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    GestureDetector(
                      onTap: () => Get.toNamed(
                        AppRoutes.webview,
                        arguments: article.url,
                      ),
                      child: Text(
                        'Read full article →',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
