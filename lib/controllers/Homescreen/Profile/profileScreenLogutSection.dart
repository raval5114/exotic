import 'package:exotic/Test/HomepagesTesting/model/interactions/providers/interaction_provider.dart';
import 'package:exotic/data/blocs/address/bloc/address_bloc.dart';
import 'package:exotic/data/blocs/address/bloc/address_event.dart';
import 'package:exotic/data/providers/address_provider.dart';
import 'package:exotic/data/providers/cart_provider.dart';
import 'package:exotic/data/providers/interaction_provider.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:exotic/data/providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Brand tokens ─────────────────────────────────────────────────────────────
const _kBrandSecondary = Color(0xFF9747FF);
const _kDanger = Color(0xFFE53935);

class ProfileScreenLogoutSection extends StatefulWidget {
  const ProfileScreenLogoutSection({super.key});

  @override
  State<ProfileScreenLogoutSection> createState() =>
      _ProfileScreenLogoutSectionState();
}

class _ProfileScreenLogoutSectionState
    extends State<ProfileScreenLogoutSection> {
  bool _isLoading = false;

  Future<void> _doLogout() async {
    setState(() => _isLoading = true);
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
    if (mounted) {
      // Clear all providers BEFORE navigating so the home screen
      // renders with a clean state (no stale address/cart/user data).
      context.read<AddressProvider>().clearAddress();
      context.read<CartProvider>().clearCart();
      context.read<WishlistProvider>().clear();
      context.read<InteractionTestProvider>().clearAllInteractions();
      context.read<UserProvider>().clearUser();

      // Reset the AddressBloc to initial+empty state so the BlocListener
      // in sliver_app_bar.dart doesn't re-populate AddressProvider with
      // the previous user's stale address data on navigation.
      context.read<AddressBloc>().add(ClearAddressesEvent());

      context.go('/home');
    }
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (ctx) => _LogoutDialog(context: ctx),
    );
    if (confirmed == true) _doLogout();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Text(
              "Account",
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.black45,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ),
          const Divider(height: 0.5, thickness: 0.5, indent: 16, endIndent: 16),

          // Log Out tile
          InkWell(
            onTap: _isLoading ? null : _confirmLogout,
            splashColor: _kDanger.withOpacity(0.06),
            highlightColor: _kDanger.withOpacity(0.03),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  // Icon badge
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: _kDanger.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child:
                        _isLoading
                            ? const Center(
                              child: SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: _kDanger,
                                ),
                              ),
                            )
                            : const Icon(
                              Icons.logout_rounded,
                              color: _kDanger,
                              size: 18,
                            ),
                  ),
                  const SizedBox(width: 14),

                  // Label
                  Expanded(
                    child: Text(
                      "Log Out",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: _kDanger,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 13,
                    color: Colors.black26,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Logout Dialog ────────────────────────────────────────────────────────────
class _LogoutDialog extends StatelessWidget {
  final BuildContext context;
  const _LogoutDialog({required this.context});

  @override
  Widget build(BuildContext dialogCtx) {
    final theme = Theme.of(dialogCtx);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: _kBrandSecondary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: _kBrandSecondary,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),

            // Title
            Text(
              "Log Out?",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Subtitle
            Text(
              "You'll need to sign in again\nto access your account.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.black45,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),

            // Actions
            Row(
              children: [
                // Cancel
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(dialogCtx, false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      side: const BorderSide(color: Color(0xFFE0E0E0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Cancel",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Log Out
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(dialogCtx, true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kBrandSecondary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Log Out",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
