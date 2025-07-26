import 'dart:developer' as dev;

import 'package:dio/dio.dart';
import 'package:powerbank_web_checkout/src/core/constants/constants.dart';

class DioClient {
  DioClient._() {
    init();
  }

  static final DioClient _instance = DioClient._();

  static DioClient get instance => _instance;

  final dio = Dio();
  bool isRefreshing = false;

  Future<void> init() async {
    dev.log('🔄 Re-initializing DioClient...', name: 'DioClient');
    dio.interceptors.clear();

    dio.interceptors.addAll([
      LogInterceptor(requestBody: true, responseBody: true),
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.contentType == null) {
            final dynamic data = options.data;
            final String? contentType;
            if (data is FormData) {
              contentType = Headers.multipartFormDataContentType;
            } else if (data is Map) {
              contentType = Headers.formUrlEncodedContentType;
            } else if (data is String) {
              contentType = Headers.jsonContentType;
            } else if (data != null) {
              contentType = Headers.textPlainContentType;
            } else {
              contentType = null;
            }
            options.contentType = contentType;
          }
          handler.next(options);
        },
        onError: (e, handler) async {
          if (isRefreshing) {
            return handler.next(e);
          }
          final scode = e.response?.statusCode;
          // if (scode == 401 || scode == 403) {
          //   isRefreshing = true;
          //   final IUsersRepository userRepo = sl();
          //   final result = await userRepo.refreshToken();
          //   isRefreshing = false;
          //   switch (result) {
          //     case Success():
          //       e.requestOptions.headers['Authorization'] = 'Bearer ${result.value.accessToken}';
          //       handler.resolve(await dio.fetch(e.requestOptions));
          //       break;
          //     case Failure():
          //       break;
          //   }
          // }
          handler.next(e);
        },
      ),
    ]);

    dio.options = BaseOptions(
      baseUrl: Constants.baseUrl,
      connectTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 60),
    );
  }

  void setCredentials(String token) {
    dev.log('setCredentials: $token');
    dio.options.headers['Authorization'] = 'Bearer $token';
  }

  void clearCredentials() {
    dio.options.headers.remove('Authorization');
  }
}
