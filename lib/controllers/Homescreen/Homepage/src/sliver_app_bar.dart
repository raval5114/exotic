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
          backgroundColor: const Color(0xFF7C3AED),
          pinned: true,
          expandedHeight: 170,
          toolbarHeight: 0,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF7C3AED), Color(0xFF9F67FF)],
              ),
            ),
            child: FlexibleSpaceBar(
              background: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // --- ADDRESS BAR ---
                      InkWell(
                        onTap: () => _showAddressBottomSheet(context),
                        borderRadius: BorderRadius.circular(10),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              size: 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: RichText(
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: "Deliver to ",
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white70,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                    TextSpan(
                                      text: "388440 ▾",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.35),
                                  width: 1,
                                ),
                              ),
                              child: const Text(
                                "Change",
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                  fontFamily: 'Roboto',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      // --- SEARCH BAR SECTION ---
                      Row(
                        children: [
                          const Expanded(child: BuildSearchBar()),
                          const SizedBox(width: 10),
                          _IconButton(
                            icon: Icons.qr_code_scanner_rounded,
                            onTap: () {},
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
            preferredSize: const Size.fromHeight(48),
            child: Container(
              color: Colors.white,
              child:
                  tabs.isEmpty
                      ? const SizedBox(
                        height: 48,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                      : TabBar(
                        controller: controller,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        padding: EdgeInsets.zero,
                        physics: const BouncingScrollPhysics(),
                        dividerColor: Colors.grey.shade200,
                        dividerHeight: 1,
                        labelColor: const Color(0xFF7C3AED),
                        unselectedLabelColor: Colors.black54,
                        labelStyle: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          letterSpacing: 0.1,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontFamily: 'Roboto',
                          fontWeight: FontWeight.w400,
                          fontSize: 13,
                        ),
                        indicator: const UnderlineTabIndicator(
                          borderSide: BorderSide(
                            color: Color(0xFF7C3AED),
                            width: 2.5,
                          ),
                          insets: EdgeInsets.symmetric(horizontal: 12),
                        ),
                        tabs:
                            tabs.asMap().entries.map((entry) {
                              final index = entry.key;
                              final e = entry.value;
                              final iconData = _tabIcon(index);
                              return Tab(
                                height: 46,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(iconData, size: 16),
                                    const SizedBox(width: 6),
                                    Text(e.title),
                                  ],
                                ),
                              );
                            }).toList(),
                      ),
            ),
          ),
        );
      },
    );
  }

  IconData _tabIcon(int index) {
    switch (index % 6) {
      case 0:
        return Icons.style_outlined;
      case 1:
        return Icons.checkroom_outlined;
      case 2:
        return Icons.smartphone_outlined;
      case 3:
        return Icons.face_retouching_natural;
      case 4:
        return Icons.computer_outlined;
      case 5:
        return Icons.weekend_outlined;
      default:
        return Icons.category_outlined;
    }
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
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Delivery Address",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Roboto',
                      color: Colors.black,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      context.push('/addAddress');
                    },
                    icon: const Icon(
                      Icons.add_rounded,
                      size: 18,
                      color: Color(0xFF7C3AED),
                    ),
                    label: const Text(
                      "Add New",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7C3AED),
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.search_rounded,
                      color: Color(0xFF7C3AED),
                      size: 20,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: "Search your area, street name...",
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.black38,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Saved Addresses",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                      context.push('/viewAddress');
                    },
                    child: const Text(
                      "View All",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF7C3AED),
                        fontFamily: 'Roboto',
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
                              onTap: () => Navigator.of(context).pop(),
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        isDefault
                                            ? const Color(0xFF7C3AED)
                                            : Colors.grey.shade200,
                                    width: isDefault ? 1.5 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  color:
                                      isDefault
                                          ? const Color(
                                            0xFF7C3AED,
                                          ).withOpacity(0.04)
                                          : Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF7C3AED,
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
                                        color: const Color(0xFF7C3AED),
                                        size: 18,
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
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                  fontFamily: 'Roboto',
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
                                                    color: const Color(
                                                      0xFF7C3AED,
                                                    ).withOpacity(0.12),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4,
                                                        ),
                                                  ),
                                                  child: const Text(
                                                    "Default",
                                                    style: TextStyle(
                                                      color: Color(0xFF7C3AED),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 10,
                                                      fontFamily: 'Roboto',
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            "${addr.caAddress1}${addr.caAddress2 != null && addr.caAddress2!.isNotEmpty ? ', ${addr.caAddress2}' : ''}, ${addr.caLocality}, ${addr.caCity}",
                                            style: const TextStyle(
                                              color: Colors.black45,
                                              fontSize: 12,
                                              fontFamily: 'Roboto',
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Icon(
                                      Icons.chevron_right_rounded,
                                      color: Colors.black26,
                                      size: 20,
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

class _IconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _IconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
