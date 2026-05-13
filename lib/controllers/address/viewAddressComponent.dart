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
          }
        },
        builder: (context, state) {
          if (state.status == AddressStatus.loading ||
              state.status == AddressStatus.initial) {
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

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side:
                      isDefault
                          ? BorderSide(
                            color: Theme.of(context).primaryColor,
                            width: 2,
                          )
                          : BorderSide.none,
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Row(
                    children: [
                      Text(
                        address.caName ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      if (address.caBadge != null &&
                          address.caBadge!.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            address.caBadge!,
                            style: TextStyle(
                              fontSize: 12,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                      ],
                      if (isDefault) ...[
                        const SizedBox(width: 8),
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).primaryColor,
                          size: 16,
                        ),
                      ],
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${address.caAddress1}${address.caAddress2 != null && address.caAddress2!.isNotEmpty ? ', ${address.caAddress2}' : ''}',
                        ),
                        Text(
                          '${address.caLocality}, ${address.caCity}, ${address.caState} - ${address.caPincode}',
                        ),
                        const SizedBox(height: 4),
                        Text('Mobile: ${address.caMobileNo}'),
                        const SizedBox(height: 8),
                        if (!isDefault)
                          InkWell(
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
                            child: Text(
                              'Set as Default',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  trailing: const Icon(Icons.edit, color: Colors.grey),
                  onTap: () {
                    context.push('/updateAddress', extra: address);
                  },
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
