import 'package:exotic/controllers/Homescreen/Homepage/src/build_search_bar.dart';
import 'package:exotic/data/providers/homepage_provider.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:exotic/utils/auth_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:exotic/data/blocs/address/bloc/address_bloc.dart';
import 'package:exotic/data/blocs/address/bloc/address_event.dart';
import 'package:exotic/data/blocs/address/bloc/address_state.dart';
import 'package:go_router/go_router.dart';
import 'package:exotic/data/providers/address_provider.dart';

// ─── Animated tab chip ────────────────────────────────────────────────────────
class _AnimatedTabItem extends StatelessWidget {
  final String label;
  final IconData unselectedIcon;
  final IconData selectedIcon;
  final bool isSelected;

  const _AnimatedTabItem({
    required this.label,
    required this.unselectedIcon,
    required this.selectedIcon,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    const brand = Color(0xFF7C3AED);
    final color = isSelected ? brand : Colors.black45;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder:
                (child, anim) => ScaleTransition(scale: anim, child: child),
            child: Icon(
              isSelected ? selectedIcon : unselectedIcon,
              key: ValueKey(isSelected),
              size: 22,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: 11,
              fontFamily: 'Roboto',
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
              color: color,
              letterSpacing: isSelected ? 0.3 : 0,
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}

class ExoticSliverAppBar extends StatefulWidget {
  const ExoticSliverAppBar({super.key, required this.controller});

  final TabController controller;

  @override
  State<ExoticSliverAppBar> createState() => _ExoticSliverAppBarState();
}

class _ExoticSliverAppBarState extends State<ExoticSliverAppBar> {
  // Keep a reference so we can use controller in instance methods.
  TabController get controller => widget.controller;

  @override
  void initState() {
    super.initState();
    // Dispatch FetchAddressesEvent as soon as the app bar mounts, but only
    // when the user is logged in and addresses haven't been fetched yet.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final user = context.read<UserProvider>().user;
      final isLoggedIn = user != null && user.customerId != 0;
      if (!isLoggedIn) return;

      final currentStatus = context.read<AddressBloc>().state.status;
      // Only fire if we haven't already loaded (avoid duplicate fetch).
      if (currentStatus == AddressStatus.initial ||
          currentStatus == AddressStatus.error) {
        context.read<AddressBloc>().add(
          FetchAddressesEvent(cId: user.customerId),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserProvider>().user;
    final isLoggedIn = user != null && user.customerId != 0;
    final defaultAddress = context.watch<AddressProvider>().defaultAddress;

    final String badgeText;
    final IconData badgeIcon;
    final String addressDetails;

    if (defaultAddress != null) {
      badgeText = defaultAddress.caBadge?.toUpperCase() ?? 'HOME';
      final String lowerBadge = badgeText.toLowerCase();
      if (lowerBadge == 'home') {
        badgeIcon = Icons.home_rounded;
      } else if (lowerBadge == 'work' || lowerBadge == 'office') {
        badgeIcon = Icons.work_rounded;
      } else {
        badgeIcon = Icons.location_on_rounded;
      }

      final parts = <String>[];
      if (defaultAddress.caAddress1 != null &&
          defaultAddress.caAddress1!.isNotEmpty) {
        parts.add(defaultAddress.caAddress1!);
      }
      if (defaultAddress.caAddress2 != null &&
          defaultAddress.caAddress2!.isNotEmpty) {
        parts.add(defaultAddress.caAddress2!);
      }
      if (defaultAddress.caLocality != null &&
          defaultAddress.caLocality!.isNotEmpty) {
        parts.add(defaultAddress.caLocality!);
      }
      if (defaultAddress.caCity != null && defaultAddress.caCity!.isNotEmpty) {
        parts.add(defaultAddress.caCity!);
      }
      addressDetails = parts.join(', ');
    } else {
      badgeText = '';
      badgeIcon = Icons.home_rounded;
      addressDetails =
          isLoggedIn
              ? 'Set your delivery address'
              : 'Login to set delivery address';
    }

    return BlocListener<AddressBloc, AddressState>(
      listener: (context, state) {
        if (state.status == AddressStatus.loaded) {
          context.read<AddressProvider>().setAddresses(state.addresses);
        }
      },
      child: Consumer<HomepageProvider>(
        builder: (context, provider, _) {
          final tabs = provider.tabs;

          return SliverAppBar(
            backgroundColor: const Color(0xFF6D28D9),
            pinned: true,
            expandedHeight: 260,
            toolbarHeight: 0,
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF5B21B6),
                    Color(0xFF7C3AED),
                    Color(0xFFAB6BFF),
                  ],
                  stops: [0.0, 0.55, 1.0],
                ),
              ),
              child: FlexibleSpaceBar(
                background: SafeArea(
                  bottom: false,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      // -- Decorative blob top-right --
                      Positioned(
                        top: -24,
                        right: -32,
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.06),
                          ),
                        ),
                      ),
                      // -- Decorative blob bottom-left --
                      Positioned(
                        bottom: 10,
                        left: -48,
                        child: Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                      ),
                      // -- Decorative small dot top-center --
                      Positioned(
                        top: 10,
                        right: 100,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                        ),
                      ),

                      // -- Main content --
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // --- GREETING ROW ---
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        isLoggedIn
                                            ? 'Hey, ${user.firstName} 👋'
                                            : 'Hey, Guest 👋',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white.withValues(
                                            alpha: 0.8,
                                          ),
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                      const SizedBox(height: 1),
                                      const Text(
                                        'What are you looking for?',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.white,
                                          fontFamily: 'Roboto',
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Notification bell
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.15),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withValues(
                                        alpha: 0.3,
                                      ),
                                      width: 1,
                                    ),
                                  ),
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      const Icon(
                                        Icons.notifications_none_rounded,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                      // Unread dot
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Container(
                                          width: 7,
                                          height: 7,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFFFD700),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // --- ADDRESS BAR ---
                            GestureDetector(
                              onTap:
                                  () => _showAddressBottomSheet(
                                    context,
                                    isLoggedIn,
                                  ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.4),
                                    width: 1.2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.08,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 34,
                                      height: 34,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.25,
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withValues(
                                            alpha: 0.5,
                                          ),
                                          width: 1,
                                        ),
                                      ),
                                      child: Icon(
                                        badgeIcon,
                                        size: 17,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (isLoggedIn)
                                            Row(
                                              children: [
                                                Text(
                                                  'Deliver to',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white
                                                        .withValues(alpha: 0.7),
                                                    fontFamily: 'Roboto',
                                                    letterSpacing: 0.3,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                        vertical: 1,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white
                                                        .withValues(
                                                          alpha: 0.25,
                                                        ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    badgeText,
                                                    style: const TextStyle(
                                                      fontSize: 10,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                      color: Colors.white,
                                                      fontFamily: 'Roboto',
                                                      letterSpacing: 0.5,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          const SizedBox(height: 2),
                                          Text(
                                            addressDetails,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                              fontFamily: 'Roboto',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withValues(
                                          alpha: 0.2,
                                        ),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),

                            // --- SEARCH BAR ---
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
                    ],
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(70),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child:
                    tabs.isEmpty
                        ? const SizedBox(
                          height: 70,
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                        : AnimatedBuilder(
                          animation: controller,
                          builder: (context, _) {
                            return TabBar(
                              controller: controller,
                              isScrollable: true,
                              tabAlignment: TabAlignment.start,
                              padding: EdgeInsets.zero,
                              physics: const BouncingScrollPhysics(),
                              dividerColor: Colors.transparent,
                              labelPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              indicator: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: const Color(0xFF7C3AED),
                                    width: 3,
                                  ),
                                ),
                              ),
                              indicatorSize: TabBarIndicatorSize.tab,
                              overlayColor: WidgetStateProperty.all(
                                const Color(0xFF7C3AED).withValues(alpha: 0.07),
                              ),
                              tabs:
                                  tabs.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final e = entry.value;
                                    final selected = controller.index == index;
                                    return Tab(
                                      height: 68,
                                      child: _AnimatedTabItem(
                                        label: e.title,
                                        unselectedIcon: _tabIconOutlined(index),
                                        selectedIcon: _tabIconFilled(index),
                                        isSelected: selected,
                                      ),
                                    );
                                  }).toList(),
                            );
                          },
                        ),
              ),
            ),
          );
        },
      ),
    );
  }

  // Outlined icons for unselected tabs
  IconData _tabIconOutlined(int index) {
    switch (index % 6) {
      case 0:
        return Icons.style_outlined;
      case 1:
        return Icons.checkroom_outlined;
      case 2:
        return Icons.smartphone_outlined;
      case 3:
        return Icons.face_retouching_natural_outlined;
      case 4:
        return Icons.computer_outlined;
      case 5:
        return Icons.weekend_outlined;
      default:
        return Icons.category_outlined;
    }
  }

  // Filled icons for selected tabs
  IconData _tabIconFilled(int index) {
    switch (index % 6) {
      case 0:
        return Icons.style_rounded;
      case 1:
        return Icons.checkroom_rounded;
      case 2:
        return Icons.smartphone_rounded;
      case 3:
        return Icons.face_retouching_natural;
      case 4:
        return Icons.computer_rounded;
      case 5:
        return Icons.weekend_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  void _showAddressBottomSheet(BuildContext context, bool isLoggedIn) {
    if (isLoggedIn) {
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

                // ── Address list: driven by AddressBloc state ─────────────────────────────
                BlocBuilder<AddressBloc, AddressState>(
                  builder: (context, blocState) {
                    // ── Loading ──────────────────────────────────────────────
                    if (blocState.status == AddressStatus.loading) {
                      return _AddressShimmer();
                    }

                    // ── Error ────────────────────────────────────────────────
                    if (blocState.status == AddressStatus.error) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.wifi_off_rounded,
                              color: Colors.black26,
                              size: 36,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              blocState.message ?? 'Failed to load addresses.',
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black45,
                                fontFamily: 'Roboto',
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextButton.icon(
                              onPressed: () {
                                final user = context.read<UserProvider>().user;
                                if (user != null) {
                                  context.read<AddressBloc>().add(
                                    FetchAddressesEvent(cId: user.customerId),
                                  );
                                }
                              },
                              icon: const Icon(
                                Icons.refresh_rounded,
                                size: 16,
                                color: Color(0xFF7C3AED),
                              ),
                              label: const Text(
                                'Retry',
                                style: TextStyle(
                                  color: Color(0xFF7C3AED),
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // ── Loaded / other states: read from AddressProvider ─────
                    return Consumer<AddressProvider>(
                      builder: (context, addrProvider, _) {
                        final addresses = addrProvider.addresses;
                        final defaultAddr = addrProvider.defaultAddress;

                        // Still initial (user not logged in or no fetch yet)
                        if (addresses.isEmpty) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(
                                'No saved addresses found.',
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  color: Colors.black45,
                                ),
                              ),
                            ),
                          );
                        }

                        return Column(
                          children:
                              addresses.take(3).map((addr) {
                                final isDefault =
                                    defaultAddr != null &&
                                    addr.caId != null &&
                                    addr.caId == defaultAddr.caId;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: InkWell(
                                    onTap: () {
                                      if (addr.caId != null && isLoggedIn) {
                                        final user =
                                            context.read<UserProvider>().user;
                                        if (user != null) {
                                          addrProvider.setDefaultAddress(
                                            addr.caId!,
                                            user.customerId.toString(),
                                          );
                                        }
                                      }
                                      Navigator.of(context).pop();
                                    },
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
                                                ).withValues(alpha: 0.04)
                                                : Colors.white,
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                0xFF7C3AED,
                                              ).withValues(alpha: 0.1),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              addr.caBadge?.toLowerCase() ==
                                                      'home'
                                                  ? Icons.home_rounded
                                                  : (addr.caBadge
                                                              ?.toLowerCase() ==
                                                          'work' ||
                                                      addr.caBadge
                                                              ?.toLowerCase() ==
                                                          'office')
                                                  ? Icons.work_rounded
                                                  : Icons.location_on_rounded,
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
                                                      addr.caBadge?.isNotEmpty ==
                                                              true
                                                          ? addr.caBadge!
                                                          : 'Address',
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w700,
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
                                                          ).withValues(
                                                            alpha: 0.12,
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                4,
                                                              ),
                                                        ),
                                                        child: const Text(
                                                          'Default',
                                                          style: TextStyle(
                                                            color: Color(
                                                              0xFF7C3AED,
                                                            ),
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 10,
                                                            fontFamily:
                                                                'Roboto',
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ],
                                                ),
                                                const SizedBox(height: 3),
                                                Text(
                                                  '${addr.caAddress1}'
                                                  '${addr.caAddress2 != null && addr.caAddress2!.isNotEmpty ? ', ${addr.caAddress2}' : ''}'
                                                  ', ${addr.caLocality}, ${addr.caCity}',
                                                  style: const TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 12,
                                                    fontFamily: 'Roboto',
                                                  ),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
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
                    );
                  },
                ),
              ],
            ),
          );
        },
      );
    } else {
      showLoginDialog(context);
    }
  }
}

// ─── Address shimmer shown while AddressBloc is loading ──────────────────────
class _AddressShimmer extends StatefulWidget {
  @override
  State<_AddressShimmer> createState() => _AddressShimmerState();
}

class _AddressShimmerState extends State<_AddressShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) {
        final shimmerColor =
            Color.lerp(Colors.grey[200]!, Colors.grey[100]!, _anim.value)!;
        return Column(
          children: List.generate(2, (i) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                height: 72,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 11,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                          const SizedBox(height: 7),
                          Container(
                            height: 10,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                  ],
                ),
              ),
            );
          }),
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
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}
