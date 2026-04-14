import 'package:flutter/material.dart';
import 'package:scratcher/widgets.dart';

class CouponTile extends StatefulWidget {
  final bool isScratched;
  const CouponTile({super.key, required this.isScratched});

  @override
  State<CouponTile> createState() => _CouponTileState();
}

class _CouponTileState extends State<CouponTile> {
  final OverlayPortalController _overlayPortalController = OverlayPortalController();
  final GlobalKey<ScratcherState> _scratcherKey = GlobalKey<ScratcherState>();
  bool isScratched = false;

  @override
  void initState() {
    super.initState();
    isScratched = widget.isScratched;
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _overlayPortalController,
      overlayChildBuilder: (context) {
        return Positioned.fill(
          child: GestureDetector(
            onTap: () => _overlayPortalController.hide(),
            child: Container(
              color: Colors.black.withOpacity(0.6),
              child: Center(
                child: GestureDetector(
                  onTap: () {}, // Prevent taps inside the box from closing the overlay
                  child: Container(
                    width: 300,
                    height: 320,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: isScratched
                          ? _buildRevealedContent(isLarge: true)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                children: [
                                  Scratcher(
                                    key: _scratcherKey,
                                    brushSize: 45,
                                    threshold: 40,
                                    color: const Color(0xFF9747FF),
                                    onChange: (value) => debugPrint("Scratch progress: $value%"),
                                    onThreshold: () {
                                      _scratcherKey.currentState?.reveal(
                                        duration: const Duration(milliseconds: 400),
                                      );
                                      Future.delayed(const Duration(milliseconds: 500), () {
                                        if (mounted) {
                                          setState(() {
                                            isScratched = true;
                                          });
                                        }
                                      });
                                    },
                                    child: _buildRevealedContent(isLarge: true),
                                  ),
                                  // Invisible pointer pass-through overlay to guide the user visually
                                  Positioned.fill(
                                    child: IgnorePointer(
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.touch_app_rounded, color: Colors.white.withOpacity(0.4), size: 48),
                                            const SizedBox(height: 12),
                                            Text(
                                              "Scratch Here!",
                                              style: TextStyle(
                                                fontFamily: 'Roboto',
                                                fontSize: 20,
                                                fontWeight: FontWeight.w800,
                                                color: Colors.white.withOpacity(0.5),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: GestureDetector(
        onTap: () => _overlayPortalController.toggle(),
        child: isScratched ? _buildRevealedContent() : _buildLockedContent(),
      ),
    );
  }

  Widget _buildLockedContent() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF9747FF), Color(0xFFB57AFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9747FF).withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(Icons.redeem_rounded, size: 100, color: Colors.white.withOpacity(0.15)),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.lock_rounded, color: Colors.white, size: 28),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Tap to Scratch",
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevealedContent({bool isLarge = false}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFF9747FF).withOpacity(0.3), width: 2),
        borderRadius: BorderRadius.circular(16),
        boxShadow: isLarge
            ? []
            : [
                BoxShadow(
                  color: const Color(0xFF9747FF).withOpacity(0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: isLarge ? 0.7 : 1.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        curve: Curves.elasticOut,
        builder: (context, scale, child) {
          return Transform.scale(
            scale: scale,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(isLarge ? 12 : 8),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check_circle_rounded, color: Colors.green, size: isLarge ? 48 : 32),
                ),
                SizedBox(height: isLarge ? 20 : 12),
                Text(
                  '₹100 OFF',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: isLarge ? 32 : 20,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF9747FF),
                  ),
                ),
                SizedBox(height: isLarge ? 8 : 4),
                Text(
                  'On your next order',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: isLarge ? 15 : 11,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
