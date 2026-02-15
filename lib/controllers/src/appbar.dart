import 'package:exotic/view/searchProduct/searchProduct.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class ExoticAppBar extends StatelessWidget implements PreferredSizeWidget {
  ExoticAppBar({super.key});
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  final ImagePicker picker = ImagePicker();
  void openGallary() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      print('Picked image: ${image.path}');
      // You can pass this to Bloc, setState, etc.
    } else {
      print('No image selected.');
    }
  }

  Widget SearchBarCameraOverlay(OverlayEntry entry) {
    return Stack(
      children: [
        // Semi-transparent background
        GestureDetector(
          onTap: () => entry.remove(),
          child: Container(color: Colors.black.withOpacity(0.5)),
        ),

        // Centered dialog
        Center(
          child: Material(
            borderRadius: BorderRadius.circular(12),
            color: Colors.transparent,
            child: Container(
              width: 320,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Search with a photo",
                    style: GoogleFonts.roboto(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Upload a photo and search for Fashion, Toys,\nLifestyle and Home Products",
                    style: GoogleFonts.roboto(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Filled button
                  ElevatedButton(
                    onPressed: () {
                      openGallary();
                      // Handle gallery action
                      entry.remove();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.image),
                            SizedBox(width: 8),
                            Text(
                              "Choose from gallery",
                              style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Outlined button
                  OutlinedButton(
                    onPressed: () async {
                      final XFile? photo = await picker.pickImage(
                        source: ImageSource.camera,
                      );

                      if (photo != null) {
                        print('Captured photo: ${photo.path}');
                        // You can store, display, or upload the image here
                      } else {
                        print('No photo taken.');
                      }

                      entry.remove(); // Close the overlay regardless
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.blue),
                      foregroundColor: Colors.blue,
                      minimumSize: const Size(double.infinity, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.camera_alt),
                            const SizedBox(width: 8),
                            Text(
                              "Click a photo",
                              style: GoogleFonts.roboto(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void onTap(BuildContext context) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(builder: (_) => SearchBarCameraOverlay(entry));
    overlay.insert(entry);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      centerTitle: true,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.only(top: 20, bottom: 20, right: 20),
        width: 259,
        height: 39,
        child: Row(
          children: [
            InkWell(
              onTap: () => onTap(context),
              child: Image.asset(
                'assets/icons/homescreen_searchbar_camera_icon.jpg',
                width: 20,
                height: 20,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SearchProductPage(),
                      ),
                    ),
                child: AbsorbPointer(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintText: 'Search',
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Image.asset(
              'assets/icons/homescreen_searchbar_mic_icon.jpg',
              width: 20,
              height: 20,
            ),
            const SizedBox(width: 8),
            Image.asset(
              'assets/icons/homescreen_searchbar_search_icon.jpg',
              width: 20,
              height: 20,
            ),
          ],
        ),
      ),
      actions: [
        InkWell(
          onTap: () => context.push('/wishlist'),
          child: Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons.favorite_border_outlined,
              size: 28,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}
