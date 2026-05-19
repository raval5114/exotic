import 'package:exotic/view/wishlist/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:exotic/utils/auth_dialog.dart';

import 'package:exotic/data/providers/user_provider.dart';
import 'package:provider/provider.dart';

class Homescreen extends StatelessWidget {
  final Widget child;
  final String location;

  const Homescreen({super.key, required this.child, required this.location});

  void _onItemTapped(BuildContext context, int index) {
    if (_getIndex() == index) return;

    final user = context.read<UserProvider>().user;
    final isLoggedIn = user != null && user.customerId != 0;

    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/categories');
        break;
      case 2:
        if (isLoggedIn) {
          context.go('/cart');
        } else {
          showLoginDialog(context);
        }
        break;
      case 3:
        if (isLoggedIn) {
          context.go('/profile');
        } else {
          showLoginDialog(context);
        }
        break;
    }
  }

  int _getIndex() {
    if (location.startsWith('/categories')) return 1;
    if (location.startsWith('/cart')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  Widget _navIcon({
    required String filledPath,
    required String outlinedPath,
    required bool isActive,
    required BuildContext context,
  }) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      transitionBuilder: (child, animation) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.85, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
      child: SvgPicture.asset(
        isActive ? filledPath : outlinedPath,
        key: ValueKey<bool>(isActive),
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          isActive
              ? Theme.of(context).colorScheme.primary
              : Colors.grey.shade500,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required String filledPath,
    required String outlinedPath,
    required String label,
    required int index,
    required int currentIndex,
  }) {
    final isActive = currentIndex == index;
    final theme = Theme.of(context);

    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _onItemTapped(context, index),
        child: Container(
          color: Colors.transparent, // Ensures the whole area is clickable
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              _navIcon(
                filledPath: filledPath,
                outlinedPath: outlinedPath,
                isActive: isActive,
                context: context,
              ),
              const SizedBox(height: 6),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 200),
                style: TextStyle(
                  fontSize: isActive ? 12 : 11,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  color:
                      isActive
                          ? theme.colorScheme.primary
                          : Colors.grey.shade500,
                ),
                child: Text(label),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getIndex();

    return Scaffold(
      body: child,
      bottomNavigationBar: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / 4; // 4 nav items
          const indicatorWidth = 36.0;
          final indicatorLeftPosition =
              currentIndex * tabWidth + (tabWidth - indicatorWidth) / 2;

          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  spreadRadius: 0,
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNavItem(
                        context: context,
                        filledPath: 'assets/icons/navbar_home_filled.svg',
                        outlinedPath: 'assets/icons/navbar_home.svg',
                        label: 'Home',
                        index: 0,
                        currentIndex: currentIndex,
                      ),
                      _buildNavItem(
                        context: context,
                        filledPath: 'assets/icons/navbar_categories_filled.svg',
                        outlinedPath: 'assets/icons/navbar_categories.svg',
                        label: 'Categories',
                        index: 1,
                        currentIndex: currentIndex,
                      ),
                      _buildNavItem(
                        context: context,
                        filledPath: 'assets/icons/navbar_cartlist_filled.svg',
                        outlinedPath: 'assets/icons/navbar_cartlist.svg',
                        label: 'Cart',
                        index: 2,
                        currentIndex: currentIndex,
                      ),
                      _buildNavItem(
                        context: context,
                        filledPath: 'assets/icons/navbar_profile_filled.svg',
                        outlinedPath: 'assets/icons/navbar_profile.svg',
                        label: 'Profile',
                        index: 3,
                        currentIndex: currentIndex,
                      ),
                    ],
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutBack, // Playful switching bounce
                    top: 0,
                    left: indicatorLeftPosition,
                    child: Container(
                      height: 4,
                      width: indicatorWidth,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
