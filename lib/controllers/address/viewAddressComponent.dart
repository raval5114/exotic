import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exotic/data/blocs/address/bloc/address_bloc.dart';
import 'package:exotic/data/blocs/address/bloc/address_event.dart';
import 'package:exotic/data/blocs/address/bloc/address_state.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:go_router/go_router.dart';

class ViewAddressComponent extends StatefulWidget {
  const ViewAddressComponent({super.key});

  @override
  State<ViewAddressComponent> createState() => _ViewAddressComponentState();
}

class _ViewAddressComponentState extends State<ViewAddressComponent> {
  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user;
    if (user != null) {
      context.read<AddressBloc>().add(
        FetchAddressesEvent(cId: user.customerId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Addresses'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state.status == AddressStatus.added) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'Address updated successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state.status == AddressStatus.addError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'Failed to update address.'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state.status == AddressStatus.deleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'Address deleted successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state.status == AddressStatus.deleteError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'Failed to delete address.'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == AddressStatus.loading ||
              state.status == AddressStatus.initial ||
              state.status == AddressStatus.deleting) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.status == AddressStatus.error) {
            return Center(child: Text("Error: ${state.message}"));
          }

          final addresses = state.addresses;

          if (addresses.isEmpty) {
            return const Center(child: Text("No saved addresses found."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              final isDefault = address.caIsDefault == 1;

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDefault
                        ? Theme.of(context).primaryColor
                        : Colors.grey.shade200,
                    width: isDefault ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () {
                    context.push('/updateAddress', extra: address);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Top Row: Name, Badge, Default Icon & Action Buttons
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8,
                                runSpacing: 4,
                                children: [
                                  Text(
                                    address.caName ?? '',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  if (address.caBadge != null &&
                                      address.caBadge!.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        address.caBadge!,
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                    ),
                                  if (isDefault)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Theme.of(context).primaryColor,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'Default',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            // Action Buttons
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    context.push('/updateAddress', extra: address);
                                  },
                                  child: const Icon(
                                    Icons.edit_outlined,
                                    color: Colors.black54,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                GestureDetector(
                                  onTap: () {
                                    if (address.caId != null &&
                                        address.cId != null) {
                                      context.read<AddressBloc>().add(
                                        DeleteAddressEvent(
                                          caId: address.caId!,
                                          cId: address.cId!,
                                        ),
                                      );
                                    }
                                  },
                                  child: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.redAccent,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // Address Details
                        Text(
                          '${address.caAddress1}${address.caAddress2 != null && address.caAddress2!.isNotEmpty ? ', ${address.caAddress2}' : ''}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${address.caLocality}, ${address.caCity}, ${address.caState} - ${address.caPincode}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Mobile: ${address.caMobileNo}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        // Set as Default Button
                        if (!isDefault) ...[
                          const SizedBox(height: 14),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8),
                              onTap: () {
                                if (address.caId != null && address.cId != null) {
                                  context.read<AddressBloc>().add(
                                    UpdateAddressEvent(
                                      caId: address.caId!,
                                      cId: address.cId!,
                                      caName: address.caName ?? '',
                                      caAddress1: address.caAddress1 ?? '',
                                      caAddress2: address.caAddress2 ?? '',
                                      caLocality: address.caLocality ?? '',
                                      caCity: address.caCity ?? '',
                                      caState: address.caState ?? '',
                                      caPincode: address.caPincode ?? '',
                                      caMobileNo: address.caMobileNo ?? '',
                                      caAlternateMobileNo:
                                          address.caAlternateMobileNo ?? '',
                                      caType: address.caType ?? 'shipping',
                                      caBadge: address.caBadge ?? 'Home',
                                      caIsDefault: 1,
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Set as Default',
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/addAddress');
        },
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Add New Address'),
      ),
    );
  }
}
