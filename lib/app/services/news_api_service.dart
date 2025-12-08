import 'package:dio/dio.dart';

import '../models/article.dart';

class NewsApiService {
  static const String _baseUrl = 'https://newsapi.org/v2';
  static const String _apiKey = '21e4d2bebfc8490383d42736ba2fbe4e';

  final Dio _dio;

  NewsApiService() : _dio = Dio(_createOptions());

  static BaseOptions _createOptions() {
    return BaseOptions(
      baseUrl: _baseUrl,
      queryParameters: {'apiKey': _apiKey},
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    );
  }

  Future<List<Article>> getTopHeadlines({
    String country = 'id',
    String? category,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get(
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
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Article>> searchNews({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await _dio.get(
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
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return Exception('Connection timeout. Please try again.');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Unknown error';
        if (statusCode == 401) {
          return Exception('Invalid API key');
        } else if (statusCode == 429) {
          return Exception('Too many requests. Please try again later.');
        }
        return Exception('Error: $message');
      case DioExceptionType.cancel:
        return Exception('Request cancelled');
      default:
        return Exception('No internet connection');
    }
  }
}
