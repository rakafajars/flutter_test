import 'package:get/get.dart';

import '../models/article.dart';
import '../services/news_api_service.dart';

class HomeController extends GetxController {
  final NewsApiService _newsApiService = NewsApiService();

  final RxList<Article> articles = <Article>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString selectedCategory = 'general'.obs;

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
    fetchNews();
  }

  Future<void> fetchNews({String? category}) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      if (category != null) {
        selectedCategory.value = category;
      }

      final result = await _newsApiService.getTopHeadlines(
        country: 'us',
        category: selectedCategory.value == 'general'
            ? null
            : selectedCategory.value,
      );

      articles.value = result;
    } catch (e) {
      errorMessage.value = e.toString();
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
}
