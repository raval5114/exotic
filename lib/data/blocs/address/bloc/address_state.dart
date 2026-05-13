import 'package:exotic/data/models/address_model.dart';

enum AddressStatus {
  initial,
  loading,
  loaded,
  error,
  adding,
  added,
  addError,
  deleting,
  deleted,
  deleteError
}

class AddressState {
  final AddressStatus status;
  final List<Address> addresses;
  final String? message;

  AddressState({
    this.status = AddressStatus.initial,
    this.addresses = const [],
    this.message,
  });

  AddressState copyWith({
    AddressStatus? status,
    List<Address>? addresses,
    String? message,
  }) {
    return AddressState(
      status: status ?? this.status,
      addresses: addresses ?? this.addresses,
      message: message,
    );
  }
}
