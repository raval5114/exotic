import 'dart:convert';
import 'package:http/http.dart' as http;

class AddressesDomain {
  Future<Map<String, dynamic>> getAddress(int cId) async {
    final url = Uri.parse('https://xotic.in/api/customers/address_list.php');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({"c_id": cId}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return {
          "status": false,
          "message":
              "Failed to fetch addresses. Status code: ${response.statusCode}",
        };
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> postAddress({
    required int cId,
    required String caName,
    required String caAddress1,
    String caAddress2 = "",
    required String caLocality,
    required String caCity,
    required String caState,
    required String caPincode,
    required String caMobileNo,
    String caAlternateMobileNo = "",
    required String caType,
    String caBadge = "Home",
    int caIsDefault = 0,
  }) async {
    final url = Uri.parse('https://xotic.in/api/customers/address_create.php');
    try {
      final Map<String, dynamic> payload = {
        "c_id": cId,
        "ca_name": caName,
        "ca_address_1": caAddress1,
        "ca_locality": caLocality,
        "ca_city": caCity,
        "ca_state": caState,
        "ca_pincode": caPincode,
        "ca_mobile_no": caMobileNo,
        "ca_type": caType,
      };

      print("--- POST ADDRESS PAYLOAD ---");
      print(jsonEncode(payload));
      print("----------------------------");

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(payload),
      );
      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return {
          "status": false,
          "message":
              "Failed to post address. Status code: ${response.statusCode}",
        };
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateAddress({
    required int caId,
    required int cId,
    required String caName,
    required String caAddress1,
    String caAddress2 = "",
    required String caLocality,
    required String caCity,
    required String caState,
    required String caPincode,
    required String caMobileNo,
    String caAlternateMobileNo = "",
    required String caType,
    String caBadge = "Home",
    int caIsDefault = 0,
  }) async {
    final url = Uri.parse('https://xotic.in/api/customers/address_update.php');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "ca_id": caId,
          "c_id": cId,
          "ca_name": caName,
          "ca_address_1": caAddress1,
          "ca_address_2": caAddress2,
          "ca_locality": caLocality,
          "ca_city": caCity,
          "ca_state": caState,
          "ca_pincode": caPincode,
          "ca_mobile_no": caMobileNo,
          "ca_alternate_mobile_no": caAlternateMobileNo,
          "ca_type": caType,
          "ca_badge": caBadge,
          "ca_is_default": caIsDefault.toString(),
        }),
      );
      print("Update Address Payload: " + jsonEncode({
          "ca_id": caId,
          "c_id": cId,
          "ca_name": caName,
          "ca_address_1": caAddress1,
          "ca_address_2": caAddress2,
          "ca_locality": caLocality,
          "ca_city": caCity,
          "ca_state": caState,
          "ca_pincode": caPincode,
          "ca_mobile_no": caMobileNo,
          "ca_alternate_mobile_no": caAlternateMobileNo,
          "ca_type": caType,
          "ca_badge": caBadge,
          "ca_is_default": caIsDefault.toString(),
      }));
      print("Update Address Response [${response.statusCode}]: ${response.body}");
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return {
          "status": false,
          "message":
              "Failed to update address. Status code: ${response.statusCode}",
        };
      }
    } catch (e) {
      print("Update Address Error: $e");
      return {"status": false, "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteAddress({
    required int caId,
    required int cId,
  }) async {
    final url = Uri.parse('https://xotic.in/api/customers/address_delete.php');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({"ca_id": caId, "c_id": cId}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        return {
          "status": false,
          "message":
              "Failed to delete address. Status code: ${response.statusCode}",
        };
      }
    } catch (e) {
      return {"status": false, "message": e.toString()};
    }
  }
}
