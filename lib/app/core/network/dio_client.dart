import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class DioClient {
  final Dio _dio;

  DioClient({
    required String baseUrl,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
    Duration connectTimeout = const Duration(seconds: 10),
    Duration receiveTimeout = const Duration(seconds: 10),
  }) : _dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           queryParameters: queryParameters,
           headers: headers,
           connectTimeout: connectTimeout,
           receiveTimeout: receiveTimeout,
         ),
       );

  Dio get dio => _dio;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.get<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
      );
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      return await _dio.delete<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw handleError(e);
    }
  }

  ApiException handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException(
          'Connection timeout. Please try again.',
          statusCode: null,
        );
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? 'Unknown error';
        if (statusCode == 401) {
          return ApiException('Unauthorized', statusCode: 401);
        } else if (statusCode == 403) {
          return ApiException('Forbidden', statusCode: 403);
        } else if (statusCode == 404) {
          return ApiException('Not found', statusCode: 404);
        } else if (statusCode == 429) {
          return ApiException(
            'Too many requests. Please try again later.',
            statusCode: 429,
          );
        } else if (statusCode != null && statusCode >= 500) {
          return ApiException('Server error', statusCode: statusCode);
        }
        return ApiException('Error: $message', statusCode: statusCode);
      case DioExceptionType.cancel:
        return ApiException('Request cancelled');
      case DioExceptionType.connectionError:
        return ApiException('No internet connection');
      default:
        return ApiException('Something went wrong');
    }
  }
}
