import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:exotic/data/providers/user_login_provider.dart';
import 'package:exotic/utils/exception.dart';
import 'package:exotic/utils/injection.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter/material.dart';
import 'package:exotic/data/repositories/auth/auth.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class AuthService extends IAuthRepo {
  @override
  Future<Map<String, dynamic>?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final Uri url = Uri(
        scheme: "https",
        host: "xotic.in",
        path: "/api/login.php",
      );

      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'identifier': "${email}", 'password': "${password}"}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final decoded = jsonDecode(response.body);

        throw AuthException.fromJson(decoded);
      }
    } catch (e) {
      debugPrint("🔴 Login error: $e");
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> registerWithDetails({
    required String firstName,
    required String lastName,
    required String username,
    required String email,
    required String mobileNumber,
    required File profilePhoto,
    required String password,
  }) async {
    try {
      final Uri url = Uri.parse("https://xotic.in/api/register.php");

      final request =
          http.MultipartRequest('POST', url)
            ..fields['c_firstname'] = firstName
            ..fields['c_lastname'] = lastName
            ..fields['c_username'] = username
            ..fields['c_email'] = email
            ..fields['c_phone'] = mobileNumber
            ..fields['c_password'] = password;

      request.files.add(
        await http.MultipartFile.fromPath(
          'c_photo',
          profilePhoto.path,
          contentType: MediaType('image', 'jpeg'),
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final decoded = jsonDecode(response.body);

        throw AuthException.fromJson(decoded);
      }
    } catch (e) {
      debugPrint("🔴 Registration error: $e");
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    debugPrint("⚠️ Sign-out not yet implemented.");
    throw UnimplementedError("Sign-out is not implemented yet.");
  }

  @override
  Future<void> sendOtpEmail(String email) async {
    try {
      // Generate 4-digit OTP
      final otp = Random().nextInt(9000) + 1000;

      // SMTP Configuration
      final smtpServer = SmtpServer(
        'smtpout.secureserver.net',
        port: 465,
        ssl: true,
        username: 'donotreply@xotic.in',
        password: 'Waploft\$9874',
      );

      final message =
          Message()
            ..from = Address('donotreply@xotic.in', 'Xotic')
            ..recipients.add(email)
            ..subject = 'Your OTP for Verification'
            ..html =
                "$otp is your Xotic OTP. Please DO NOT share this OTP with anyone. – Team Xotic";

      try {
        final sendReport = await send(message, smtpServer);
        print('✅ Email sent: $sendReport');
        print("Generated OTP: $otp");
        getit<UserLoginProvider>().setOtp(otp);
      } on MailerException catch (e) {
        print('❌ Failed to send email: ${e.message}');
        for (var p in e.problems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
