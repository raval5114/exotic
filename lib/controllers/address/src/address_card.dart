import 'package:exotic/data/blocs/address/bloc/address_bloc.dart';
import 'package:exotic/data/blocs/address/bloc/address_event.dart';
import 'package:exotic/data/models/address_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddressCard extends StatefulWidget {
  final Address address;
  const AddressCard({super.key, required this.address});

  @override
  State<AddressCard> createState() => _AddressCardState();
}

class _AddressCardState extends State<AddressCard> {
  @override
  Widget build(BuildContext context) {
    final isDefault = widget.address.caIsDefault == 1;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color:
          isDefault
              ? Theme.of(context).primaryColor.withOpacity(0.05)
              : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side:
            isDefault
                ? BorderSide(color: Theme.of(context).primaryColor, width: 2)
                : BorderSide.none,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Row(
          children: [
            Text(
              widget.address.caName ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (widget.address.caBadge != null &&
                widget.address.caBadge!.isNotEmpty) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.address.caBadge!,
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
                '${widget.address.caAddress1}${widget.address.caAddress2 != null && widget.address.caAddress2!.isNotEmpty ? ', ${widget.address.caAddress2}' : ''}',
              ),
              Text(
                '${widget.address.caLocality}, ${widget.address.caCity}, ${widget.address.caState} - ${widget.address.caPincode}',
              ),
              const SizedBox(height: 4),
              Text('Mobile: ${widget.address.caMobileNo}'),
              const SizedBox(height: 8),
              if (!isDefault)
                InkWell(
                  onTap: () {
                    if (widget.address.caId != null &&
                        widget.address.cId != null) {
                      context.read<AddressBloc>().add(
                        UpdateAddressEvent(
                          caId: widget.address.caId!,
                          cId: widget.address.cId!,
                          caName: widget.address.caName ?? '',
                          caAddress1: widget.address.caAddress1 ?? '',
                          caAddress2: widget.address.caAddress2 ?? '',
                          caLocality: widget.address.caLocality ?? '',
                          caCity: widget.address.caCity ?? '',
                          caState: widget.address.caState ?? '',
                          caPincode: widget.address.caPincode ?? '',
                          caMobileNo: widget.address.caMobileNo ?? '',
                          caAlternateMobileNo:
                              widget.address.caAlternateMobileNo ?? '',
                          caType: widget.address.caType ?? 'shipping',
                          caBadge: widget.address.caBadge ?? 'Home',
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.grey),
              onPressed: () {
                context.push('/updateAddress', extra: widget.address);
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                if (widget.address.caId != null && widget.address.cId != null) {
                  context.read<AddressBloc>().add(
                    DeleteAddressEvent(
                      caId: widget.address.caId!,
                      cId: widget.address.cId!,
                    ),
                  );
                }
              },
            ),
          ],
        ),
        onTap: () {
          context.push('/updateAddress', extra: widget.address);
        },
      ),
    );
  }
}
