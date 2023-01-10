part of 'intro_cubit_cubit.dart';

abstract class IntroState extends Equatable {
  const IntroState();

  @override
  List<Object> get props => [];
}

class IntroCubitInitial extends IntroState {}

class IntroCubitLoading extends IntroState {}

class IntroCubitSaved extends IntroState {
  final bool boolean;

  const IntroCubitSaved({
    required this.boolean,
  });

  @override
  List<Object> get props => [boolean];
}

class IntroCubitNotSaved extends IntroState {
  final bool boolean;

  const IntroCubitNotSaved({
    required this.boolean,
  });

  @override
  List<Object> get props => [boolean];
}

class IntroCubitSuccess extends IntroState {
  final bool boolean;

  const IntroCubitSuccess({
    required this.boolean,
  });

  @override
  List<Object> get props => [boolean];
}

class IntroCubitError extends IntroState {
  final AppError appError;

  const IntroCubitError({
    required this.appError,
  });

  @override
  List<Object> get props => [appError];
}
