import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/database/dao/article_dao.dart';
import '../models/article.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';
import '../services/connectivity_service.dart';
import '../services/news_api_service.dart';

class HomeController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final ConnectivityService _connectivityService =
      Get.find<ConnectivityService>();
  final NewsApiService _newsApiService = NewsApiService();
  final ArticleDao _articleDao = ArticleDao();

  bool get isGuest => _authService.currentUser?.isAnonymous ?? true;
  bool get isOffline => !_connectivityService.isOnline.value;

  final RxList<Article> articles = <Article>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedCategory = 'general'.obs;
  final RxBool isOfflineMode = false.obs;

  final List<Map<String, String>> categories = [
    {'key': 'general', 'label': 'Lokal'},
    {'key': 'business', 'label': 'Business'},
    {'key': 'technology', 'label': 'Tech'},
    {'key': 'sports', 'label': 'Sport'},
    {'key': 'entertainment', 'label': 'Entertainment'},
  ];

  @override
  void onInit() {
    super.onInit();
    _connectivityService.isOnline.listen((online) {
      isOfflineMode.value = !online;
      if (online && articles.isEmpty) {
        fetchNews();
      }
    });
    fetchNews();
  }

  Future<void> fetchNews({String? category}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (category != null) {
        selectedCategory.value = category;
      }

      final currentCategory = selectedCategory.value;

      if (await _connectivityService.checkConnection()) {
        final result = await _newsApiService.getTopHeadlines(
          country: 'us',
          category: currentCategory == 'general' ? null : currentCategory,
        );

        articles.value = result;
        isOfflineMode.value = false;

        await _articleDao.insertArticles(result, category: currentCategory);
        debugPrint('Cached ${result.length} articles to SQLite');
      } else {
        final cachedArticles = await _articleDao.getArticlesByCategory(
          currentCategory,
        );
        if (cachedArticles.isNotEmpty) {
          articles.value = cachedArticles;
          isOfflineMode.value = true;
          debugPrint('Loaded ${cachedArticles.length} articles from cache');
        } else {
          errorMessage.value = 'No internet connection and no cached data';
        }
      }
    } catch (e) {
      debugPrint('Error fetching news: $e');

      final cachedArticles = await _articleDao.getArticlesByCategory(
        selectedCategory.value,
      );
      if (cachedArticles.isNotEmpty) {
        articles.value = cachedArticles;
        isOfflineMode.value = true;
        debugPrint('Fallback to cache: ${cachedArticles.length} articles');
      } else {
        errorMessage.value = e.toString();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshNews() async {
    await fetchNews();
  }

  void selectCategory(String category) {
    if (selectedCategory.value != category) {
      fetchNews(category: category);
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      await _authService.signOut();
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Sign out failed: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
