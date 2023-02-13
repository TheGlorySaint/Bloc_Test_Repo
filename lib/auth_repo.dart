import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/service.dart';
import 'package:test_app/token_errors.dart';
import 'package:test_app/token_model.dart';

import 'api_client.dart';
import 'api_response.dart';

class AuthenticationRepository {
  final APIClient apiClient;

  AuthenticationRepository({
    required this.apiClient,
  }) : super();

  final SharedPreferences _sharedPreferences = services.get<SharedPreferences>();

  String? getLanguageCode() {
    return Platform.localeName;
  }

  String? getToken() {
    return _sharedPreferences.getString('token');
  }

  Future<bool> saveToken(String value) async {
    return await _sharedPreferences.setString('token', value);
  }

  Future<bool> saveEmail(String value) async {
    return await _sharedPreferences.setString('email', value);
  }

  String? getEmail() {
    return _sharedPreferences.getString('email');
  }

  Future<ApiResponse<TokenModel, TokenErrors>> login({
    required String email,
    required String pin,
    required String deviceID,
    String? deviceOS,
    String? deviceModel,
    dynamic deviceDetails,
    String? deviceIP,
    String? lat,
    String? long,
  }) async {
    log('Login with email $email, pin $pin, deviceID $deviceID, deviceOS $deviceOS, deviceModel $deviceModel, deviceDetails $deviceDetails, deviceIP $deviceIP, lat $lat and long $long');

    final dynamic body = {
      'email': email,
      'device_id': deviceID,
      'pin': pin,
      'os': deviceOS,
      'model': deviceModel,
      'details': jsonEncode(deviceDetails),
      'ip': deviceIP,
      'lat': lat,
      'lng': long,
    };
    final httpResponse = await apiClient.post(body: body, path: '/auth/register');

    final response = ApiResponse(
      (data) => TokenModel.fromMap(data!),
      (errors) => TokenErrors.fromMap(errors!),
    ).fromHttp(httpResponse);

    return response;
  }

  Future<ApiResponse<TokenModel, TokenErrors>> register({
    required String email,
    required String deviceID,
  }) async {
    final languagecode = getLanguageCode();
    log('Register with email $email, deviceID $deviceID and languageCode $languagecode');

    final dynamic body = {
      'email': email,
      'device_id': deviceID,
      'language': languagecode,
    };
    final httpResponse = await apiClient.post(body: body, path: '/auth/register');

    final response = ApiResponse(
      (data) => TokenModel.fromMap(data!),
      (errors) => TokenErrors.fromMap(errors!),
    ).fromHttp(httpResponse);

    return response;
  }
}
