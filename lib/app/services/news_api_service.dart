import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../core/network/dio_client.dart';
import '../models/article.dart';

class NewsApiService {
  static const String _baseUrl = 'https://newsapi.org/v2';
  static String get _apiKey => dotenv.env['NEWS_API_KEY'] ?? '';

  late final DioClient _client;

  NewsApiService() {
    _client = DioClient(
      baseUrl: _baseUrl,
      queryParameters: {'apiKey': _apiKey},
    );
  }

  Future<List<Article>> getTopHeadlines({
    String country = 'id',
    String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _client.get(
      '/top-headlines',
      queryParameters: {
        'country': country,
        if (category != null) 'category': category,
        'page': page,
        'pageSize': pageSize,
      },
    );

    if (response.statusCode == 200) {
      final articles = (response.data['articles'] as List)
          .map((json) => Article.fromJson(json))
          .where((article) => article.title.isNotEmpty)
          .toList();
      return articles;
    }
    throw Exception('Failed to load news');
  }

  Future<List<Article>> searchNews({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await _client.get(
      '/everything',
      queryParameters: {
        'q': query,
        'page': page,
        'pageSize': pageSize,
        'sortBy': 'publishedAt',
      },
    );

    if (response.statusCode == 200) {
      final articles = (response.data['articles'] as List)
          .map((json) => Article.fromJson(json))
          .where((article) => article.title.isNotEmpty)
          .toList();
      return articles;
    }
    throw Exception('Failed to search news');
  }
}
