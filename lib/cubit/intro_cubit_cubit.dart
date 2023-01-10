import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../error.dart';

part 'intro_cubit_state.dart';

class IntroCubit extends Cubit<IntroState> {
  final SharedPreferences sharedPreferences;

  IntroCubit({
    required this.sharedPreferences,
  }) : super(IntroCubitInitial());

  @visibleForTesting
  static const String completedIntro = 'completedIntro';

  // void completedIntroTutorial() {
  //   emit(IntroCubitInitial());
  //   emit(IntroCubitLoading());
  //   try {
  //     final bool = sharedPreferences.getBool(completedIntro) ?? false;
  //     if (bool) {
  //       emit(
  //         IntroCubitSaved(boolean: bool),
  //       );
  //     } else {
  //       emit(
  //         IntroCubitNotSaved(boolean: bool),
  //       );
  //     }
  //   } on Exception catch (exception) {
  //     emit(
  //       IntroCubitError(
  //         appError: AppError(
  //           message: exception.toString(),
  //         ),
  //       ),
  //     );
  //   }
  // }

  void completedIntroTutorial() {
    emit(IntroCubitInitial());
    emit(IntroCubitLoading());
    try {
      final bool = sharedPreferences.getBool(completedIntro) ?? false;
      emit(
        IntroCubitSuccess(boolean: bool),
      );
    } on Exception catch (exception) {
      emit(
        IntroCubitError(
          appError: AppError(
            message: exception.toString(),
          ),
        ),
      );
    }
  }

  void saveIntro() async {
    emit(IntroCubitInitial());
    emit(IntroCubitLoading());
    try {
      final bool = await sharedPreferences.setBool(completedIntro, true);
      if (bool) {
        emit(
          IntroCubitSaved(boolean: bool),
        );
      } else {
        emit(
          IntroCubitNotSaved(boolean: bool),
        );
      }
    } on Exception catch (exception) {
      emit(
        IntroCubitError(
          appError: AppError(
            message: exception.toString(),
          ),
        ),
      );
    }
  }

  Future<void> clear() async {
    emit(IntroCubitInitial());
    try {
      await sharedPreferences.clear();

      emit(
        const IntroCubitSaved(boolean: true),
      );
    } on Exception catch (e) {
      debugPrint('The storage is not cleared. Error: $e');
      emit(
        IntroCubitError(
          appError: AppError(
            message: e.toString(),
          ),
        ),
      );
    }
  }
}
