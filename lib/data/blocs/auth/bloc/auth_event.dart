part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class SignupEvent extends AuthEvent {
  final String firstName;
  final String lastName;
  final File profilePhoto;
  final String username;
  final String email;
  final String mobileNumber;
  final String password;
  SignupEvent({
    required this.firstName,
    required this.lastName,
    required this.profilePhoto,
    required this.username,
    required this.email,
    required this.mobileNumber,
    required this.password,
  });
}

class SigninFindingUserEvent extends AuthEvent {
  final String email;
  SigninFindingUserEvent({required this.email});
}

class SigninEvent extends AuthEvent {
  final String email;
  final String password;
  SigninEvent({required this.email, required this.password});
}

class AuthOTPSendingEvent extends AuthEvent {
  final String mobileno;
  AuthOTPSendingEvent({required this.mobileno});
}

class AuthOTPVerifyingEvent extends AuthEvent {
  final int smsCode;

  AuthOTPVerifyingEvent({required this.smsCode});
}

class AuthOTPSentInternalEvent extends AuthEvent {
  final String email;
  AuthOTPSentInternalEvent({required this.email});
}

class AuthErrorEvent extends AuthEvent {
  final String errorMsg;
  AuthErrorEvent({required this.errorMsg});
}

class AuthOTPVerifiedInternalEvent extends AuthEvent {}
