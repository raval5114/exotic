import 'package:exotic/controllers/Homescreen/Profile/profileScreenLogutSection.dart';
import 'package:exotic/controllers/Homescreen/Profile/profileScreenOptions.dart';
import 'package:exotic/controllers/Homescreen/Profile/src/profileScreenSection.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Profilescreencontroller extends StatefulWidget {
  const Profilescreencontroller({super.key});

  @override
  State<Profilescreencontroller> createState() =>
      _ProfilescreencontrollerState();
}

class _ProfilescreencontrollerState extends State<Profilescreencontroller> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Pinned gradient header (avatar / name / edit) ────────────────────
        SliverPersistentHeader(
          pinned: true,
          delegate: _PinnedHeaderDelegate(
            child: Consumer<UserProvider>(
              builder: (context, userProvider, _) {
                return ProfileHeader(
                  user: userProvider.user,
                  theme: Theme.of(context),
                );
              },
            ),
          ),
        ),

        // ── Scrollable body ──────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: ColoredBox(
            color: const Color(0xFFF1F3F6),
            child: Column(
              children: [
                const SizedBox(height: 2),
                ProfileQuickActionsGrid(),
                const SizedBox(height: 2),
                ProfileScreenOptions(),
                const SizedBox(height: 2),
                ProfileScreenLogoutSection(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Delegate: fixed height, never collapses ──────────────────────────────────

class _PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  const _PinnedHeaderDelegate({required this.child});

  @override
  double get minExtent => maxExtent;

  /// Height of the gradient header card:
  /// top padding 48 + bottom padding 20 + avatar diameter (34*2) = 156 ≈ 160
  @override
  double get maxExtent => 160;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_PinnedHeaderDelegate oldDelegate) =>
      oldDelegate.child != child;
}
