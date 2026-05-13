import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:exotic/data/models/address_model.dart';
import 'package:exotic/Test/SearchProduct/providers/address_provider.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:go_router/go_router.dart';

class AddAddressComponent extends StatefulWidget {
  const AddAddressComponent({super.key});

  @override
  State<AddAddressComponent> createState() => _AddAddressComponentState();
}

class _AddAddressComponentState extends State<AddAddressComponent> {
  final _formKey = GlobalKey<FormState>();

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

  void _saveAddress() {
    if (_formKey.currentState!.validate()) {
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
            _badgeController.text.trim().isEmpty
                ? 'Home'
                : _badgeController.text.trim(),
        caIsDefault: _isDefault ? 1 : 0,
        createdAt: DateTime.now().toString(),
      );

      // Save to Provider
      context.read<AddressProvider>().addAddress(newAddress);

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
        title: const Text('Add New Address'),
        elevation: 0,
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
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
              ElevatedButton(
                onPressed: _saveAddress,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
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
      ),
    );
  }
}
