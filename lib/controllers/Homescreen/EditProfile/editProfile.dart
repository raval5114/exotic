import 'dart:io';

import 'package:exotic/data/blocs/auth/bloc/auth_bloc.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// ─── Brand tokens ─────────────────────────────────────────────────────────────
const _kBrandPrimary = Color(0xFF7C3AED);
const _kBrandSecondary = Color(0xFF9747FF);

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController mobileController;
  late TextEditingController emailController;

  bool isEditingMobile = false;
  bool isEditingEmail = false;

  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() => _selectedImage = File(pickedFile.path));
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user;
    firstNameController = TextEditingController(text: user?.firstName ?? '');
    lastNameController = TextEditingController(text: user?.lastName ?? '');
    mobileController = TextEditingController(text: user?.phone ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    mobileController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUpdateUserSuccessState) {
          if (state.success) {
            final userProvider = context.read<UserProvider>();
            if (userProvider.user != null) {
              final user = userProvider.user!;
              user.firstName = firstNameController.text;
              user.lastName = lastNameController.text;
              user.phone = mobileController.text;
              user.email = emailController.text;
              userProvider.setUser(user);
            }
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
                      "Profile updated successfully!",
                      style: theme.textTheme.bodyMedium?.copyWith(
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
            context.pop();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Failed to update profile.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: const Color(0xFFDC2626),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          }
        } else if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
              backgroundColor: const Color(0xFFDC2626),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              margin: const EdgeInsets.all(16),
            ),
          );
        }
      },
      builder: (context, state) {
        final user = context.watch<UserProvider>().user;
        final hasProfileImage =
            user?.profilePhotoUrl != null &&
            user?.profilePhotoUrl.isNotEmpty == true;

        return Scaffold(
          backgroundColor: const Color(0xFFF1F3F6),
          appBar: AppBar(
            backgroundColor: _kBrandPrimary,
            elevation: 0,
            scrolledUnderElevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => context.pop(),
            ),
            title: Text(
              "Personal Details",
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                // ── Avatar header banner ─────────────────────────────────────
                _AvatarBanner(
                  selectedImage: _selectedImage,
                  hasProfileImage: hasProfileImage,
                  profilePhotoUrl: user?.profilePhotoUrl,
                  onPickImage: _pickImage,
                ),

                const SizedBox(height: 8),

                // ── Display name & email ─────────────────────────────────────
                Text(
                  "${firstNameController.text} ${lastNameController.text}"
                      .trim(),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  emailController.text.isNotEmpty
                      ? emailController.text
                      : "No email set",
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.black45,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 20),

                // ── Form card ────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile section
                        _SectionHeader(
                          icon: Icons.account_circle_outlined,
                          title: "PROFILE",
                        ),
                        const SizedBox(height: 16),
                        _ElegantTextField(
                          label: "First Name",
                          controller: firstNameController,
                          prefixIcon: Icons.badge_outlined,
                        ),
                        const SizedBox(height: 14),
                        _ElegantTextField(
                          label: "Last Name",
                          controller: lastNameController,
                          prefixIcon: Icons.person_outline_rounded,
                        ),

                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Divider(
                            height: 0.5,
                            thickness: 0.5,
                            color: Color(0xFFEEEEEE),
                          ),
                        ),

                        // Contact section
                        _SectionHeader(
                          icon: Icons.contact_mail_outlined,
                          title: "CONTACT",
                        ),
                        const SizedBox(height: 16),
                        _StatusField(
                          label: "Mobile Number",
                          controller: mobileController,
                          isEditing: isEditingMobile,
                          status: "Verified",
                          icon: Icons.phone_android_rounded,
                          onToggle:
                              () => setState(
                                () => isEditingMobile = !isEditingMobile,
                              ),
                        ),
                        const SizedBox(height: 12),
                        _StatusField(
                          label: "Email ID",
                          controller: emailController,
                          isEditing: isEditingEmail,
                          status: "Verified",
                          icon: Icons.alternate_email_rounded,
                          onToggle:
                              () => setState(
                                () => isEditingEmail = !isEditingEmail,
                              ),
                        ),

                        const SizedBox(height: 24),

                        // Save button
                        _SaveButton(
                          state: state,
                          onSave: () {
                            final user = context.read<UserProvider>().user;
                            if (user != null) {
                              context.read<AuthBloc>().add(
                                AuthUpdateUserEvent(
                                  cId: user.customerId.toString(),
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                  email: emailController.text,
                                  phone: mobileController.text,
                                  profilePhoto: _selectedImage,
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Avatar Banner ─────────────────────────────────────────────────────────────
class _AvatarBanner extends StatelessWidget {
  final File? selectedImage;
  final bool hasProfileImage;
  final String? profilePhotoUrl;
  final VoidCallback onPickImage;

  const _AvatarBanner({
    required this.selectedImage,
    required this.hasProfileImage,
    required this.profilePhotoUrl,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Gradient banner strip
        Container(
          height: 80,
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 52),
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
        ),

        // Avatar stack
        Stack(
          children: [
            // White ring + avatar
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: _kBrandSecondary.withOpacity(0.25),
                    blurRadius: 16,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 52,
                backgroundColor: _kBrandSecondary.withOpacity(0.08),
                backgroundImage:
                    selectedImage != null
                        ? FileImage(selectedImage!) as ImageProvider
                        : (hasProfileImage
                            ? NetworkImage(profilePhotoUrl ?? '')
                            : null),
                child:
                    selectedImage == null && !hasProfileImage
                        ? const Icon(
                          Icons.add_a_photo_rounded,
                          size: 44,
                          color: _kBrandSecondary,
                        )
                        : null,
              ),
            ),

            // Upload badge
            Positioned(
              bottom: 4,
              right: 4,
              child: GestureDetector(
                onTap: onPickImage,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [_kBrandPrimary, _kBrandSecondary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.upload_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Section Header ────────────────────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: _kBrandSecondary),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
            color: Colors.black38,
          ),
        ),
      ],
    );
  }
}

// ─── Elegant Text Field ────────────────────────────────────────────────────────
class _ElegantTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final IconData? prefixIcon;
  final TextInputType keyboardType;
  final String? helperText;

  const _ElegantTextField({
    required this.label,
    required this.controller,
    this.prefixIcon,
    this.keyboardType = TextInputType.text,
    this.helperText,
  });

  @override
  State<_ElegantTextField> createState() => _ElegantTextFieldState();
}

class _ElegantTextFieldState extends State<_ElegantTextField> {
  final FocusNode _focus = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() => _isFocused = _focus.hasFocus));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow:
            _isFocused
                ? [
                  BoxShadow(
                    color: _kBrandSecondary.withOpacity(0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
                : [],
      ),
      child: TextField(
        controller: widget.controller,
        focusNode: _focus,
        keyboardType: widget.keyboardType,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          labelText: widget.label,
          labelStyle: theme.textTheme.bodySmall?.copyWith(
            color: _isFocused ? _kBrandSecondary : Colors.black45,
            fontWeight: FontWeight.w600,
          ),
          floatingLabelStyle: theme.textTheme.labelSmall?.copyWith(
            color: _kBrandSecondary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
          prefixIcon:
              widget.prefixIcon != null
                  ? Icon(
                    widget.prefixIcon,
                    size: 18,
                    color: _isFocused ? _kBrandSecondary : Colors.black38,
                  )
                  : null,
          helperText: widget.helperText,
          helperStyle: theme.textTheme.labelSmall?.copyWith(
            color: Colors.black38,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _kBrandSecondary, width: 2),
          ),
          filled: true,
          fillColor:
              _isFocused
                  ? _kBrandSecondary.withOpacity(0.03)
                  : const Color(0xFFFAFAFA),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}

// ─── Status Field ─────────────────────────────────────────────────────────────
class _StatusField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isEditing;
  final String status;
  final IconData icon;
  final VoidCallback onToggle;

  const _StatusField({
    required this.label,
    required this.controller,
    required this.isEditing,
    required this.status,
    required this.icon,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Header row: label + toggle button ──────────────────────────────
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black54,
              ),
            ),
            // Animated UPDATE ↔ DONE chip
            GestureDetector(
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color:
                      isEditing
                          ? const Color(0xFF16A34A).withOpacity(0.1)
                          : _kBrandSecondary.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        isEditing
                            ? const Color(0xFF16A34A).withOpacity(0.4)
                            : _kBrandSecondary.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      transitionBuilder:
                          (child, anim) =>
                              ScaleTransition(scale: anim, child: child),
                      child: Icon(
                        isEditing
                            ? Icons.check_circle_outline_rounded
                            : Icons.edit_outlined,
                        key: ValueKey(isEditing),
                        size: 13,
                        color:
                            isEditing
                                ? const Color(0xFF16A34A)
                                : _kBrandSecondary,
                      ),
                    ),
                    const SizedBox(width: 5),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 180),
                      child: Text(
                        isEditing ? "Done" : "Edit",
                        key: ValueKey(isEditing),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color:
                              isEditing
                                  ? const Color(0xFF16A34A)
                                  : _kBrandSecondary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // ── Display ↔ Edit cross-fade ──────────────────────────────────────
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 220),
          crossFadeState:
              isEditing ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          sizeCurve: Curves.easeInOut,

          // ── Read-only display card ────────────────────────────────────────
          firstChild: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200, width: 1.5),
            ),
            child: Row(
              children: [
                // Icon badge
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: _kBrandSecondary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 17, color: _kBrandSecondary),
                ),
                const SizedBox(width: 12),
                // Value
                Expanded(
                  child: Text(
                    controller.text.isNotEmpty ? controller.text : "Not set",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color:
                          controller.text.isNotEmpty
                              ? Colors.black87
                              : Colors.black38,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                // Verified badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.verified_rounded,
                        size: 11,
                        color: Color(0xFF16A34A),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        status,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: const Color(0xFF16A34A),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Edit input ────────────────────────────────────────────────────
          secondChild: TextField(
            controller: controller,
            autofocus: isEditing,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 14, right: 10),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: _kBrandSecondary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 17, color: _kBrandSecondary),
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 60,
                minHeight: 52,
              ),
              suffixIcon: GestureDetector(
                onTap: onToggle,
                child: Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: const Color(0xFF16A34A),
                    size: 22,
                  ),
                ),
              ),
              suffixIconConstraints: const BoxConstraints(
                minWidth: 48,
                minHeight: 52,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(
                  color: _kBrandSecondary,
                  width: 1.5,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: _kBrandSecondary, width: 2),
              ),
              filled: true,
              fillColor: _kBrandSecondary.withOpacity(0.03),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Save Button ──────────────────────────────────────────────────────────────
class _SaveButton extends StatelessWidget {
  final AuthState state;
  final VoidCallback onSave;

  const _SaveButton({required this.state, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isLoading = state is AuthUpdateUserLoadingState;

    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [_kBrandPrimary, _kBrandSecondary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: _kBrandPrimary.withOpacity(0.35),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: isLoading ? null : onSave,
          borderRadius: BorderRadius.circular(14),
          splashColor: Colors.white.withOpacity(0.12),
          child: Center(
            child:
                isLoading
                    ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                    : Text(
                      "Save Changes",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.4,
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
