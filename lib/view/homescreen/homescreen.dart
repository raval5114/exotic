import 'package:exotic/view/wishlist/wishlist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class Homescreen extends StatelessWidget {
  final Widget child;
  final String location;

  const Homescreen({super.key, required this.child, required this.location});

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/categories');
        break;
      case 2:
        context.go('/cart');
        break;
      case 3:
        context.go('/profile');
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
  }) {
    return SvgPicture.asset(
      isActive ? filledPath : outlinedPath,
      width: 24,
      height: 24,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getIndex();

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onItemTapped(context, index),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
            icon: _navIcon(
              filledPath: 'assets/icons/navbar_home_filled.svg',
              outlinedPath: 'assets/icons/navbar_home.svg',
              isActive: currentIndex == 0,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _navIcon(
              filledPath: 'assets/icons/navbar_categories_filled.svg',
              outlinedPath: 'assets/icons/navbar_categories.svg',
              isActive: currentIndex == 1,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _navIcon(
              filledPath: 'assets/icons/navbar_cartlist_filled.svg',
              outlinedPath: 'assets/icons/navbar_cartlist.svg',
              isActive: currentIndex == 2,
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _navIcon(
              filledPath: 'assets/icons/navbar_profile_filled.svg',
              outlinedPath: 'assets/icons/navbar_profile.svg',
              isActive: currentIndex == 3,
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
