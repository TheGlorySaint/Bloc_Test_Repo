import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../auth_repo.dart';
import '../device_repo.dart';
import '../sign_in_enum.dart';

part 'intro_cubit_state.dart';

class SigninCubit extends Cubit<SigninState> {
  final AuthenticationRepository authenticationRepository;
  final DeviceRepository deviceRepository;

  SigninCubit({
    required this.authenticationRepository,
    required this.deviceRepository,
  }) : super(const SigninState());

  void login() async {
    emit(state.copyWith(status: SigninStatusEnum.initial));
    emit(state.copyWith(status: SigninStatusEnum.loading));
    try {
      final deviceModel = await deviceRepository.getDevice();
      final deviceIP = await deviceRepository.getIP();
      final position = await deviceRepository.getCurrentPosition();
      emit(
        state.copyWith(
          deviceID: deviceModel!.identifierForVendor!,
          deviceOS: deviceModel.os!,
          deviceModel: deviceModel.model!,
          deviceDetails: deviceModel,
          deviceIP: deviceIP,
          lat: position!.latitude.toString(),
          long: position.longitude.toString(),
          status: SigninStatusEnum.successSavedData,
        ),
      );

      final response = await authenticationRepository.login(
        email: state.email!,
        pin: state.pin!,
        deviceID: deviceModel.identifierForVendor!,
        deviceOS: deviceModel.os!,
        deviceModel: deviceModel.model!,
        deviceDetails: deviceModel,
        deviceIP: deviceIP,
        lat: position.latitude.toString(),
        long: position.longitude.toString(),
      );
      if (response.data != null && response.isOkay && response.data?.didRegistrationWork == true) {
        saveToken(response.data?.token);
        // emit(state.copyWith(status: SigninStatusEnum.successfullloggedin));
      }
    } on Exception catch (exception) {
      log('register exception: $exception');
      emit(
        state.copyWith(
          status: SigninStatusEnum.failure,
          exception: exception,
        ),
      );
    }
  }

  void setEmail(String? address) async {
    emit(state.copyWith(status: SigninStatusEnum.initial));
    emit(state.copyWith(status: SigninStatusEnum.loading));
    try {
      final bool = await authenticationRepository.saveEmail(address!);

      if (bool) {
        emit(
          state.copyWith(
            email: address,
            status: SigninStatusEnum.successSetEMailAddress,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: SigninStatusEnum.failedToSetEMailAddress,
          ),
        );
      }
    } on Exception catch (exception) {
      debugPrint('The storage is not cleared. Error: $exception');
      emit(
        state.copyWith(
          status: SigninStatusEnum.failure,
          exception: exception,
        ),
      );
    }
  }

  void setPin(String? pinValue) {
    emit(state.copyWith(status: SigninStatusEnum.initial));
    emit(state.copyWith(status: SigninStatusEnum.loading));
    try {
      emit(
        state.copyWith(
          pin: pinValue,
          status: SigninStatusEnum.successSetPin,
        ),
      );
    } on Exception catch (exception) {
      debugPrint('The storage is not cleared. Error: $exception');
      emit(
        state.copyWith(
          status: SigninStatusEnum.failure,
          exception: exception,
        ),
      );
    }
  }

  void saveToken(String? token) async {
    emit(state.copyWith(status: SigninStatusEnum.initial));
    emit(state.copyWith(status: SigninStatusEnum.loading));
    try {
      final bool = await authenticationRepository.saveToken(token!);

      if (bool) {
        emit(
          state.copyWith(
            status: SigninStatusEnum.successfullSavedToken,
          ),
        );
      } else {
        emit(
          state.copyWith(
            status: SigninStatusEnum.failedToSaveToken,
          ),
        );
      }
    } on Exception catch (exception) {
      debugPrint('The storage is not cleared. Error: $exception');
      emit(
        state.copyWith(
          status: SigninStatusEnum.failure,
          exception: exception,
        ),
      );
    }
  }
}
