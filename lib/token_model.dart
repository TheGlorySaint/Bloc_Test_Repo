/// {@category models}
library token_model;

import 'dart:convert';

/// This model is used for the token response.
class TokenModel {
  /// Backend token
  String? _token;

  /// Firebase token
  String? _fbToken;

  /// User id
  int? _userId;

  bool? _didRegistrationWork;

  /// Message from backend
  String? _message;

  TokenModel({
    String? token,
    String? fbToken,
    int? userId,
    bool? didRegistrationWork,
    String? message,
  })  : _token = token,
        _fbToken = fbToken,
        _didRegistrationWork = didRegistrationWork,
        _userId = userId,
        _message = message;

  factory TokenModel.fromJson(String str) => TokenModel.fromMap(json.decode(str));

  factory TokenModel.fromMap(Map<String, dynamic> json) => TokenModel(
        token: json['access_token'],
        fbToken: json['fb_token'],
        userId: json['userId'],
        didRegistrationWork: json['success'],
        message: json['message'],
      );

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        'access_token': _token,
        'fb_token': _fbToken,
        'userId': _userId,
        'success': _didRegistrationWork,
        'message': _message,
      };

  @override
  String toString() =>
      'access_token: $_token fbToken: $_fbToken userId: $_userId didRegistrationWork: $_didRegistrationWork message $_message';

  String? get token => _token;
  String? get fbToken => _fbToken;
  int? get userId => _userId;
  bool? get didRegistrationWork => _didRegistrationWork;
  String? get message => _message;

  bool get isValid =>
      _token != null &&
      _token!.isNotEmpty &&
      // _fbToken != null &&
      // _fbToken!.isNotEmpty &&
      _userId != null &&
      _didRegistrationWork != null &&
      _didRegistrationWork == true;
}
