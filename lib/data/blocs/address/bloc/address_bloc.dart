import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exotic/data/repositories/address/addressesRepo.dart';
import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final AddressesRepo _addressesRepo;

  AddressBloc(this._addressesRepo) : super(AddressState()) {
    on<FetchAddressesEvent>(_onFetchAddresses);
    on<AddAddressEvent>(_onAddAddress);
    on<UpdateAddressEvent>(_onUpdateAddress);
    on<DeleteAddressEvent>(_onDeleteAddress);
    on<ClearAddressesEvent>(_onClearAddresses);
  }

  /// Resets bloc state to initial + empty list (called on logout).
  void _onClearAddresses(
    ClearAddressesEvent event,
    Emitter<AddressState> emit,
  ) {
    emit(AddressState());
  }

  Future<void> _onFetchAddresses(
    FetchAddressesEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(status: AddressStatus.loading));
    try {
      final addresses = await _addressesRepo.getAddress(event.cId);
      emit(state.copyWith(status: AddressStatus.loaded, addresses: addresses));
    } catch (e) {
      final errorMsg = e.toString().replaceFirst('Exception: ', '');
      emit(state.copyWith(status: AddressStatus.error, message: errorMsg));
    }
  }

  Future<void> _onAddAddress(
    AddAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(status: AddressStatus.adding));
    try {
      await _addressesRepo.postAddress(
        cId: event.cId,
        caName: event.caName,
        caAddress1: event.caAddress1,
        caAddress2: event.caAddress2,
        caLocality: event.caLocality,
        caCity: event.caCity,
        caState: event.caState,
        caPincode: event.caPincode,
        caMobileNo: event.caMobileNo,
        caAlternateMobileNo: event.caAlternateMobileNo,
        caType: event.caType,
        caBadge: event.caBadge,
        caIsDefault: event.caIsDefault,
      );

      emit(
        state.copyWith(
          status: AddressStatus.added,
          message: "Address added successfully!",
        ),
      );
      add(FetchAddressesEvent(cId: event.cId));
    } catch (e) {
      final errorMsg = e.toString().replaceFirst('Exception: ', '');
      emit(state.copyWith(status: AddressStatus.addError, message: errorMsg));
    }
  }

  Future<void> _onUpdateAddress(
    UpdateAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(status: AddressStatus.adding));
    try {
      await _addressesRepo.updateAddress(
        caId: event.caId,
        cId: event.cId,
        caName: event.caName,
        caAddress1: event.caAddress1,
        caAddress2: event.caAddress2,
        caLocality: event.caLocality,
        caCity: event.caCity,
        caState: event.caState,
        caPincode: event.caPincode,
        caMobileNo: event.caMobileNo,
        caAlternateMobileNo: event.caAlternateMobileNo,
        caType: event.caType,
        caBadge: event.caBadge,
        caIsDefault: event.caIsDefault,
      );

      emit(
        state.copyWith(
          status: AddressStatus.added,
          message: "Address updated successfully!",
        ),
      );
      add(FetchAddressesEvent(cId: event.cId));
    } catch (e) {
      final errorMsg = e.toString().replaceFirst('Exception: ', '');
      emit(state.copyWith(status: AddressStatus.addError, message: errorMsg));
    }
  }

  Future<void> _onDeleteAddress(
    DeleteAddressEvent event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(status: AddressStatus.deleting));
    try {
      await _addressesRepo.deleteAddress(caId: event.caId, cId: event.cId);
      emit(
        state.copyWith(
          status: AddressStatus.deleted,
          message: "Address deleted successfully!",
        ),
      );
      add(FetchAddressesEvent(cId: event.cId));
    } catch (e) {
      final errorMsg = e.toString().replaceFirst('Exception: ', '');
      emit(
        state.copyWith(status: AddressStatus.deleteError, message: errorMsg),
      );
    }
  }
}
