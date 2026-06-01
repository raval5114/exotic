import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    HapticFeedback.selectionClick();

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

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getIndex();

    return Scaffold(
      body: child,
      bottomNavigationBar: _ExoticNavBar(
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(context, index),
      ),
    );
  }
}

/// Production-quality bottom navigation bar
class _ExoticNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _ExoticNavBar({required this.currentIndex, required this.onTap});

  static const _items = [
    _NavItem(
      label: 'Home',
      filledPath: 'assets/icons/navbar_home_filled.svg',
      outlinedPath: 'assets/icons/navbar_home.svg',
    ),
    _NavItem(
      label: 'Categories',
      filledPath: 'assets/icons/navbar_categories_filled.svg',
      outlinedPath: 'assets/icons/navbar_categories.svg',
    ),
    _NavItem(
      label: 'Cart',
      filledPath: 'assets/icons/navbar_cartlist_filled.svg',
      outlinedPath: 'assets/icons/navbar_cartlist.svg',
    ),
    _NavItem(
      label: 'Profile',
      filledPath: 'assets/icons/navbar_profile_filled.svg',
      outlinedPath: 'assets/icons/navbar_profile.svg',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, -4),
          ),
        ],
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.12), width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: List.generate(_items.length, (index) {
              return _NavTile(
                item: _items[index],
                isActive: currentIndex == index,
                onTap: () => onTap(index),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final String filledPath;
  final String outlinedPath;

  const _NavItem({
    required this.label,
    required this.filledPath,
    required this.outlinedPath,
  });
}

class _NavTile extends StatefulWidget {
  final _NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavTile({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavTile> createState() => _NavTileState();
}

class _NavTileState extends State<_NavTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pillAnim;

  static const _brandColor = Color(0xFF7C3AED);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _pillAnim = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    if (widget.isActive) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(_NavTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.forward(from: 0);
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: SizedBox(
          height: 62,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final t = _pillAnim.value;
              final iconColor =
                  Color.lerp(Colors.grey.shade500, _brandColor, t)!;
              final labelColor =
                  Color.lerp(Colors.grey.shade500, _brandColor, t)!;
              final pillOpacity = t;
              final iconScale = 1.0 + (t * 0.08); // subtle grow on activate

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon with active pill indicator background
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Animated pill background
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOutCubic,
                        width: widget.isActive ? 52 : 0,
                        height: widget.isActive ? 32 : 0,
                        decoration: BoxDecoration(
                          color: _brandColor.withOpacity(0.10 * pillOpacity),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      // Icon
                      Transform.scale(
                        scale: iconScale,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 220),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                              scale: Tween<double>(
                                begin: 0.8,
                                end: 1.0,
                              ).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutBack,
                                ),
                              ),
                              child: FadeTransition(
                                opacity: animation,
                                child: child,
                              ),
                            );
                          },
                          child: SvgPicture.asset(
                            widget.isActive
                                ? widget.item.filledPath
                                : widget.item.outlinedPath,
                            key: ValueKey<bool>(widget.isActive),
                            width: 22,
                            height: 22,
                            colorFilter: ColorFilter.mode(
                              iconColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // Label
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: widget.isActive ? 11.5 : 10.5,
                      fontWeight:
                          widget.isActive ? FontWeight.w700 : FontWeight.w400,
                      color: labelColor,
                      fontFamily: 'Roboto',
                      letterSpacing: widget.isActive ? 0.1 : 0,
                    ),
                    child: Text(widget.item.label),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
