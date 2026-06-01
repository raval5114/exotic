import 'package:go_router/go_router.dart';
import 'package:exotic/controllers/Homescreen/EditProfile/editProfile.dart';
import 'package:exotic/data/blocs/auth/bloc/auth_bloc.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

// ─── Brand tokens ─────────────────────────────────────────────────────────────
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
              content: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Profile updated!",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
          _SectionGroup(
            title: "Notifications",
            items: [
              _OptionItem(
                icon: Icons.notifications_none_rounded,
                label: "Latest Updates & Offers",
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 2),
          _SectionGroup(
            title: "Account Settings",
            items: [
              _OptionItem(
                icon: Icons.person_outline_rounded,
                label: "Edit Profile",
                onTap: () => context.push(
                  '/dynamicRoute',
                  extra: () => EditProfile(),
                ),
              ),
              _OptionItem(
                icon: Icons.credit_card_outlined,
                label: "Saved Cards & Gift Cards",
                onTap: () {},
              ),
              _OptionItem(
                icon: Icons.location_on_outlined,
                label: "Saved Addresses",
                onTap: () => context.push('/viewAddress'),
              ),
              _OptionItem(
                icon: Icons.language_outlined,
                label: "Select Language",
                onTap: () {},
              ),
              _OptionItem(
                icon: Icons.notifications_active_outlined,
                label: "Notification Settings",
                onTap: () {},
              ),
              _OptionItem(
                icon: Icons.lock_outline_rounded,
                label: "Privacy Center",
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 2),
          _SectionGroup(
            title: "My Activity",
            items: [
              _OptionItem(
                icon: Icons.rate_review_outlined,
                label: "Reviews",
                onTap: () {},
              ),
              _OptionItem(
                icon: Icons.question_answer_outlined,
                label: "Questions & Answers",
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 2),
          _SectionGroup(
            title: "Earn with Xotic",
            items: [
              _OptionItem(
                icon: Icons.storefront_outlined,
                label: "Sell on Xotic",
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 2),
          _SectionGroup(
            title: "Feedback & Information",
            items: [
              _OptionItem(
                icon: Icons.description_outlined,
                label: "Terms, Policies & Licenses",
                onTap: () {},
              ),
              _OptionItem(
                icon: Icons.help_outline_rounded,
                label: "Browse FAQs",
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
  final List<_OptionItem> items;

  const _SectionGroup({required this.title, required this.items});

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
              title,
              style: theme.textTheme.labelMedium?.copyWith(
                color: Colors.black45,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ),
          // Divider beneath header
          const Divider(height: 0.5, thickness: 0.5, indent: 16, endIndent: 16),
          // Items
          ...items.map((item) => item),
        ],
      ),
    );
  }
}

// ─── Option Item ──────────────────────────────────────────────────────────────
class _OptionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OptionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      splashColor: _kBrandSecondary.withOpacity(0.06),
      highlightColor: _kBrandSecondary.withOpacity(0.03),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Icon badge
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: _kBrandSecondary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: _kBrandSecondary, size: 18),
            ),
            const SizedBox(width: 14),
            // Label
            Expanded(
              child: Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Trailing arrow
            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 13,
              color: Colors.black26,
            ),
          ],
        ),
      ),
    );
  }
}
