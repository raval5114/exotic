import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:exotic/data/domains/auth/auth.dart';
import 'package:exotic/data/providers/user_login_provider.dart';
import 'package:exotic/utils/exception.dart';
import 'package:exotic/utils/injection.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitialState()) {
    AuthService auth = AuthService();
    void _handleAuthException(Object e, Emitter emit) {
      if (e is AuthException) {
        emit(
          AuthErrorState(
            message: e.message,
            statusCode: e.statusCode,
            errors: e.errors,
          ),
        );
      } else if (e is SocketException) {
        emit(AuthErrorState(message: e.message));
      } else {
        emit(AuthErrorState(message: 'Something Went wrong.Please try again'));
      }
    }

    on<SignupEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        await auth.registerWithDetails(
          firstName: event.firstName,
          lastName: event.lastName,
          email: event.email,
          username: event.username,
          mobileNumber: event.mobileNumber,
          profilePhoto: event.profilePhoto,
          password: event.password,
        );
        emit(AuthSignupSuccessState());
      } catch (e) {
        _handleAuthException(e, emit);
      }
    });

    on<SigninFindingUserEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        emit(AuthSigninFindingUserState(data: {}));
      } catch (e) {
        _handleAuthException(e, emit);
      }
    });

    on<SigninEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        Map<String, dynamic>? data = await auth.loginWithEmail(
          email: event.email,
          password: event.password,
        );

        emit(AuthSigninSuccessState(data: data!));
      } catch (e) {
        _handleAuthException(e, emit);
      }
    });
    on<AuthOTPSentInternalEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        await auth.sendOtpEmail(event.email);
        // getit<UserLoginProvider>().loadOtp();
        emit(AuthOTPSentState());
      } catch (e) {
        _handleAuthException(e, emit);
      }
    });
    on<AuthOTPVerifyingEvent>((event, emit) async {
      emit(AuthLoadingState());
      try {
        debugPrint(
          "Setted Otp${getit<UserLoginProvider>().otp}\nInputed OTP:${event.smsCode}",
        );

        bool isTrue = getit<UserLoginProvider>().verifyOtp(event.smsCode);
        if (isTrue) {
          emit(AuthOTPVerifiedState());
        } else {
          throw Exception("Invalid Otp");
        }
      } catch (e) {
        _handleAuthException(e, emit);
      }
    });
  }
}
