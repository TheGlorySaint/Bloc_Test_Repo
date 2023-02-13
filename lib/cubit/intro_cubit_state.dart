part of 'intro_cubit_cubit.dart';

class SigninState extends Equatable {
  final SigninStatusEnum status;
  final Exception? exception;
  final String? email;
  final String? deviceID;
  final String? pin;
  final String? deviceOS;
  final String? deviceModel;
  final dynamic deviceDetails;
  final String? deviceIP;
  final String? lat;
  final String? long;

  const SigninState({
    this.status = SigninStatusEnum.initial,
    this.exception,
    this.email,
    this.deviceID,
    this.pin,
    this.deviceOS,
    this.deviceModel,
    this.deviceDetails,
    this.deviceIP,
    this.lat,
    this.long,
  });

  SigninState copyWith({
    SigninStatusEnum? status,
    Exception? exception,
    String? email,
    String? deviceID,
    String? pin,
    String? deviceOS,
    String? deviceModel,
    dynamic deviceDetails,
    String? deviceIP,
    String? lat,
    String? long,
  }) {
    return SigninState(
      status: status ?? this.status,
      exception: exception ?? this.exception,
      email: email ?? this.email,
      deviceID: deviceID ?? this.deviceID,
      pin: pin ?? this.pin,
      deviceOS: deviceOS ?? this.deviceOS,
      deviceModel: deviceModel ?? this.deviceModel,
      deviceDetails: deviceDetails ?? this.deviceDetails,
      deviceIP: deviceIP ?? this.deviceIP,
      lat: lat ?? this.lat,
      long: long ?? this.long,
    );
  }

  @override
  List<Object?> get props =>
      [status, exception, email, deviceID, pin, deviceOS, deviceModel, deviceDetails, deviceIP, lat, long];
}
