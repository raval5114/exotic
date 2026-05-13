import 'package:exotic/data/domains/address/addresses_domain.dart';
import 'package:exotic/data/models/address_model.dart';

class AddressesRepo {
  final AddressesDomain domain = AddressesDomain();

  Future<List<Address>> getAddress(int cId) async {
    try {
      final response = await domain.getAddress(cId);
      if (response['status'] == true && response['data'] != null) {
        final List<dynamic> data = response['data'];
        return data.map((json) => Address.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Failed to fetch addresses.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> postAddress({
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
    try {
      final response = await domain.postAddress(
        cId: cId,
        caName: caName,
        caAddress1: caAddress1,
        caAddress2: caAddress2,
        caLocality: caLocality,
        caCity: caCity,
        caState: caState,
        caPincode: caPincode,
        caMobileNo: caMobileNo,
        caAlternateMobileNo: caAlternateMobileNo,
        caType: caType,
        caBadge: caBadge,
        caIsDefault: caIsDefault,
      );
      if (response['status'] == true) {
        return true;
      } else {
        throw Exception(response['message'] ?? 'Failed to save address.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> updateAddress({
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
    try {
      final response = await domain.updateAddress(
        caId: caId,
        cId: cId,
        caName: caName,
        caAddress1: caAddress1,
        caAddress2: caAddress2,
        caLocality: caLocality,
        caCity: caCity,
        caState: caState,
        caPincode: caPincode,
        caMobileNo: caMobileNo,
        caAlternateMobileNo: caAlternateMobileNo,
        caType: caType,
        caBadge: caBadge,
        caIsDefault: caIsDefault,
      );
      if (response['status'] == true) {
        return true;
      } else {
        throw Exception(response['message'] ?? 'Failed to update address.');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
