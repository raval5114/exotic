class AuthException implements Exception {
  final int statusCode;
  final String message;
  final List<String> errors;
  AuthException({
    required this.statusCode,
    required this.message,
    required this.errors,
  });
  factory AuthException.fromJson(Map<String, dynamic> json) {
    return AuthException(
      statusCode: json['status'] ?? "Error",
      message: json['message'],
      errors: json['errors'] != null ? List<String>.from(json['errors']) : [],
    );
  }
}
