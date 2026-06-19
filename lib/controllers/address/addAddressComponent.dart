import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:exotic/data/blocs/address/bloc/address_bloc.dart';
import 'package:exotic/data/blocs/address/bloc/address_event.dart';
import 'package:exotic/data/blocs/address/bloc/address_state.dart';
import 'package:exotic/data/models/address_model.dart';
import 'package:exotic/data/providers/address_provider.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:exotic/data/helpers/zip_code_getter.dart';

class AddAddressComponent extends StatefulWidget {
  const AddAddressComponent({super.key});

  @override
  State<AddAddressComponent> createState() => _AddAddressComponentState();
}

class _AddAddressComponentState extends State<AddAddressComponent> {
  final _formKey = GlobalKey<FormState>();
  Timer? _debounce;
  final TextEditingController _countryController = TextEditingController();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _address1Controller = TextEditingController();
  final TextEditingController _address2Controller = TextEditingController();
  final TextEditingController _localityController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _altMobileController = TextEditingController();
  final TextEditingController _badgeController = TextEditingController();

  bool _isDefault = false;
  String _selectedBadge = 'Home';

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user;
    if (user != null) {
      _nameController.text = '${user.firstName} ${user.lastName}';
      _mobileController.text = user.phone;
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _nameController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _localityController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    _mobileController.dispose();
    _altMobileController.dispose();
    _badgeController.dispose();
    super.dispose();
  }

  Future<void> _fetchLocation(String pincode) async {
    if (pincode.isEmpty) return;

    final locationData = await fetchIndiaLocation(pincode: pincode);

    if (locationData != null && mounted) {
      setState(() {
        _stateController.text = locationData["state"] ?? "";
        _cityController.text = locationData["city"] ?? "";
        _countryController.text = "India";
      });
    }
  }

  void _saveAddress(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AddressBloc>().add(
        AddAddressEvent(
          cId: context.read<UserProvider>().user?.customerId ?? 0,
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
              _selectedBadge == 'Other'
                  ? (_badgeController.text.trim().isEmpty
                      ? 'Other'
                      : _badgeController.text.trim())
                  : _selectedBadge,
          caIsDefault: _isDefault ? 1 : 0,
        ),
      );
      // if (_isDefault) {
      //   context.read<AddressProvider>().setDefaultAddress(
      //     context.read<AddressBloc>().state.,
      //   );
      // }
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onFoucusOver,
    void Function(String)? onChanged,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus && onFoucusOver != null) {
            onFoucusOver();
          }
        },
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          onChanged: onChanged,
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
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter $label';
                }
                return null;
              },
        ),
      ),
    );
  }

  Widget _buildBadgeChip(String label) {
    return ChoiceChip(
      label: Text(label),
      selected: _selectedBadge == label,
      onSelected: (bool selected) {
        if (selected) {
          setState(() {
            _selectedBadge = label;
            if (label != 'Other') {
              _badgeController.clear();
            }
          });
        }
      },
      selectedColor: Theme.of(context).primaryColor,
      labelStyle: TextStyle(
        color: _selectedBadge == label ? Colors.white : Colors.black87,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: BlocConsumer<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state.status == AddressStatus.added) {
            final newAddress = Address(
              caId: DateTime.now().millisecondsSinceEpoch % 100000,
              cId: context.read<UserProvider>().user?.customerId ?? 0,
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
                  _selectedBadge == 'Other'
                      ? (_badgeController.text.trim().isEmpty
                          ? 'Other'
                          : _badgeController.text.trim())
                      : _selectedBadge,
              caIsDefault: _isDefault ? 1 : 0,
              createdAt: DateTime.now().toString(),
            );
            context.read<AddressProvider>().addAddress(newAddress);
            if (_isDefault) {
              final user = context.read<UserProvider>().user;
              if (user != null) {
                context.read<AddressProvider>().setDefaultAddress(
                  newAddress.caId!,
                  user.customerId.toString(),
                );
              }
            }

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Address added successfully!'),
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
                content: Text(state.message ?? 'Failed to add address'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Delivery Details",
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleLarge?.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
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
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter Mobile Number';
                      }
                      if (value.length < 10) {
                        return 'Enter a valid mobile number';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _altMobileController,
                    label: 'Alternate Mobile Number (Optional)',
                    hint: '',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value != null &&
                          value.isNotEmpty &&
                          value.length < 10) {
                        return 'Enter a valid mobile number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Address",
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleLarge?.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildTextField(
                    controller: _pincodeController,
                    label: 'Pincode*',
                    hint: '',
                    onFoucusOver: () {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _fetchLocation(_pincodeController.text.trim());
                    },
                    onChanged: (value) {
                      if (_debounce?.isActive ?? false) _debounce!.cancel();
                      _debounce = Timer(const Duration(seconds: 2), () {
                        _fetchLocation(value.trim());
                      });
                    },
                    keyboardType: TextInputType.number,
                  ),
                  _buildTextField(
                    controller: _address1Controller,
                    label: 'Address(House No. Building Street Area)*',
                    hint: '',
                    maxLines: 2,
                  ),
                  _buildTextField(
                    controller: _localityController,
                    label: 'Locality/ Town*',
                    hint: '',
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _cityController,
                          label: 'City / District*',
                          hint: '',
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTextField(
                          controller: _stateController,
                          label: 'State*',
                          hint: '',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Save address as",
                    style: TextStyle(
                      fontSize:
                          Theme.of(context).textTheme.titleLarge?.fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: Row(
                      children: [
                        _buildBadgeChip('Home'),
                        const SizedBox(width: 8),
                        _buildBadgeChip('Work'),
                        const SizedBox(width: 8),
                        _buildBadgeChip('Other'),
                      ],
                    ),
                  ),
                  if (_selectedBadge == 'Other')
                    _buildTextField(
                      controller: _badgeController,
                      label: 'Custom Badge Name',
                      hint: 'e.g. Vacation Home',
                    ),
                  SwitchListTile(
                    title: Text(
                      'Set as Default Address',
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.titleLarge?.fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    value: _isDefault,
                    onChanged: (val) => setState(() => _isDefault = val),
                    activeThumbColor: Theme.of(context).primaryColor,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed:
                        state.status == AddressStatus.adding
                            ? null
                            : () => _saveAddress(context),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child:
                        state.status == AddressStatus.adding
                            ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Text(
                              'Save Address',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
