import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, String>?> fetchIndiaLocation({
  required String pincode,
}) async {
  try {
    final response = await http.get(
      Uri.parse('https://api.postalpincode.in/pincode/$pincode'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      if (data[0]['Status'] == "Success") {
        final postOffice = data[0]['PostOffice'][0];

        return {
          "country": "India",
          "state": postOffice['State'] ?? "",
          "city": postOffice['District'] ?? "",
        };
      }
    }

    return null;
  } catch (e) {
    return null;
  }
}
