import 'package:exotic/view/searchProduct/searchProduct.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

// ─── Brand tokens ─────────────────────────────────────────────────────────────
const _kBrandPrimary = Color(0xFF7C3AED);
const _kBrandSecondary = Color(0xFF9747FF);

class ExoticAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ExoticAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  // ── Gallery picker ──────────────────────────────────────────────────────────
  Future<void> _openGallery() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      debugPrint('Picked image: ${image.path}');
    }
  }

  // ── Camera picker ───────────────────────────────────────────────────────────
  Future<void> _openCamera() async {
    final picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      debugPrint('Captured photo: ${photo.path}');
    }
  }

  // ── Image-search bottom sheet ────────────────────────────────────────────────
  void _showImageSearchSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder:
          (_) =>
              _ImageSearchSheet(onGallery: _openGallery, onCamera: _openCamera),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: _kBrandPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      // ── Search bar (title area) ─────────────────────────────────────────────
      title: GestureDetector(
        onTap:
            () =>
                context.push('/dynamicRoute', extra: () => SearchProductPage()),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.96),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              // Camera icon — triggers image search
              GestureDetector(
                onTap: () => _showImageSearchSheet(context),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: _kBrandSecondary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              // Tappable hint text (navigates to search)
              Expanded(
                child: AbsorbPointer(
                  child: TextField(
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.black87,
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: 'Search for products, brands...',
                      hintStyle: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.black38,
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              // Mic icon
              const Icon(
                Icons.mic_none_rounded,
                color: _kBrandSecondary,
                size: 20,
              ),
              const SizedBox(width: 8),
              // Search icon
              const Icon(
                Icons.search_rounded,
                color: _kBrandSecondary,
                size: 22,
              ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
      // ── Actions ─────────────────────────────────────────────────────────────
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: InkWell(
            onTap: () => context.push('/wishlist'),
            borderRadius: BorderRadius.circular(8),
            splashColor: Colors.white.withOpacity(0.15),
            highlightColor: Colors.white.withOpacity(0.08),
            child: Padding(
              padding: const EdgeInsets.all(6),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Image Search Bottom Sheet ─────────────────────────────────────────────────
class _ImageSearchSheet extends StatelessWidget {
  final Future<void> Function() onGallery;
  final Future<void> Function() onCamera;

  const _ImageSearchSheet({required this.onGallery, required this.onCamera});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Handle ──────────────────────────────────────────────────────────
          const SizedBox(height: 12),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // ── Icon ────────────────────────────────────────────────────────────
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: _kBrandSecondary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.image_search_rounded,
              color: _kBrandSecondary,
              size: 28,
            ),
          ),
          const SizedBox(height: 14),

          // ── Title & subtitle ─────────────────────────────────────────────────
          Text(
            "Search with a Photo",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              "Upload or capture a photo to find Fashion, Toys, Lifestyle and Home Products.",
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.black45,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // ── Actions ─────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                // Gallery
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      await onGallery();
                    },
                    icon: const Icon(Icons.photo_library_outlined, size: 18),
                    label: Text(
                      "Choose from Gallery",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _kBrandPrimary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Camera
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      Navigator.pop(context);
                      await onCamera();
                    },
                    icon: const Icon(Icons.camera_alt_outlined, size: 18),
                    label: Text(
                      "Take a Photo",
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: _kBrandSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _kBrandSecondary,
                      side: const BorderSide(
                        color: _kBrandSecondary,
                        width: 1.5,
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
