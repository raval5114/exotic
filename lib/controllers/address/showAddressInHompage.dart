// import 'package:exotic/data/blocs/address/bloc/address_bloc.dart';
// import 'package:exotic/data/blocs/address/bloc/address_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';

// class ShowaddressinHompage extends StatefulWidget {
//   const ShowaddressinHompage({super.key});

//   @override
//   State<ShowaddressinHompage> createState() => _ShowaddressinHompageState();
// }

// class _ShowaddressinHompageState extends State<ShowaddressinHompage> {
//   bool _isLoadingLocation = true;

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       if (mounted) setState(() { _isLoadingLocation = false; });
//       return;
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         if (mounted) setState(() { _isLoadingLocation = false; });
//         return;
//       }
//     }
    
//     if (permission == LocationPermission.deniedForever) {
//       if (mounted) setState(() { _isLoadingLocation = false; });
//       return;
//     } 

//     final position = await Geolocator.getCurrentPosition();
//     if (mounted) {
//       setState(() {
//         _currentLocation = position;
//         _isLoadingLocation = false;
//       });
//     }
//   }

//   Future<void> _useCurrentLocation() async {
//     if (_currentLocation == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Location not available yet.')),
//       );
//       return;
//     }

//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         _currentLocation!.latitude, 
//         _currentLocation!.longitude
//       );
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks.first;
        
//         final Map<String, String> addressData = {
//           'street': [place.name, place.street].where((e) => e != null && e.isNotEmpty).join(', '),
//           'locality': place.subLocality ?? place.locality ?? '',
//           'city': place.locality ?? place.subAdministrativeArea ?? '',
//           'state': place.administrativeArea ?? '',
//           'country': place.country ?? '',
//           'pincode': place.postalCode ?? '',
//         };
        
//         if (mounted) {
//           Navigator.of(context).pop();
//           context.push('/addAddress', extra: addressData);
//         }
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Failed to get address from location.')),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       padding: EdgeInsets.only(
//         top: 16,
//         left: 16,
//         right: 16,
//         bottom: MediaQuery.of(context).viewInsets.bottom + 20,
//       ),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Center(
//             child: Container(
//               width: 40,
//               height: 4,
//               margin: const EdgeInsets.only(bottom: 24),
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Add new address",
//                 style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                   fontWeight: FontWeight.bold,
//                   fontFamily: 'Poppins',
//                 ),
//               ),
//               IconButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   context.push('/addAddress');
//                 },
//                 icon: const Icon(Icons.add_circle, color: Color(0xFF9747FF)),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Text(
//             "Map Location",
//             style: Theme.of(context).textTheme.bodySmall?.copyWith(
//               color: Colors.grey[600],
//             ),
//           ),
//           const SizedBox(height: 8),
//           Container(
//             height: 200,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: Colors.grey[300]!),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: _isLoadingLocation
//                   ? const Center(child: CircularProgressIndicator())
//                   : Stack(
//                       children: [
//                         OlaMap(
//                           apiKey: 'YOUR_API_KEY_HERE',
//                           showCurrentLocation: true,
//                           showMyLocationButton: true,
//                           showZoomControls: true,
//                           onPlatformViewCreated: (controller) {
//                             _olaMapController = controller;
//                             if (_currentLocation != null) {
//                               // Center map to current location
//                               _olaMapController.moveToCurrentLocation();
//                             }
//                           },
//                         ),
//                         Positioned(
//                           bottom: 16,
//                           left: 16,
//                           right: 16,
//                           child: ElevatedButton(
//                             onPressed: _useCurrentLocation,
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Theme.of(context).primaryColor,
//                             ),
//                             child: const Text('Use My Current Location', style: TextStyle(color: Colors.white)),
//                           ),
//                         ),
//                       ],
//                     ),
//             ),
//           ),
//           const SizedBox(height: 24),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 "Saved Addresses",
//                 style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                   color: Colors.grey,
//                   fontFamily: 'Poppins',
//                 ),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(context).pop();
//                   context.push('/viewAddress');
//                 },
//                 child: Text(
//                   "View All",
//                   style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                     fontWeight: FontWeight.w600,
//                     color: const Color(0xFF9747FF),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           BlocBuilder<AddressBloc, AddressState>(
//             builder: (context, state) {
//               if (state.status == AddressStatus.loading ||
//                   state.status == AddressStatus.initial) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (state.status == AddressStatus.error) {
//                 return Center(child: Text("Error: ${state.message}"));
//               }

//               final addresses = state.addresses;
//               if (addresses.isEmpty) {
//                 return const Center(
//                   child: Padding(
//                     padding: EdgeInsets.all(16.0),
//                     child: Text("No saved addresses found."),
//                   ),
//                 );
//               }

//               return Column(
//                 children:
//                     addresses.take(3).map((addr) {
//                       final isDefault = addr.caIsDefault == 1;
//                       return Padding(
//                         padding: const EdgeInsets.only(bottom: 12),
//                         child: InkWell(
//                           onTap: () {
//                             Navigator.of(context).pop();
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.all(12),
//                             decoration: BoxDecoration(
//                               border: Border.all(
//                                 color:
//                                     isDefault
//                                         ? Theme.of(context).primaryColor
//                                         : Colors.grey[200]!,
//                                 width: isDefault ? 2 : 1,
//                               ),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Row(
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(8),
//                                   decoration: BoxDecoration(
//                                     color: const Color(
//                                       0xFF9747FF,
//                                     ).withOpacity(0.1),
//                                     shape: BoxShape.circle,
//                                   ),
//                                   child: Icon(
//                                     (addr.caBadge?.toLowerCase() == 'home')
//                                         ? Icons.home_rounded
//                                         : ((addr.caBadge?.toLowerCase() ==
//                                                     'work' ||
//                                                 addr.caBadge?.toLowerCase() ==
//                                                     'office')
//                                             ? Icons.work_rounded
//                                             : Icons.location_on_rounded),
//                                     color: const Color(0xFF9747FF),
//                                     size: 20,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Text(
//                                             addr.caBadge?.isNotEmpty == true
//                                                 ? addr.caBadge!
//                                                 : "Address",
//                                             style: Theme.of(
//                                               context,
//                                             ).textTheme.titleSmall?.copyWith(
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                           if (isDefault) ...[
//                                             const SizedBox(width: 8),
//                                             Container(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                     horizontal: 6,
//                                                     vertical: 2,
//                                                   ),
//                                               decoration: BoxDecoration(
//                                                 color: Theme.of(
//                                                   context,
//                                                 ).primaryColor.withOpacity(0.1),
//                                                 borderRadius:
//                                                     BorderRadius.circular(4),
//                                               ),
//                                               child: Text(
//                                                 "Default",
//                                                 style: Theme.of(context)
//                                                     .textTheme
//                                                     .labelSmall
//                                                     ?.copyWith(
//                                                       color:
//                                                           Theme.of(
//                                                             context,
//                                                           ).primaryColor,
//                                                       fontWeight:
//                                                           FontWeight.bold,
//                                                     ),
//                                               ),
//                                             ),
//                                           ],
//                                         ],
//                                       ),
//                                       const SizedBox(height: 4),
//                                       Text(
//                                         "${addr.caAddress1}${addr.caAddress2 != null && addr.caAddress2!.isNotEmpty ? ', ${addr.caAddress2}' : ''}, ${addr.caLocality}, ${addr.caCity}",
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .bodySmall
//                                             ?.copyWith(color: Colors.grey[600]),
//                                         maxLines: 1,
//                                         overflow: TextOverflow.ellipsis,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const Icon(
//                                   Icons.chevron_right_rounded,
//                                   color: Colors.grey,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     }).toList(),
//               );
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
