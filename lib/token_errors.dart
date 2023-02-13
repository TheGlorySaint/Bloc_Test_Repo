/// {@category api}
library token_errors;

import 'dart:convert';

import 'package:test_app/api_errors.dart';

/// This class extends the [ApiErrorFields]
class TokenErrors extends ApiErrorFields with Messages {
  /// [List] of errors with the First name of the patient
  final List<String>? firstName;

  /// [List] of errors with the Last name of the patient
  final List<String>? lastName;

  /// [List] of errors with the Email of the patient
  final List<String>? emailAddress;

  /// [List] of errors with the Email confirm of the patient
  final List<String>? email;

  /// [List] of errors with the Password of the patient
  final List<String>? password;

  /// [List] of errors with the Password confirm of the patient
  final List<String>? passwordConfirmation;

  /// [List] of errors with the Email confirmation
  final List<String>? emailConfirmation;

  /// [List] of errors with the Confirmation of the Terms of use
  final List<String>? termsOfUseConfirmed;

  /// [List] of errors with the Device Store
  final List<String>? store;

  ///  [List] of errors with the confirmation that eCovery can use the Users data
  final List<String>? personalDataProcess;

  TokenErrors({
    this.firstName,
    this.lastName,
    this.emailAddress,
    this.email,
    this.password,
    this.passwordConfirmation,
    this.emailConfirmation,
    this.termsOfUseConfirmed,
    this.store,
    this.personalDataProcess,
  });

  factory TokenErrors.fromJson(String str) => TokenErrors.fromMap(json.decode(str));

  factory TokenErrors.fromMap(Map<String, dynamic> data) => TokenErrors(
        firstName: Messages.decode(data['first_name']),
        lastName: Messages.decode(data['last_name']),
        emailAddress: Messages.decode(data['email_address']),
        password: Messages.decode(data['password']),
        passwordConfirmation: Messages.decode(data['password_confirmation']),
        emailConfirmation: Messages.decode(data['email_confirmation']),
        termsOfUseConfirmed: Messages.decode(data['terms_of_use_confirmed']),
        personalDataProcess: Messages.decode(data['personal_data_processing_confirmed']),
        store: Messages.decode(data['store']),
      );

  @override
  Map<String, dynamic> toMap() => {
        'first_name': encodeMessages(firstName),
        'last_name': encodeMessages(lastName),
        'email_address': encodeMessages(emailAddress),
        'password': encodeMessages(password),
        'password_confirmation': encodeMessages(passwordConfirmation),
        'email_confirmation': encodeMessages(emailConfirmation),
        'terms_of_use_confirmed': encodeMessages(termsOfUseConfirmed),
        'store': encodeMessages(store),
        'personal_data_processing_confirmed': encodeMessages(personalDataProcess),
      };
}
