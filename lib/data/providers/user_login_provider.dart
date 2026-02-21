import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLoginProvider extends ChangeNotifier {
  static const _otpKey = 'otp';
  static const _otpTimestampKey = 'otp_timestamp';

  String _email = '';
  String _password = '';
  String _username = '';
  String _mobileno = '';
  int _userPasswordAttempt = 0;
  int _otp = -1;
  DateTime? _otpCreatedAt;

  // Getters
  String get email => _email;
  String get password => _password;
  String get username => _username;
  String get mobileno => _mobileno;
  int get userPasswordAttempt => _userPasswordAttempt;
  int get otp => _otp;

  bool get isOtpValid {
    if (_otp == -1 || _otpCreatedAt == null) return false;
    return DateTime.now().difference(_otpCreatedAt!).inMinutes < 5;
  }

  // Setters
  set email(String value) {
    if (_email != value) {
      _email = value;
      notifyListeners();
    }
  }

  set password(String value) {
    if (_password != value) {
      _password = value;
      notifyListeners();
    }
  }

  set username(String value) {
    if (_username != value) {
      _username = value;
      notifyListeners();
    }
  }

  set mobileno(String value) {
    if (_mobileno != value) {
      _mobileno = value;
      notifyListeners();
    }
  }

  set userPasswordAttempt(int value) {
    if (_userPasswordAttempt != value) {
      _userPasswordAttempt = value;
      notifyListeners();
    }
  }

  /// Set OTP and save it to SharedPreferences with a timestamp
  Future<void> setOtp(int newOtp) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    _otp = newOtp;
    _otpCreatedAt = now;
    notifyListeners();

    await prefs.setInt(_otpKey, newOtp);
    await prefs.setString(_otpTimestampKey, now.toIso8601String());
  }

  /// Verify if provided OTP matches the stored one and is still valid
  bool verifyOtp(int inputOtp) {
    try {
      if (_otp == null || _otp == -1 || _otpCreatedAt == null) {
        return false;
      }

      final isNotExpired =
          DateTime.now().difference(_otpCreatedAt!).inMinutes < 5;

      final isMatching = _otp == inputOtp;

      return isMatching && isNotExpired;
    } catch (e, stackTrace) {
      debugPrint("OTP verification error: $e");
      debugPrintStack(stackTrace: stackTrace);
      return false;
    }
  }

  /// Load OTP and timestamp from SharedPreferences
  Future<void> loadOtp() async {
    final prefs = await SharedPreferences.getInstance();
    final storedOtp = prefs.getInt(_otpKey);
    final storedTime = prefs.getString(_otpTimestampKey);

    if (storedOtp != null && storedTime != null) {
      final parsedTime = DateTime.tryParse(storedTime);
      if (parsedTime != null &&
          DateTime.now().difference(parsedTime).inMinutes < 5) {
        _otp = storedOtp;
        _otpCreatedAt = parsedTime;
      } else {
        // Expired
        await clearOtp();
      }
    } else {
      _otp = -1;
      _otpCreatedAt = null;
    }
    notifyListeners();
  }

  /// Clear OTP (manual or after expiry)
  Future<void> clearOtp() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_otpKey);
    await prefs.remove(_otpTimestampKey);

    _otp = -1;
    _otpCreatedAt = null;
    notifyListeners();
  }

  /// Clear all credentials
  Future<void> clearCredentials() async {
    _email = '';
    _password = '';
    _username = '';
    _mobileno = '';
    _userPasswordAttempt = 0;
    await clearOtp();
    notifyListeners();
  }
}
