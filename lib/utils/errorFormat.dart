import 'dart:convert';

String formatAuthError(dynamic error) {
  if (error == null) {
    return 'Something went wrong. Please try again.';
  }

  // ✅ Case 1: Map directly
  if (error is Map<String, dynamic>) {
    if (error['message'] != null) {
      return error['message'].toString();
    }
  }

  // ✅ Case 2: Exception
  if (error is Exception) {
    return error.toString().replaceFirst('Exception: ', '');
  }

  // ✅ Case 3: JSON String (YOUR CURRENT CASE)
  if (error is String) {
    try {
      final decoded = jsonDecode(error);
      if (decoded is Map && decoded['message'] != null) {
        return decoded['message'].toString();
      }
    } catch (_) {
      // Not JSON → continue
    }

    return error;
  }

  return 'Something went wrong. Please try again.';
}
