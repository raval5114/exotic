import 'package:exotic/controllers/Homescreen/EditProfile/editProfile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:exotic/data/providers/user_provider.dart';

// ─── Brand tokens ─────────────────────────────────────────────────────────────
const _kBrandPrimary = Color(0xFF7C3AED);
const _kBrandSecondary = Color(0xFF9747FF);

class ProfileScreenSection extends StatelessWidget {
  const ProfileScreenSection({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final theme = Theme.of(context);

    return Column(
      children: [
        // ── Hero Header ──────────────────────────────────────────────────────
        ProfileHeader(user: user, theme: theme),
        const SizedBox(height: 2),
        // ── Quick-action grid ────────────────────────────────────────────────
        ProfileQuickActionsGrid(),
      ],
    );
  }
}

// ─── Header Section ───────────────────────────────────────────────────────────
class ProfileHeader extends StatelessWidget {
  final dynamic user;
  final ThemeData theme;

  const ProfileHeader({super.key, required this.user, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 48, 20, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [_kBrandPrimary, _kBrandSecondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Avatar with ring
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withOpacity(0.6),
                width: 2.5,
              ),
            ),
            child: CircleAvatar(
              radius: 34,
              backgroundColor: Colors.white,
              backgroundImage:
                  user?.profilePhotoUrl != null &&
                          user!.profilePhotoUrl.isNotEmpty
                      ? NetworkImage(user.profilePhotoUrl)
                      : null,
              child:
                  user?.profilePhotoUrl == null || user!.profilePhotoUrl.isEmpty
                      ? Icon(
                        Icons.person_rounded,
                        size: 38,
                        color: _kBrandSecondary,
                      )
                      : null,
            ),
          ),
          const SizedBox(width: 16),

          // Name & email
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user != null
                      ? "${user.firstName} ${user.lastName}".trim()
                      : "Guest User",
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? "Sign in to view info",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white.withOpacity(0.75),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Edit button
          GestureDetector(
            onTap:
                () => context.push('/dynamicRoute', extra: () => EditProfile()),
            child: Container(
              padding: const EdgeInsets.all(9),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.edit_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Quick Actions Grid ───────────────────────────────────────────────────────
class ProfileQuickActionsGrid extends StatelessWidget {
  const ProfileQuickActionsGrid();

  static const _items = [
    (Icons.inventory_2_rounded, 'Orders', '/orderList'),
    (Icons.favorite_rounded, 'Wishlist', '/wishlist'),
    (Icons.card_giftcard_rounded, 'Coupons', '/coupensAndOffers'),
    (Icons.help_rounded, 'Help', ''),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children:
            _items.map((item) {
              final (icon, label, route) = item;
              return Expanded(
                child: _QuickActionTile(
                  icon: icon,
                  label: label,
                  onTap: route.isNotEmpty ? () => context.push(route) : () {},
                ),
              );
            }).toList(),
      ),
    );
  }
}

// ─── Individual Tile ──────────────────────────────────────────────────────────
class _QuickActionTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_QuickActionTile> createState() => _QuickActionTileState();
}

class _QuickActionTileState extends State<_QuickActionTile>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.06,
    );
    _scale = Tween<double>(
      begin: 1.0,
      end: 0.94,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ── Icon bubble ─────────────────────────────────────────────
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF7C3AED), Color(0xFF9747FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C3AED).withOpacity(0.28),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(widget.icon, color: Colors.white, size: 22),
              ),
              const SizedBox(height: 7),

              // ── Label ────────────────────────────────────────────────────
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                  fontFamily: 'Roboto',
                  letterSpacing: 0.1,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
