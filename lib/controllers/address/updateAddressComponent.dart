import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exotic/data/models/address_model.dart';
import 'package:exotic/data/blocs/address/bloc/address_bloc.dart';
import 'package:exotic/data/blocs/address/bloc/address_event.dart';
import 'package:exotic/data/blocs/address/bloc/address_state.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:go_router/go_router.dart';

class UpdateAddressComponent extends StatefulWidget {
  final Address address;
  const UpdateAddressComponent({super.key, required this.address});

  @override
  State<UpdateAddressComponent> createState() => _UpdateAddressComponentState();
}

class _UpdateAddressComponentState extends State<UpdateAddressComponent> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _address1Controller;
  late TextEditingController _address2Controller;
  late TextEditingController _localityController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _pincodeController;
  late TextEditingController _mobileController;
  late TextEditingController _altMobileController;
  late TextEditingController _badgeController;

  late bool _isDefault;

  @override
  void initState() {
    super.initState();
    final address = widget.address;
    _nameController = TextEditingController(text: address.caName ?? '');
    _address1Controller = TextEditingController(text: address.caAddress1 ?? '');
    _address2Controller = TextEditingController(text: address.caAddress2 ?? '');
    _localityController = TextEditingController(text: address.caLocality ?? '');
    _cityController = TextEditingController(text: address.caCity ?? '');
    _stateController = TextEditingController(text: address.caState ?? '');
    _pincodeController = TextEditingController(text: address.caPincode ?? '');
    _mobileController = TextEditingController(text: address.caMobileNo ?? '');
    _altMobileController = TextEditingController(
      text: address.caAlternateMobileNo ?? '',
    );
    _badgeController = TextEditingController(text: address.caBadge ?? '');
    _isDefault = address.caIsDefault == 1;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _localityController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _mobileController.dispose();
    _altMobileController.dispose();
    _badgeController.dispose();
    super.dispose();
  }

  void _updateAddress() {
    if (_formKey.currentState!.validate()) {
      final user = context.read<UserProvider>().user;
      final int? currentCId = widget.address.cId ?? user?.customerId;

      if (widget.address.caId != null && currentCId != null) {
        context.read<AddressBloc>().add(
          UpdateAddressEvent(
            caId: widget.address.caId!,
            cId: currentCId,
            caName: _nameController.text.trim(),
            caAddress1: _address1Controller.text.trim(),
            caAddress2: _address2Controller.text.trim(),
            caLocality: _localityController.text.trim(),
            caCity: _cityController.text.trim(),
            caState: _stateController.text.trim(),
            caPincode: _pincodeController.text.trim(),
            caMobileNo: _mobileController.text.trim(),
            caAlternateMobileNo: _altMobileController.text.trim(),
            caType: 'shipping',
            caBadge:
                _badgeController.text.trim().isEmpty
                    ? 'Home'
                    : _badgeController.text.trim(),
            caIsDefault: _isDefault ? 1 : 0,
          ),
        );
      }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        validator:
            validator ??
            (value) {
              if (value == null || value.trim().isEmpty)
                return 'Please enter $label';
              return null;
            },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Address'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state.status == AddressStatus.added) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'Address updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
            if (GoRouter.of(context).canPop()) {
              context.pop();
            } else {
              Navigator.of(context).pop();
            }
          } else if (state.status == AddressStatus.addError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'Failed to update address.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hint: '',
                ),
                _buildTextField(
                  controller: _mobileController,
                  label: 'Mobile Number',
                  hint: '',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty)
                      return 'Please enter Mobile Number';
                    if (value.length < 10) return 'Enter a valid mobile number';
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _altMobileController,
                  label: 'Alternate Mobile Number (Optional)',
                  hint: '',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value != null && value.isNotEmpty && value.length < 10)
                      return 'Enter a valid mobile number';
                    return null;
                  },
                ),
                _buildTextField(
                  controller: _pincodeController,
                  label: 'Pincode',
                  hint: 'e.g. 400001',
                  keyboardType: TextInputType.number,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _cityController,
                        label: 'City',
                        hint: 'e.g. Mumbai',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _stateController,
                        label: 'State',
                        hint: 'e.g. Maharashtra',
                      ),
                    ),
                  ],
                ),
                _buildTextField(
                  controller: _localityController,
                  label: 'Locality / Area',
                  hint: 'e.g. Central Hub',
                ),
                _buildTextField(
                  controller: _address1Controller,
                  label: 'Address Line 1',
                  hint: 'House No, Building, Street, Area',
                  maxLines: 2,
                ),
                _buildTextField(
                  controller: _address2Controller,
                  label: 'Address Line 2 (Optional)',
                  hint: 'Apartment, Suite, Unit, etc.',
                  maxLines: 2,
                  validator: (v) => null,
                ),
                _buildTextField(
                  controller: _badgeController,
                  label: 'Address Label / Badge (Optional)',
                  hint: 'e.g. Home, Office, Other',
                  validator: (v) => null,
                ),
                SwitchListTile(
                  title: const Text(
                    'Set as Default Address',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  value: _isDefault,
                  onChanged: (val) => setState(() => _isDefault = val),
                  activeColor: Theme.of(context).primaryColor,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                ),
                const SizedBox(height: 24),
                BlocBuilder<AddressBloc, AddressState>(
                  builder: (context, state) {
                    final isLoading = state.status == AddressStatus.adding;
                    return ElevatedButton(
                      onPressed: isLoading ? null : _updateAddress,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child:
                          isLoading
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text(
                                'Update Address',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                    );
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
