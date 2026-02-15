import 'package:flutter/material.dart';
import 'package:scratcher/widgets.dart';

class CouponTile extends StatefulWidget {
  final bool isScratched;
  const CouponTile({super.key, required this.isScratched});

  @override
  State<CouponTile> createState() => _CouponTileState();
}

class _CouponTileState extends State<CouponTile> {
  final OverlayPortalController _overlayPortalController =
      OverlayPortalController();

  @override
  Widget build(BuildContext context) {
    bool isScratched = widget.isScratched;

    return OverlayPortal(
      controller: _overlayPortalController,
      overlayChildBuilder: (context) {
        return Positioned.fill(
          child: GestureDetector(
            onTap: () => _overlayPortalController.hide(),
            child: Container(
              color: Colors.black.withOpacity(0.6),
              child: Center(
                child: Container(
                  width: 314,
                  height: 330,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child:
                        isScratched == true
                            ? _buildRevealedContent()
                            : Scratcher(
                              brushSize: 30,
                              threshold: 50,
                              color: Colors.red,
                              image: Image.asset(
                                'assets/images/coupons/coupon.jpg',
                                fit: BoxFit.cover,
                              ),
                              onChange:
                                  (value) =>
                                      debugPrint("Scratch progress: $value%"),
                              onThreshold: () {
                                print("Threshold reached, you won!");
                                setState(() {
                                  isScratched = true;
                                });
                              },
                              child: _buildRevealedContent(),
                            ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child:
          isScratched == true
              ? InkWell(
                onTap: () => _overlayPortalController.toggle(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset('assets/images/coupons/coupon.jpg'),
                  ),
                ),
              )
              : _buildRevealedContent(),
    );
  }

  Widget _buildRevealedContent() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text(
          '🎉 ₹100 OFF 🎉',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.deepPurple,
          ),
        ),
      ),
    );
  }
}
