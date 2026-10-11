import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../../utils/client/routes.dart';
import '../models/app_user_model.dart';

class UserAlreadyExistsException implements Exception {
  const UserAlreadyExistsException();
}

class AuthApiException implements Exception {
  final String message;
  final int? statusCode;

  const AuthApiException(this.message, {this.statusCode});
}

class InvalidAuthResponseException implements Exception {
  const InvalidAuthResponseException();
}

class AuthNetworkException implements Exception {
  const AuthNetworkException();
}

class AuthService {
  final Dio _dio;
  final Map<String, AppUserModel> _localUsers = {};

  AuthService(this._dio);

  Future<AppUserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      var data = {
        'email': email.trim().toLowerCase(),
        'password': password,
      };

      final response = await _dio.post<dynamic>(
        Endpoints.login,
        data: data,
      );

      return AppUserModel.fromJson(_extractUserJson(response.data));
    } on DioException catch (error) {
      final response = error.response;
      if (response != null) {
        throw AuthApiException(
          _extractErrorMessage(response.data),
          statusCode: response.statusCode,
        );
      }
      throw const AuthNetworkException();
    } on InvalidAuthResponseException {
      rethrow;
    } catch (_) {
      throw const InvalidAuthResponseException();
    }
  }

  String _extractErrorMessage(dynamic responseData) {
    if (responseData is String && responseData.trim().isNotEmpty) {
      return responseData;
    }

    if (responseData is Map) {
      final data = Map<String, dynamic>.from(responseData);
      final message = data['message'];
      if (message is String && message.trim().isNotEmpty) return message;

      final error = data['error'];
      if (error is String && error.trim().isNotEmpty) return error;
      if (error is Map) return _extractErrorMessage(error);

      final nestedData = data['data'];
      if (nestedData is Map || nestedData is String) {
        return _extractErrorMessage(nestedData);
      }
    }

    return 'A API não informou o motivo da falha.';
  }

  Future<AppUserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (_localUsers.containsKey(normalizedEmail)) {
      throw const UserAlreadyExistsException();
    }

    final user = AppUserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      email: normalizedEmail,
    );
    _localUsers[normalizedEmail] = user;
    return user;
  }

  Map<String, dynamic> _extractUserJson(dynamic responseData) {
    if (responseData is! Map) {
      throw const InvalidAuthResponseException();
    }

    final root = Map<String, dynamic>.from(responseData);
    dynamic userData = root['user'] ?? root['data'] ?? root;

    if (userData is Map && userData['user'] is Map) {
      userData = userData['user'];
    }
    if (userData is! Map) {
      throw const InvalidAuthResponseException();
    }

    final userJson = Map<String, dynamic>.from(userData);
    if (userJson['id'] == null || userJson['email'] == null) {
      throw const InvalidAuthResponseException();
    }
    return userJson;
  }
}
