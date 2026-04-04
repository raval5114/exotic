import 'dart:io';

import 'package:exotic/data/blocs/auth/bloc/auth_bloc.dart';
import 'package:exotic/data/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

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
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
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
    final secondaryColor = theme.colorScheme.secondary;

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
              const SnackBar(content: Text("Profile updated successfully!")),
            );
            Navigator.pop(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to update profile.")),
            );
          }
        } else if (state is AuthErrorState) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        final user = context.watch<UserProvider>().user;
        final hasProfileImage =
            user?.profilePhotoUrl != null &&
            user?.profilePhotoUrl.isNotEmpty == true;
        return Scaffold(
          backgroundColor: const Color(0xFFFBFBFE),
          appBar: AppBar(
            title: const Text(
              "Personal Details",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 20,
                letterSpacing: -0.5,
              ),
            ),
            backgroundColor: secondaryColor,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 60),
                      child: Container(
                        height: 140,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(32),
                            bottomRight: Radius.circular(32),
                          ),
                        ),
                      ),
                    ),
                    Stack(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: secondaryColor.withOpacity(0.3),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: CircleAvatar(
                            radius: 54,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: secondaryColor.withOpacity(0.1),
                              backgroundImage:
                                  _selectedImage != null
                                      ? FileImage(_selectedImage!)
                                          as ImageProvider
                                      : (hasProfileImage
                                          ? NetworkImage(
                                            user?.profilePhotoUrl ?? '',
                                          )
                                          : null),
                              child:
                                  _selectedImage == null && !hasProfileImage
                                      ? Icon(
                                        Icons.add_a_photo_rounded,
                                        size: 50,
                                        color: secondaryColor,
                                      )
                                      : null,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 3,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.upload_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const Gap(10),

                Text(
                  "${firstNameController.text} ${lastNameController.text}",
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -1,
                  ),
                ),
                Text(
                  emailController.text,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Gap(30),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 24,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(
                          Icons.account_circle_outlined,
                          "PROFILE",
                        ),
                        const Gap(24),

                        _buildElegantTextField(
                          label: "First Name",
                          controller: firstNameController,
                        ),
                        const Gap(20),

                        _buildElegantTextField(
                          label: "Last Name",
                          controller: lastNameController,
                        ),

                        const Divider(height: 48, thickness: 1),

                        _buildSectionHeader(
                          Icons.contact_mail_outlined,
                          "CONTACT",
                        ),
                        const Gap(24),

                        _buildStatusField(
                          label: "Mobile Number",
                          controller: mobileController,
                          isEditing: isEditingMobile,
                          status: "Verified",
                          icon: Icons.phone_android_rounded,
                          onToggle: () {
                            setState(() => isEditingMobile = !isEditingMobile);
                          },
                        ),
                        const Gap(20),

                        _buildStatusField(
                          label: "Email ID",
                          controller: emailController,
                          isEditing: isEditingEmail,
                          status: "Verified",
                          icon: Icons.alternate_email_rounded,
                          onToggle: () {
                            setState(() => isEditingEmail = !isEditingEmail);
                          },
                        ),

                        const Gap(40),

                        _buildSaveButton(theme, state),
                      ],
                    ),
                  ),
                ),

                const Gap(40),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Theme.of(context).primaryColor),
        const Gap(8),
        Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            color: Colors.grey.shade400,
          ),
        ),
      ],
    );
  }

  Widget _buildElegantTextField({
    required String label,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const Gap(10),
        TextField(
          controller: controller,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          decoration: InputDecoration(
            isDense: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade100, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 18,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusField({
    required String label,
    required TextEditingController controller,
    required bool isEditing,
    required String status,
    required IconData icon,
    required VoidCallback onToggle,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            GestureDetector(
              onTap: onToggle,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color:
                      isEditing
                          ? theme.primaryColor.withOpacity(0.1)
                          : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isEditing ? "SAVE" : "UPDATE",
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
        const Gap(10),
        isEditing
            ? TextField(
              controller: controller,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.grey.shade100, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: theme.primaryColor, width: 2),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
              ),
            )
            : Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100, width: 2),
              ),
              child: Row(
                children: [
                  Icon(icon, size: 22, color: Colors.grey.shade400),
                  const Gap(14),
                  Expanded(
                    child: Text(
                      controller.text,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          size: 12,
                          color: Colors.green.shade600,
                        ),
                        const Gap(4),
                        Text(
                          status,
                          style: TextStyle(
                            color: Colors.green.shade600,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      ],
    );
  }

  Widget _buildSaveButton(ThemeData theme, AuthState state) {
    final isLoading = state is AuthUpdateUserLoadingState;

    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        gradient: LinearGradient(
          colors: [theme.primaryColor, theme.colorScheme.secondary],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap:
              isLoading
                  ? null
                  : () {
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
          borderRadius: BorderRadius.circular(20),
          child: Center(
            child:
                isLoading
                    ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                    : const Text(
                      "SAVE CHANGES",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
          ),
        ),
      ),
    );
  }
}
