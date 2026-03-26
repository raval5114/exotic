import 'dart:io';

abstract class IAuthRepo {
  Future<dynamic> registerWithDetails({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String mobileNumber,
    required File profilePhoto,
    required String password,
  });

  Future<dynamic> loginWithEmail({
    required String email,
    required String password,
  });
  Future<int> sendOtpEmail(String email);
  Future<int> sendOtpSms(String mobileNo);
  Future<void> signOut();
}
