// lib/core/network/dio_client.dart

import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../errors/app_exception.dart';

class DioClient {
  DioClient._();

  static Dio get instance => _instance;

  static final Dio _instance = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Authorization': 'Bearer ${ApiConstants.tmdbApiKey}',
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  )..interceptors.addAll([
    _LoggingInterceptor(),
    _ErrorInterceptor(),
  ]);
}

/// Logs outgoing requests in debug mode only
class _LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    assert(() {
      // ignore: avoid_print
      print('[DIO] ${options.method} → ${options.path}');
      return true;
    }());
    handler.next(options);
  }
}

/// Converts DioException into readable AppException
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final message = switch (err.type) {
      DioExceptionType.connectionTimeout => 'Connection timed out.',
      DioExceptionType.receiveTimeout => 'Server took too long to respond.',
      DioExceptionType.badResponse =>
      'Server error: ${err.response?.statusCode}',
      DioExceptionType.connectionError => 'No internet connection.',
      _ => 'Something went wrong. Please try again.',
    };

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        error: AppException(message: message, statusCode: err.response?.statusCode),
      ),
    );
  }
}