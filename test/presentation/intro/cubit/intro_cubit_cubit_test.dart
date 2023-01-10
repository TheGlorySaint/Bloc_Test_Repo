import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/cubit/intro_cubit_cubit.dart';
import 'package:test_app/error.dart';

class MockIntroCubit extends Mock implements IntroCubit {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  late SharedPreferences sharedPreferences;
  late IntroCubit introCubit;
  late MockIntroCubit mockIntroCubit;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    sharedPreferences = await SharedPreferences.getInstance();
    introCubit = IntroCubit(sharedPreferences: sharedPreferences);
    mockIntroCubit = MockIntroCubit();
  });

  group('Intro Cubit Test', () {
    const AppError tAppError = AppError(message: 'Failed to save bool');
    const bool tBooleanTrue = true;
    const bool tBooleanFalse = false;

    blocTest<IntroCubit, IntroState>(
      'emits [IntroCubitInitial, IntroCubitLoading, IntroCubitSaved] when [completedIntroTutorial] is sucessfully called and true.',
      setUp: () => when(() => mockIntroCubit.completedIntroTutorial())
          .thenAnswer((_) async => tBooleanTrue),
      build: () => introCubit,
      act: (cubit) => cubit.completedIntroTutorial(),
      expect: () => <IntroState>[
        IntroCubitInitial(),
        IntroCubitLoading(),
        const IntroCubitSuccess(boolean: tBooleanTrue),
      ],
      // verify: (_) {
      //   verifyNever(() => mockIntroCubit.completedIntroTutorial()).called(1);
      // },
    );
    blocTest<IntroCubit, IntroState>(
      'emits [IntroCubitInitial, IntroCubitLoading, IntroCubitNotSaved] when [completedIntroTutorial] is sucessfully called but false.',
      setUp: () => when(() => mockIntroCubit.completedIntroTutorial())
          .thenAnswer((_) async => tBooleanFalse),
      build: () => introCubit,
      act: (cubit) => cubit.completedIntroTutorial(),
      expect: () => <IntroState>[
        IntroCubitInitial(),
        IntroCubitLoading(),
        const IntroCubitSuccess(boolean: tBooleanFalse),
      ],
      // verify: (_) {
      //   verifyNever(() => mockIntroCubit.completedIntroTutorial()).called(1);
      // },
    );
    blocTest<IntroCubit, IntroState>(
      'emits [IntroCubitInitial, IntroCubitLoading, IntroCubitError] when [completedIntroTutorial] is failed.',
      setUp: () => when(() => mockIntroCubit.completedIntroTutorial())
          .thenThrow(tAppError),
      build: () => introCubit,
      act: (cubit) => cubit.completedIntroTutorial(),
      expect: () => <IntroState>[
        IntroCubitInitial(),
        IntroCubitLoading(),
        const IntroCubitError(appError: tAppError),
      ],
      // verify: (_) async {
      //   verify(() => mockSharedPreferences.getBool(IntroCubit.completedIntro))
      //       .called(1);
      // },
    );
    blocTest<IntroCubit, IntroState>(
      'emits [IntroCubitInitial, IntroCubitLoading, IntroCubitSaved] when [saveIntro] is sucessfully called and true.',
      setUp: () => when(() => mockIntroCubit.saveIntro())
          .thenAnswer((_) => tBooleanTrue),
      build: () => introCubit,
      act: (cubit) => cubit.saveIntro(),
      expect: () => <IntroState>[
        IntroCubitInitial(),
        IntroCubitLoading(),
        const IntroCubitSuccess(boolean: tBooleanTrue),
      ],
      // verify: (_) async {
      //   verify(() => mockSharedPreferences.getBool(IntroCubit.completedIntro))
      //       .called(1);
      // },
    );
    blocTest<IntroCubit, IntroState>(
      'emits [IntroCubitInitial, IntroCubitLoading, IntroCubitNotSaved] when [saveIntro] is sucessfully called but false.',
      setUp: () => when(() => mockIntroCubit.saveIntro())
          .thenAnswer((_) => tBooleanFalse),
      build: () => introCubit,
      act: (cubit) => cubit.saveIntro(),
      expect: () => <IntroState>[
        IntroCubitInitial(),
        IntroCubitLoading(),
        const IntroCubitSuccess(boolean: tBooleanFalse),
      ],
      // verify: (_) {
      //   verifyNever(() => mockIntroCubit.completedIntroTutorial()).called(1);
      // },
    );
    blocTest<IntroCubit, IntroState>(
      'emits [IntroCubitInitial, IntroCubitSuccess] when [saveIntro] is sucessfully called.',
      setUp: () => when(() => mockIntroCubit.saveIntro())
          .thenAnswer((_) => tBooleanTrue),
      build: () => introCubit,
      act: (cubit) => cubit.completedIntroTutorial(),
      expect: () => <IntroState>[
        IntroCubitInitial(),
        IntroCubitLoading(),
        const IntroCubitSuccess(boolean: tBooleanTrue),
      ],
      // verify: (_) {
      //   verifyNever(() => mockIntroCubit.completedIntroTutorial()).called(1);
      // },
    );
  });
}
