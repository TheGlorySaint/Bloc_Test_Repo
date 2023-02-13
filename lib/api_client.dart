import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/service.dart';

class APIClient {
  Dio dio = Dio();
  final SharedPreferences _shared = services.get<SharedPreferences>();

  //String? get userToken => _shared.getString('token1');

  String? get userToken => _shared.getString('token');

  String _endpoint(String path) => 'www.example.com/api/v1/mobile/$path';

  Map<String, String> get _defaultHeaders => {
        'accept': 'application/json',
        'Content-Type': 'application/json',
      };

  Map<String, String> get _authHeaders =>
      userToken != null ? {..._defaultHeaders, 'Authorization': 'Bearer $userToken'} : _defaultHeaders;

  APIClient() {
    dio.interceptors.add(LogInterceptor(responseBody: true));
    //http options
    // dio.options.baseUrl = _endpoint(path);
    dio.options.headers = _authHeaders;
    dio.options.connectTimeout = const Duration(seconds: 10); //10s
    dio.options.receiveTimeout = const Duration(seconds: 10); //10s
  }

  Future<Response?> post({
    required dynamic path,
    required dynamic body,
  }) async {
    final response = await dio.post(
      _endpoint(path.toString()),
      data: jsonEncode(body),
    );
    return response;
  }

  Future<Response?> get({
    required dynamic path,
    required dynamic body,
  }) async {
    return await dio.get(
      _endpoint(path.toString()),
    );
  }

  Future<Response?> put({
    required dynamic path,
    required dynamic body,
  }) async {
    return await dio.put(
      _endpoint(path.toString()),
      data: jsonEncode(body),
    );
  }

  Future<Response?> delete({
    required dynamic path,
    required dynamic body,
  }) async {
    return await dio.delete(
      _endpoint(path.toString()),
      data: jsonEncode(body),
    );
  }
}
