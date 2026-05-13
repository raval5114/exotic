abstract class AddressEvent {}

class FetchAddressesEvent extends AddressEvent {
  final int cId;
  FetchAddressesEvent({required this.cId});
}

class AddAddressEvent extends AddressEvent {
  final int cId;
  final String caName;
  final String caAddress1;
  final String caAddress2;
  final String caLocality;
  final String caCity;
  final String caState;
  final String caPincode;
  final String caMobileNo;
  final String caAlternateMobileNo;
  final String caType;
  final String caBadge;
  final int caIsDefault;

  AddAddressEvent({
    required this.cId,
    required this.caName,
    required this.caAddress1,
    this.caAddress2 = "",
    required this.caLocality,
    required this.caCity,
    required this.caState,
    required this.caPincode,
    required this.caMobileNo,
    this.caAlternateMobileNo = "",
    required this.caType,
    this.caBadge = "Home",
    this.caIsDefault = 0,
  });
}

class UpdateAddressEvent extends AddressEvent {
  final int caId;
  final int cId;
  final String caName;
  final String caAddress1;
  final String caAddress2;
  final String caLocality;
  final String caCity;
  final String caState;
  final String caPincode;
  final String caMobileNo;
  final String caAlternateMobileNo;
  final String caType;
  final String caBadge;
  final int caIsDefault;

  UpdateAddressEvent({
    required this.caId,
    required this.cId,
    required this.caName,
    required this.caAddress1,
    this.caAddress2 = "",
    required this.caLocality,
    required this.caCity,
    required this.caState,
    required this.caPincode,
    required this.caMobileNo,
    this.caAlternateMobileNo = "",
    required this.caType,
    this.caBadge = "Home",
    this.caIsDefault = 0,
  });
}
