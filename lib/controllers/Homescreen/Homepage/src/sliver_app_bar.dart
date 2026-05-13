import 'package:exotic/controllers/Homescreen/Homepage/src/build_search_bar.dart';
import 'package:exotic/data/providers/homepage_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exotic/data/blocs/address/bloc/address_bloc.dart';
import 'package:exotic/data/blocs/address/bloc/address_state.dart';
import 'package:go_router/go_router.dart';

class ExoticSliverAppBar extends StatelessWidget {
  const ExoticSliverAppBar({super.key, required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomepageProvider>(
      builder: (context, provider, _) {
        final tabs = provider.tabs;

        return SliverAppBar(
          backgroundColor: Colors.white,
          pinned: true,
          expandedHeight: 185,
          toolbarHeight: 0,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF9747FF), Colors.white],
              ),
            ),
            child: FlexibleSpaceBar(
              background: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
                  child: Column(
                    children: [
                      // --- ADDRESS BAR ---
                      Ink(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () => _showAddressBottomSheet(context),
                          borderRadius: BorderRadius.circular(12),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  size: 18,
                                  color: Colors.black87,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "388440  ",
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "Add address",
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // --- SEARCH BAR SECTION ---
                      Row(
                        children: [
                          const Expanded(child: BuildSearchBar()),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.qr_code_scanner_rounded,
                              color: Colors.black87,
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(85),
            child: Container(
              color: Colors.transparent,
              child:
                  tabs.isEmpty
                      ? const SizedBox(
                        height: 85,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                      : TabBar(
                        controller: controller,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        physics: const BouncingScrollPhysics(),
                        dividerColor: Colors.grey.shade300,
                        labelColor: Colors.deepPurple,
                        unselectedLabelColor: Colors.black87,
                        labelStyle: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w300),
                        unselectedLabelStyle: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w300),
                        indicator: const UnderlineTabIndicator(
                          borderSide: BorderSide(
                            color: Color(0xFF9747FF),
                            width: 3,
                          ),
                          insets: EdgeInsets.symmetric(horizontal: 16),
                        ),

                        tabs:
                            tabs.asMap().entries.map((entry) {
                              final index = entry.key;
                              final e = entry.value;

                              // Testing icons for tabs
                              IconData iconData;
                              switch (index % 6) {
                                case 0:
                                  iconData = Icons.style_outlined;
                                  break;
                                case 1:
                                  iconData = Icons.checkroom_outlined;
                                  break;
                                case 2:
                                  iconData = Icons.smartphone_outlined;
                                  break;
                                case 3:
                                  iconData = Icons.face_retouching_natural;
                                  break;
                                case 4:
                                  iconData = Icons.computer_outlined;
                                  break;
                                case 5:
                                  iconData = Icons.weekend_outlined;
                                  break;
                                default:
                                  iconData = Icons.category_outlined;
                              }

                              return Tab(
                                icon: Icon(iconData, size: 24),
                                text: e.title ?? "",
                              );
                            }).toList(),
                      ),
            ),
          ),
        );
      },
    );
  }

  void _showAddressBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Add new address",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.push('/addAddress');
                    },
                    icon: const Icon(
                      Icons.add_circle,
                      color: Color(0xFF9747FF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  hintText: "Search your area, street name...",
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF9747FF),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Saved Addresses",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.push('/viewAddress');
                    },
                    child: Text(
                      "View All",
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF9747FF),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              BlocBuilder<AddressBloc, AddressState>(
                builder: (context, state) {
                  if (state.status == AddressStatus.loading ||
                      state.status == AddressStatus.initial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state.status == AddressStatus.error) {
                    return Center(child: Text("Error: ${state.message}"));
                  }

                  final addresses = state.addresses;
                  if (addresses.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("No saved addresses found."),
                      ),
                    );
                  }

                  return Column(
                    children:
                        addresses.take(3).map((addr) {
                          final isDefault = addr.caIsDefault == 1;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        isDefault
                                            ? Theme.of(context).primaryColor
                                            : Colors.grey[200]!,
                                    width: isDefault ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF9747FF,
                                        ).withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        (addr.caBadge?.toLowerCase() == 'home')
                                            ? Icons.home_rounded
                                            : ((addr.caBadge?.toLowerCase() ==
                                                        'work' ||
                                                    addr.caBadge
                                                            ?.toLowerCase() ==
                                                        'office')
                                                ? Icons.work_rounded
                                                : Icons.location_on_rounded),
                                        color: const Color(0xFF9747FF),
                                        size: 20,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                addr.caBadge?.isNotEmpty == true
                                                    ? addr.caBadge!
                                                    : "Address",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleSmall
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              if (isDefault) ...[
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 2,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Theme.of(context)
                                                        .primaryColor
                                                        .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    "Default",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .labelSmall
                                                        ?.copyWith(
                                                          color:
                                                              Theme.of(
                                                                context,
                                                              ).primaryColor,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${addr.caAddress1}${addr.caAddress2 != null && addr.caAddress2!.isNotEmpty ? ', ${addr.caAddress2}' : ''}, ${addr.caLocality}, ${addr.caCity}",
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall?.copyWith(
                                              color: Colors.grey[600],
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right_rounded,
                                      color: Colors.grey,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
