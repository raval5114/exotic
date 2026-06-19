import 'package:exotic/Test/HomepagesTesting/model/interactions/providers/interaction_provider.dart';
import 'package:exotic/data/blocs/address/bloc/address_bloc.dart';
import 'package:exotic/data/blocs/address/bloc/address_event.dart';
import 'package:exotic/data/providers/address_provider.dart';
import 'package:exotic/data/providers/cart_provider.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:exotic/data/providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── Brand tokens ─────────────────────────────────────────────────────────────
const _kBrand = Color(0xFF7C3AED);
const _kBrandSecondary = Color(0xFF9747FF);
const _kDanger = Color(0xFFE53935);

class ProfileScreenLogoutSection extends StatefulWidget {
  const ProfileScreenLogoutSection({super.key});

  @override
  State<ProfileScreenLogoutSection> createState() =>
      _ProfileScreenLogoutSectionState();
}

class _ProfileScreenLogoutSectionState extends State<ProfileScreenLogoutSection>
    with SingleTickerProviderStateMixin {
  bool _isLoading = false;

  // Arrow slide animation (mirrors profileScreenOptions pattern)
  late final AnimationController _ctrl;
  late final Animation<double> _arrowSlide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _arrowSlide = Tween<double>(
      begin: 0,
      end: 4,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

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
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section header (matches profileScreenOptions style) ───────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_kDanger, Color(0xFFFF6B6B)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.manage_accounts_rounded,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Account',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.black54,
                    fontFamily: 'Roboto',
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          // Thin red accent divider
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_kDanger.withOpacity(0.3), _kDanger.withOpacity(0.05)],
              ),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(height: 4),

          // ── Log Out tile ─────────────────────────────────────────────────
          GestureDetector(
            onTapDown: _isLoading ? null : (_) => _ctrl.forward(),
            onTapUp:
                _isLoading
                    ? null
                    : (_) {
                      _ctrl.reverse();
                      _confirmLogout();
                    },
            onTapCancel: () => _ctrl.reverse(),
            child: InkWell(
              onTap: _isLoading ? null : _confirmLogout,
              splashColor: _kDanger.withOpacity(0.06),
              highlightColor: _kDanger.withOpacity(0.03),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    // ── Gradient icon badge ──────────────────────────────────
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            _kDanger.withOpacity(0.12),
                            const Color(0xFFFF6B6B).withOpacity(0.18),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: _kDanger.withOpacity(0.15),
                          width: 1,
                        ),
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
                                size: 19,
                              ),
                    ),
                    const SizedBox(width: 14),

                    // ── Label + subtitle ──────────────────────────────────────
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Log Out',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _kDanger,
                              fontFamily: 'Roboto',
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Sign out of your account',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: Colors.black38,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ],
                      ),
                    ),

                    // ── Animated arrow ────────────────────────────────────────
                    AnimatedBuilder(
                      animation: _arrowSlide,
                      builder:
                          (_, __) => Transform.translate(
                            offset: Offset(_arrowSlide.value, 0),
                            child: Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 13,
                              color: _kDanger.withOpacity(0.45),
                            ),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 4),

          // ── App version watermark ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: Center(
              child: Text(
                'Xotic v1.0.0',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.black26,
                  fontFamily: 'Roboto',
                  letterSpacing: 0.3,
                ),
              ),
            ),
          ),
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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      elevation: 0,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon with gradient ring ───────────────────────────────────
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _kDanger.withOpacity(0.15),
                    _kDanger.withOpacity(0.04),
                  ],
                ),
                border: Border.all(
                  color: _kDanger.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: _kDanger,
                size: 30,
              ),
            ),
            const SizedBox(height: 20),

            // ── Title ─────────────────────────────────────────────────────
            const Text(
              'Log Out?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Colors.black87,
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 8),

            // ── Subtitle ──────────────────────────────────────────────────
            const Text(
              "You'll need to sign in again\nto access your account.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.black45,
                fontFamily: 'Roboto',
                height: 1.55,
              ),
            ),
            const SizedBox(height: 28),

            // ── Actions ───────────────────────────────────────────────────
            Row(
              children: [
                // Cancel
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(dialogCtx, false),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.grey.shade200, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Log Out (red gradient button)
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [_kDanger, Color(0xFFFF6B6B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: _kDanger.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(dialogCtx, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Log Out',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Roboto',
                        ),
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
