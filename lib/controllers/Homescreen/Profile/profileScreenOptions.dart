import 'package:go_router/go_router.dart';
import 'package:exotic/controllers/Homescreen/EditProfile/editProfile.dart';
import 'package:exotic/data/blocs/auth/bloc/auth_bloc.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

// ─── Brand tokens ─────────────────────────────────────────────────────────────
const _kBrand = Color(0xFF7C3AED);
const _kBrandSecondary = Color(0xFF9747FF);

class ProfileScreenOptions extends StatelessWidget {
  const ProfileScreenOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUpdateUserSuccessState && state.success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Profile updated!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              backgroundColor: const Color(0xFF16A34A),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Notifications ────────────────────────────────────────────────
          _SectionGroup(
            title: 'Notifications',
            icon: Icons.notifications_rounded,
            items: [
              _OptionItem(
                icon: Icons.campaign_rounded,
                label: 'Latest Updates & Offers',
                subtitle: 'Stay tuned for deals',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 2),

          // ── Account Settings ─────────────────────────────────────────────
          _SectionGroup(
            title: 'Account Settings',
            icon: Icons.manage_accounts_rounded,
            items: [
              _OptionItem(
                icon: Icons.person_rounded,
                label: 'Edit Profile',
                subtitle: 'Update your personal info',
                onTap:
                    () => context.push(
                      '/dynamicRoute',
                      extra: () => EditProfile(),
                    ),
              ),
              _OptionItem(
                icon: Icons.credit_card_rounded,
                label: 'Saved Cards & Gift Cards',
                subtitle: 'Manage payment methods',
                onTap: () {},
              ),
              _OptionItem(
                icon: Icons.location_on_rounded,
                label: 'Saved Addresses',
                subtitle: 'View & edit delivery addresses',
                onTap: () => context.push('/viewAddress'),
              ),
              _OptionItem(
                icon: Icons.translate_rounded,
                label: 'Select Language',
                subtitle: 'Choose your preferred language',
                onTap: () {},
              ),
              _OptionItem(
                icon: Icons.notifications_active_rounded,
                label: 'Notification Settings',
                subtitle: 'Control what you receive',
                onTap: () {},
              ),
              _OptionItem(
                icon: Icons.shield_rounded,
                label: 'Privacy Center',
                subtitle: 'Manage your data & privacy',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 2),

          // ── My Activity ──────────────────────────────────────────────────
          _SectionGroup(
            title: 'My Activity',
            icon: Icons.bar_chart_rounded,
            items: [
              _OptionItem(
                icon: Icons.rate_review_rounded,
                label: 'Reviews',
                subtitle: 'Your product reviews',
                onTap: () {},
              ),
              _OptionItem(
                icon: Icons.question_answer_rounded,
                label: 'Questions & Answers',
                subtitle: 'Community Q&A activity',
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 2),

          // ── Earn with Xotic ──────────────────────────────────────────────
          _SectionGroup(
            title: 'Earn with Xotic',
            icon: Icons.storefront_rounded,
            items: [
              _OptionItem(
                icon: Icons.storefront_rounded,
                label: 'Sell on Xotic',
                subtitle: 'Start your own store',
                onTap: () {},
                badge: 'NEW',
              ),
            ],
          ),
          const SizedBox(height: 2),

          // ── Feedback & Information ───────────────────────────────────────
          _SectionGroup(
            title: 'Feedback & Information',
            icon: Icons.info_rounded,
            items: [
              _OptionItem(
                icon: Icons.description_rounded,
                label: 'Terms, Policies & Licenses',
                subtitle: 'Legal information',
                onTap: () {},
              ),
              _OptionItem(
                icon: Icons.help_rounded,
                label: 'Browse FAQs',
                subtitle: 'Find quick answers',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Section Group ────────────────────────────────────────────────────────────
class _SectionGroup extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_OptionItem> items;

  const _SectionGroup({
    required this.title,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Section header pill ──────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_kBrand, _kBrandSecondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: Colors.white, size: 15),
                ),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
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

          // Thin accent divider
          Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _kBrand.withOpacity(0.3),
                  _kBrandSecondary.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(height: 4),

          // Items
          ...items.map((item) => item),

          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// ─── Option Item ──────────────────────────────────────────────────────────────
class _OptionItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  final String? badge;

  const _OptionItem({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.onTap,
    this.badge,
  });

  @override
  State<_OptionItem> createState() => _OptionItemState();
}

class _OptionItemState extends State<_OptionItem>
    with SingleTickerProviderStateMixin {
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      onHover: (v) => v ? _ctrl.forward() : _ctrl.reverse(),
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) => _ctrl.reverse(),
      onTapCancel: () => _ctrl.reverse(),
      splashColor: _kBrandSecondary.withOpacity(0.06),
      highlightColor: _kBrandSecondary.withOpacity(0.03),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // ── Gradient icon badge ────────────────────────────────────────
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    _kBrand.withOpacity(0.12),
                    _kBrandSecondary.withOpacity(0.18),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _kBrand.withOpacity(0.1), width: 1),
              ),
              child: Icon(widget.icon, color: _kBrand, size: 19),
            ),
            const SizedBox(width: 14),

            // ── Label + subtitle ───────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.label,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      if (widget.badge != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF16A34A), Color(0xFF22C55E)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.badge!,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (widget.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      widget.subtitle!,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.black38,
                        fontFamily: 'Roboto',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // ── Animated arrow ─────────────────────────────────────────────
            AnimatedBuilder(
              animation: _arrowSlide,
              builder:
                  (_, __) => Transform.translate(
                    offset: Offset(_arrowSlide.value, 0),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 13,
                      color: _kBrand.withOpacity(0.35),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
