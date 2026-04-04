import 'package:exotic/controllers/Homescreen/EditProfile/editProfile.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:exotic/data/providers/user_provider.dart';

class ProfileScreenSection extends StatelessWidget {
  const ProfileScreenSection({super.key});

  Widget buildProfileItem(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(6),
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.blue),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final theme = Theme.of(context);

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          // User Profile Header Section
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 30),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.5),
                      width: 3,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 36,
                    backgroundColor: Colors.white,
                    backgroundImage:
                        user?.profilePhotoUrl != null &&
                                user!.profilePhotoUrl.isNotEmpty
                            ? NetworkImage(user.profilePhotoUrl)
                            : null,
                    child:
                        user?.profilePhotoUrl == null ||
                                user!.profilePhotoUrl.isEmpty
                            ? Icon(
                              Icons.person_rounded,
                              size: 40,
                              color: theme.colorScheme.secondary,
                            )
                            : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user != null
                            ? "${user.firstName} ${user.lastName}".trim()
                            : "Guest User",
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.5,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user?.email ?? "Sign in to view info",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EditProfile()),
                    );
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.edit_rounded,
                      color: theme.colorScheme.secondary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Grid Section
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            padding: const EdgeInsets.only(top: 10),
            childAspectRatio: 3.2, // Increased to drastically reduce height
            children: [
              buildProfileItem(Icons.inventory_2_outlined, "Orders", () {
                context.push('/orderList');
              }),
              buildProfileItem(Icons.favorite_border, "Wishlist", () {
                context.push('/wishlist');
              }),
              buildProfileItem(Icons.card_giftcard, "Coupons", () {
                context.push('/coupensAndOffers');
              }),
              buildProfileItem(Icons.lock_outline, "Help Center", () {}),
            ],
          ),
        ],
      ),
    );
  }
}
