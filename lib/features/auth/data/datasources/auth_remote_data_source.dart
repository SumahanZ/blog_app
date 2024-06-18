//create interface for the authremotedatasource, so whenever we have to change supabase to any other database, we have a strict rule to follow

//datasource we are only concerned with calls made to the external database, we don;t want any other dependencies
import 'dart:convert';

import 'package:blog_app/core/exception/exception.dart';
import 'package:blog_app/features/auth/data/models/user_model.dart';
import 'package:dio/dio.dart';

abstract interface class AuthRemoteDataSource {
  Future<UserModel> signUpWithEmailPassword(
      {required String name, required String email, required String password});
  Future<UserModel> loginWithEmailPassword(
      {required String email, required String password});
  Future<UserModel?> getUserData({required String token});
}

//pass in the supabaseClient using DI instead of instantiating it
//to make it easier to test (making a mock) and make AuthRemoteDataSource not dependent on Dio client
class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl({required this.dio});

  @override
  Future<UserModel> loginWithEmailPassword(
      {required String email, required String password}) async {
    final response = await dio.post('/login',
        data: {
          "email": email,
          "password": password,
        },
        options: Options(headers: {'Content-Type': 'application/json'}));

    if (response.statusCode != null && response.statusCode! >= 400) {
      throw ServerException(
          errorMessage: response.statusMessage,
          statusCode: response.statusCode.toString());
    } else if (response.statusCode != null) {
      return UserModel.fromJson(jsonEncode(response.data));
    } else {
      throw UnknownException(
          errorMessage: response.statusMessage,
          statusCode: response.statusCode.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    final response = await dio.post('/register',
        data: {
          "username": name,
          "email": email,
          "password": password,
        },
        options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
            sendTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 10)));

    if (response.statusCode != null && response.statusCode! >= 400) {
      throw ServerException(
          errorMessage: response.statusMessage,
          statusCode: response.statusCode.toString());
    } else if (response.statusCode != null) {
      return UserModel.fromJson(jsonEncode(response.data));
    } else {
      throw UnknownException(
          errorMessage: response.statusMessage,
          statusCode: response.statusCode.toString());
    }
  }

  @override
  Future<UserModel?> getUserData({required String token}) async {
    final response = await dio.get('/get-user',
        data: {
          "token": token,
        },
        options: Options(headers: {'Content-Type': 'application/json'}));

    if (response.statusCode != null && response.statusCode! >= 400) {
      throw ServerException(
          errorMessage: response.statusMessage,
          statusCode: response.statusCode.toString());
    } else if (response.statusCode != null) {
      return UserModel.fromJson(response.data);
    } else {
      throw UnknownException(
          errorMessage: response.statusMessage,
          statusCode: response.statusCode.toString());
    }
  }
}
