class Address {
  final int? caId;
  final int? cId;
  final String? caName;
  final String? caAddress1;
  final String? caAddress2;
  final String? caLocality;
  final String? caCity;
  final String? caState;
  final String? caPincode;
  final String? caMobileNo;
  final String? caAlternateMobileNo;
  final String? caType;
  final String? caBadge;
  final int? caIsDefault;
  final String? createdAt;
  Address({
    this.caId,
    this.cId,
    this.caName,
    this.caAddress1,
    this.caAddress2,
    this.caLocality,
    this.caCity,
    this.caState,
    this.caPincode,
    this.caMobileNo,
    this.caAlternateMobileNo,
    this.caType,
    this.caBadge,
    this.caIsDefault,
    this.createdAt,
  });
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      caId: json['ca_id'],
      cId: json['c_id'],
      caName: json['ca_name'],
      caAddress1: json['ca_address_1'],
      caAddress2: json['ca_address_2'],
      caLocality: json['ca_locality'],
      caCity: json['ca_city'],
      caState: json['ca_state'],
      caPincode: json['ca_pincode'],
      caMobileNo: json['ca_mobile_no'],
      caAlternateMobileNo: json['ca_alternate_mobile_no'],
      caType: json['ca_type'],
      caBadge: json['ca_badge'],
      caIsDefault: json['ca_is_default'],
      createdAt: json['created_at'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'ca_id': caId,
      'c_id': cId,
      'ca_name': caName,
      'ca_address_1': caAddress1,
      'ca_address_2': caAddress2,
      'ca_locality': caLocality,
      'ca_city': caCity,
      'ca_state': caState,
      'ca_pincode': caPincode,
      'ca_mobile_no': caMobileNo,
      'ca_alternate_mobile_no': caAlternateMobileNo,
      'ca_type': caType,
      'ca_badge': caBadge,
      'ca_is_default': caIsDefault,
      'created_at': createdAt,
    };
  }

  Address copyWith({
    int? caId,
    int? cId,
    String? caName,
    String? caAddress1,
    String? caAddress2,
    String? caLocality,
    String? caCity,
    String? caState,
    String? caPincode,
    String? caMobileNo,
    String? caAlternateMobileNo,
    String? caType,
    String? caBadge,
    int? caIsDefault,
    String? createdAt,
  }) {
    return Address(
      caId: caId ?? this.caId,
      cId: cId ?? this.cId,
      caName: caName ?? this.caName,
      caAddress1: caAddress1 ?? this.caAddress1,
      caAddress2: caAddress2 ?? this.caAddress2,
      caLocality: caLocality ?? this.caLocality,
      caCity: caCity ?? this.caCity,
      caState: caState ?? this.caState,
      caPincode: caPincode ?? this.caPincode,
      caMobileNo: caMobileNo ?? this.caMobileNo,
      caAlternateMobileNo: caAlternateMobileNo ?? this.caAlternateMobileNo,
      caType: caType ?? this.caType,
      caBadge: caBadge ?? this.caBadge,
      caIsDefault: caIsDefault ?? this.caIsDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
