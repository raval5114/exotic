import 'package:http/http.dart' as http;

void main() async {
  final url = 'https://xotic.in/api/search-suggestions-mobile.php?q=H';
  try {
    final response = await http.get(Uri.parse(url));
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
  } catch (e) {
    print('Exception: $e');
  }
}
