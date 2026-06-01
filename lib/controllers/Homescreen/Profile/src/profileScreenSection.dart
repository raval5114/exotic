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
        _ProfileHeader(user: user, theme: theme),
        const SizedBox(height: 2),
        // ── Quick-action grid ────────────────────────────────────────────────
        _QuickActionsGrid(),
      ],
    );
  }
}

// ─── Header Section ───────────────────────────────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  final dynamic user;
  final ThemeData theme;

  const _ProfileHeader({required this.user, required this.theme});

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
class _QuickActionsGrid extends StatelessWidget {
  const _QuickActionsGrid();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.85,
        children: [
          _QuickActionTile(
            icon: Icons.inventory_2_outlined,
            label: "Orders",
            onTap: () => context.push('/orderList'),
          ),
          _QuickActionTile(
            icon: Icons.favorite_border_rounded,
            label: "Wishlist",
            onTap: () => context.push('/wishlist'),
          ),
          _QuickActionTile(
            icon: Icons.card_giftcard_outlined,
            label: "Coupons",
            onTap: () => context.push('/coupensAndOffers'),
          ),
          _QuickActionTile(
            icon: Icons.help_outline_rounded,
            label: "Help",
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

class _QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: _kBrandSecondary.withOpacity(0.08),
        highlightColor: _kBrandSecondary.withOpacity(0.04),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
          decoration: BoxDecoration(
            color: _kBrandSecondary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _kBrandSecondary.withOpacity(0.12),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _kBrandSecondary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: _kBrandSecondary, size: 20),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
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
