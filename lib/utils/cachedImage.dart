import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:image/image.dart' as img;

class AppCachedImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      fadeInDuration: const Duration(milliseconds: 200),
      placeholder:
          (context, url) => Container(
            width: width,
            height: height,
            color: Colors.grey.shade200,
          ),
      errorWidget: (context, url, error) {
        // Fallback for native decoding errors (like unimplemented WebP structures)
        if (error.toString().contains('unimplemented') ||
            error.toString().contains('Invalid image data')) {
          return _FallbackImage(
            imageUrl: imageUrl,
            fit: fit,
            width: width,
            height: height,
          );
        }
        return Container(
          width: width,
          height: height,
          color: Colors.grey.shade100,
          child: const Icon(Icons.broken_image, color: Colors.grey),
        );
      },
    );

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: image);
    }

    return image;
  }
}

class _FallbackImage extends StatefulWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;

  const _FallbackImage({
    required this.imageUrl,
    required this.fit,
    this.width,
    this.height,
  });

  @override
  _FallbackImageState createState() => _FallbackImageState();
}

class _FallbackImageState extends State<_FallbackImage> {
  Uint8List? _bytes;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    _loadFallback();
  }

  Future<void> _loadFallback() async {
    try {
      final fileInfo =
          await DefaultCacheManager().getFileFromCache(widget.imageUrl) ??
          await DefaultCacheManager().downloadFile(widget.imageUrl);

      final bytes = await fileInfo.file.readAsBytes();

      // Decode synchronously to avoid any isolate-related issues for now
      final decodedImage = img.decodeImage(bytes);

      if (decodedImage != null) {
        final pngBytes = img.encodePng(decodedImage);
        if (mounted) {
          setState(() => _bytes = pngBytes);
        }
      } else {
        debugPrint(
          "Fallback Error: decodeImage returned null for bytes length ${bytes.length}",
        );
        if (mounted) setState(() => _failed = true);
      }
    } catch (e, stack) {
      debugPrint("Fallback Exception: $e\\n$stack");
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey.shade100,
        child: const Icon(Icons.broken_image, color: Colors.grey),
      );
    }
    if (_bytes == null) {
      return Container(
        width: widget.width,
        height: widget.height,
        color: Colors.grey.shade200,
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    return Image.memory(
      _bytes!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
    );
  }
}
