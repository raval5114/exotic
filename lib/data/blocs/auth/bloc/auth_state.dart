part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

/// ===============================
/// INITIAL / LOADING
/// ===============================

final class AuthInitialState extends AuthState {}

final class AuthLoadingState extends AuthState {}

/// ===============================
/// SIGN UP / SIGN IN
/// ===============================

final class AuthSignupSuccessState extends AuthState {}

final class AuthSigninSuccessState extends AuthState {
  final Map<String, dynamic> data;
  AuthSigninSuccessState({required this.data});
}

final class AuthSigninFindingUserState extends AuthState {
  final Map<String, dynamic> data;
  AuthSigninFindingUserState({required this.data});
}

/// ===============================
/// ERROR STATE
/// ===============================

final class AuthErrorState extends AuthState {
  int? statusCode;
  final String message;
  final List<String> errors;
  AuthErrorState({
    required this.message,
    this.statusCode,
    this.errors = const [],
  });
}

/// ===============================
/// OTP FLOW
/// ===============================

final class AuthOTPSentState extends AuthState {
  AuthOTPSentState();
}

final class AuthOTPTimeoutState extends AuthState {
  AuthOTPTimeoutState();
}

final class AuthOTPVerifiedState extends AuthState {}

final class AuthWrongOTPState extends AuthState {}
