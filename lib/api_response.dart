/// {@category api}
library api_response;

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart' as http;

import 'api_errors.dart';

typedef DataConstructor<T> = T Function(Map<String, dynamic>? dataOrErrors);

/// Used to send the request to the server and get the response.
class ApiResponse<DATA, ERRORS extends ApiErrorFields?> {
  final DataConstructor<DATA> _makeData;
  final DataConstructor<ERRORS> _makeErrors;

  http.Response? _original;
  DATA? _data;
  ERRORS? _errors;
  int? _status;
  String? _message;

  /// The original response from the server.
  String get responseStatus => '${_original?.statusCode}: ${_original?.statusMessage}';

  ApiResponse(this._makeData, this._makeErrors);

  /// Sends the request to the server and gets the response.
  ApiResponse<DATA, ERRORS> fromHttp(http.Response? response) {
    _original = response;
    _status = null;

    try {
      dynamic json = response?.data.isEmpty ? null : response?.data;
      log('status: $status debug json: $json');

      if ([200, 201].contains(status)) {
        if (json != null && json is List) {
          json = <String, dynamic>{'json': json};
        }
        _data = json != null ? _makeData(json) : null;
        _errors = null;
        _message = null;
      } else if ([
        422,
        404,
        400,
        401,
      ].contains(status)) {
        Map<String, dynamic> data = jsonDecode(response?.data);
        _data = null;
        _errors = data['errors'] != null ? _makeErrors(data['errors']) : null;
        _message = data['message'];
      }
    } catch (_) {
      _data = null;
      _errors = null;
      _message = 'Parse JSON failed';
    }

    return this;
  }

  int get status => _status ?? _original?.statusCode ?? 500;

  bool get isOkay => [200, 201, 204].contains(status);

  bool get isFailed => status > 400;

  http.RequestOptions? get request => _original?.requestOptions;

  http.Headers? get headers => _original?.headers;

  String? get body => _original?.data;

  String? get message => _message;

  DATA? get data => _data;

  ERRORS? get errors => _errors;

  makeInvalid([int status = 401]) {
    _status = status;
  }
}
