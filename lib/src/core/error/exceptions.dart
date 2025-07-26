import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:powerbank_web_checkout/generated/locale_keys.g.dart';

abstract class AppException implements Exception {
  const AppException();

  String get userFriendlyMessage;
}

/// No internet connection
class NoConnectionException extends AppException {
  const NoConnectionException();

  @override
  String get userFriendlyMessage => LocaleKeys.noInternetConnection.tr();
}

/// Expired session/token
class ExpiredTokenException extends AppException {
  const ExpiredTokenException();

  @override
  String get userFriendlyMessage => LocaleKeys.sessionExpired.tr();
}

/// Server error (5xx)
class ServerException extends AppException {
  const ServerException([this.statusCode]);

  final int? statusCode;

  @override
  String get userFriendlyMessage =>
      LocaleKeys.serverError.tr(args: statusCode != null ? ['$statusCode'] : null);
}

/// Client error (4xx)
class ClientException extends AppException {
  const ClientException(this.statusCode, [this.message]);

  final int statusCode;
  final String? message;

  @override
  String get userFriendlyMessage {
    if (message != null) return message!;
    return switch (statusCode) {
      400 => LocaleKeys.badRequest.tr(),
      401 => LocaleKeys.unauthorized.tr(),
      403 => LocaleKeys.forbidden.tr(),
      404 => LocaleKeys.notFound.tr(),
      _ => LocaleKeys.clientError.tr(args: ['$statusCode']),
    };
  }
}

extension ExceptionHandler on Exception {
  String get userFriendlyMessage {
    if (this is AppException) {
      return (this as AppException).userFriendlyMessage;
    }

    if (this is DioException) {
      return _handleDioError(this as DioException);
    }

    return LocaleKeys.unknownError.tr();
  }

  // Handling timeouts and connection errors
  String _handleDioError(DioException e) {
    debugPrint('DioError: ${e.toString()}');
    return switch (e.type) {
      DioExceptionType.connectionTimeout => LocaleKeys.connectionTimeout.tr(),
      DioExceptionType.sendTimeout => LocaleKeys.sendTimeout.tr(),
      DioExceptionType.receiveTimeout => LocaleKeys.receiveTimeout.tr(),
      DioExceptionType.badCertificate => LocaleKeys.badCertificate.tr(),
      DioExceptionType.connectionError => LocaleKeys.connectionError.tr(),
      DioExceptionType.cancel => LocaleKeys.requestCancelled.tr(),
      DioExceptionType.unknown =>
        e.error is NoConnectionException
            ? const NoConnectionException().userFriendlyMessage
            : LocaleKeys.unknownNetworkError.tr(),
      DioExceptionType.badResponse => _handleDioResponse(e),
    };
  }

  String _handleDioResponse(DioException e) {
    final statusCode = e.response?.statusCode;
    final responseData = e.response?.data;

    if (statusCode != null && statusCode >= 500) {
      return const ServerException().userFriendlyMessage;
    }

    if (statusCode != null && statusCode >= 400) {
      return ClientException(
        statusCode,
        _extractMessageFromResponse(responseData),
      ).userFriendlyMessage;
    }

    return LocaleKeys.serverError.tr();
  }

  String? _extractMessageFromResponse(dynamic responseData) {
    if (responseData == null) return null;

    if (responseData is String) {
      return responseData.isNotEmpty ? responseData : null;
    }

    if (responseData is Map) {
      return responseData['message']?.toString() ??
          responseData['error']?.toString() ??
          responseData['detail']?.toString();
    }

    return null;
  }
}
