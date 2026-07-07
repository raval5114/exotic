import 'dart:math' as math;

import 'package:exotic/view/payment/orderPaymentCompletionScreen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ─────────────────────────────────────────────────────────────────────────────
// OrderPaymentSuccessfullScreen
// ─────────────────────────────────────────────────────────────────────────────
class OrderPaymentSuccessfullScreen extends StatefulWidget {
  const OrderPaymentSuccessfullScreen({super.key});

  @override
  State<OrderPaymentSuccessfullScreen> createState() =>
      _OrderPaymentSuccessfullScreenState();
}

class _OrderPaymentSuccessfullScreenState
    extends State<OrderPaymentSuccessfullScreen>
    with TickerProviderStateMixin {
  // ── Brand ────────────────────────────────────────────────────────────────
  static const Color _green = Color(0xFF2E7D32);
  static const Color _greenLight = Color(0xFF43A047);

  // ── Ring burst (3 rings, staggered) ──────────────────────────────────────
  late AnimationController _ring1Ctrl, _ring2Ctrl, _ring3Ctrl;
  late Animation<double> _ring1Scale, _ring2Scale, _ring3Scale;
  late Animation<double> _ring1Fade, _ring2Fade, _ring3Fade;

  // ── Check icon draw-on ────────────────────────────────────────────────────
  late AnimationController _checkCtrl;
  late Animation<double> _checkProgress;
  late Animation<double> _checkCircleScale;

  // ── Confetti ──────────────────────────────────────────────────────────────
  late AnimationController _confettiCtrl;

  // ── Text / content stagger ────────────────────────────────────────────────
  late AnimationController _contentCtrl;
  late Animation<Offset> _titleSlide;
  late Animation<double> _titleFade;
  late Animation<double> _savingsScale;
  late Animation<Offset> _couponSlide;
  late Animation<double> _couponFade;

  // ── Countdown redirect bar ────────────────────────────────────────────────
  late AnimationController _countdownCtrl;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _startSequence();
  }

  void _setupAnimations() {
    // ── Ring 1 ────────────────────────────────────────────────────────────
    _ring1Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _ring1Scale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ring1Ctrl, curve: Curves.easeOutCubic));
    _ring1Fade = Tween<double>(begin: 0.4, end: 0.0).animate(
      CurvedAnimation(parent: _ring1Ctrl, curve: const Interval(0.5, 1.0)),
    );

    // ── Ring 2 ────────────────────────────────────────────────────────────
    _ring2Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _ring2Scale = Tween<double>(
      begin: 0.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _ring2Ctrl, curve: Curves.easeOutCubic));
    _ring2Fade = Tween<double>(begin: 0.25, end: 0.0).animate(
      CurvedAnimation(parent: _ring2Ctrl, curve: const Interval(0.4, 1.0)),
    );

    // ── Ring 3 ────────────────────────────────────────────────────────────
    _ring3Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _ring3Scale = Tween<double>(
      begin: 0.0,
      end: 1.5,
    ).animate(CurvedAnimation(parent: _ring3Ctrl, curve: Curves.easeOutCubic));
    _ring3Fade = Tween<double>(begin: 0.15, end: 0.0).animate(
      CurvedAnimation(parent: _ring3Ctrl, curve: const Interval(0.3, 1.0)),
    );

    // ── Check draw-on ─────────────────────────────────────────────────────
    _checkCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _checkProgress = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _checkCtrl, curve: Curves.easeInOut));
    _checkCircleScale = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _checkCtrl, curve: Curves.elasticOut));

    // ── Confetti ──────────────────────────────────────────────────────────
    _confettiCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    // ── Content stagger ───────────────────────────────────────────────────
    _contentCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
      ),
    );
    _titleFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );
    _savingsScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.3, 0.75, curve: Curves.elasticOut),
      ),
    );
    _couponSlide = Tween<Offset>(
      begin: const Offset(0, 0.8),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.55, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _couponFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentCtrl,
        curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
      ),
    );

    // ── Countdown ─────────────────────────────────────────────────────────
    _countdownCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> _startSequence() async {
    // Step 1: rings burst simultaneously, staggered
    _ring1Ctrl.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _ring2Ctrl.forward();
    await Future.delayed(const Duration(milliseconds: 100));
    _ring3Ctrl.forward();

    // Step 2: check draws on
    await Future.delayed(const Duration(milliseconds: 120));
    _checkCtrl.forward();

    // Step 3: confetti starts
    await Future.delayed(const Duration(milliseconds: 200));
    _confettiCtrl.forward();

    // Step 4: content fades in
    await Future.delayed(const Duration(milliseconds: 100));
    _contentCtrl.forward();

    // Step 5: countdown begins → redirect
    await Future.delayed(const Duration(milliseconds: 200));
    _countdownCtrl.forward();
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      context.go('/dynamicRoute', extra: () => OrderPaymentCompletionScreen());
    }
  }

  @override
  void dispose() {
    _ring1Ctrl.dispose();
    _ring2Ctrl.dispose();
    _ring3Ctrl.dispose();
    _checkCtrl.dispose();
    _confettiCtrl.dispose();
    _contentCtrl.dispose();
    _countdownCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // ── Confetti layer ────────────────────────────────────────────
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _confettiCtrl,
                  builder:
                      (_, __) => CustomPaint(
                        painter: _ConfettiPainter(
                          progress: _confettiCtrl.value,
                          seed: 7,
                          center: Offset(size.width / 2, size.height * 0.35),
                        ),
                      ),
                ),
              ),
            ),

            // ── Main content ──────────────────────────────────────────────
            Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // ── Success icon with rings ──────────────────────
                        SizedBox(
                          width: 220,
                          height: 220,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Ring 3 (outermost)
                              AnimatedBuilder(
                                animation: _ring3Ctrl,
                                builder:
                                    (_, __) => Transform.scale(
                                      scale: _ring3Scale.value,
                                      child: Opacity(
                                        opacity: _ring3Fade.value,
                                        child: Container(
                                          width: 200,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _greenLight.withValues(
                                              alpha: 0.15,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              ),

                              // Ring 2
                              AnimatedBuilder(
                                animation: _ring2Ctrl,
                                builder:
                                    (_, __) => Transform.scale(
                                      scale: _ring2Scale.value,
                                      child: Opacity(
                                        opacity: _ring2Fade.value,
                                        child: Container(
                                          width: 160,
                                          height: 160,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _greenLight.withValues(
                                              alpha: 0.20,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              ),

                              // Ring 1 (steady background)
                              AnimatedBuilder(
                                animation: _ring1Ctrl,
                                builder:
                                    (_, __) => Transform.scale(
                                      scale: _ring1Scale.value,
                                      child: Opacity(
                                        opacity: _ring1Fade.value,
                                        child: Container(
                                          width: 130,
                                          height: 130,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: _greenLight.withValues(
                                              alpha: 0.18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                              ),

                              // Inner glow ring
                              AnimatedBuilder(
                                animation: _checkCtrl,
                                builder:
                                    (_, __) => Transform.scale(
                                      scale: _checkCircleScale.value,
                                      child: Container(
                                        width: 118,
                                        height: 118,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: const Color(0xFFE8F5E9),
                                          boxShadow: [
                                            BoxShadow(
                                              color: _greenLight.withValues(
                                                alpha: 0.25,
                                              ),
                                              blurRadius: 24,
                                              spreadRadius: 4,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              ),

                              // Green filled circle
                              AnimatedBuilder(
                                animation: _checkCtrl,
                                builder:
                                    (_, __) => Transform.scale(
                                      scale: _checkCircleScale.value,
                                      child: Container(
                                        width: 90,
                                        height: 90,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF43A047),
                                              Color(0xFF2E7D32),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: _greenLight.withValues(
                                                alpha: 0.45,
                                              ),
                                              blurRadius: 18,
                                              offset: const Offset(0, 6),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                              ),

                              // Animated check stroke
                              AnimatedBuilder(
                                animation: _checkCtrl,
                                builder:
                                    (_, __) => SizedBox(
                                      width: 90,
                                      height: 90,
                                      child: CustomPaint(
                                        painter: _CheckPainter(
                                          progress: _checkProgress.value,
                                        ),
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 36),

                        // ── Title ────────────────────────────────────────
                        FadeTransition(
                          opacity: _titleFade,
                          child: SlideTransition(
                            position: _titleSlide,
                            child: Column(
                              children: [
                                const Text(
                                  'Order Placed!',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontSize: 26,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF111827),
                                    letterSpacing: -0.5,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Your order is confirmed and on its way.',
                                  style: TextStyle(
                                    fontFamily: 'NunitoSans',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey.shade500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── Savings badge ─────────────────────────────────
                        ScaleTransition(
                          scale: _savingsScale,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  _green.withValues(alpha: 0.10),
                                  _greenLight.withValues(alpha: 0.08),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _greenLight.withValues(alpha: 0.25),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE8F5E9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.savings_rounded,
                                    color: Color(0xFF2E7D32),
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                RichText(
                                  text: const TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'You saved ',
                                        style: TextStyle(
                                          fontFamily: 'NunitoSans',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF374151),
                                        ),
                                      ),
                                      TextSpan(
                                        text: '₹1,234',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Color(0xFF2E7D32),
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' on this order',
                                        style: TextStyle(
                                          fontFamily: 'NunitoSans',
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFF374151),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ── Scratch coupon CTA ────────────────────────────
                        FadeTransition(
                          opacity: _couponFade,
                          child: SlideTransition(
                            position: _couponSlide,
                            child: _ScratchCTABanner(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Countdown redirect bar ────────────────────────────────
                _CountdownBar(animation: _countdownCtrl),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _CheckPainter — strokes the check mark progressively
// ─────────────────────────────────────────────────────────────────────────────
class _CheckPainter extends CustomPainter {
  final double progress; // 0.0 → 1.0

  const _CheckPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;

    final paint =
        Paint()
          ..color = Colors.white
          ..strokeWidth = 5.5
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round
          ..style = PaintingStyle.stroke;

    final cx = size.width / 2;
    final cy = size.height / 2;

    // Check path: two segments
    // Segment 1: from (cx-18, cy) → (cx-5, cy+14)   (short left arm)
    // Segment 2: from (cx-5, cy+14) → (cx+18, cy-14)  (long right arm)
    final seg1 =
        Path()
          ..moveTo(cx - 18, cy)
          ..lineTo(cx - 5, cy + 14);

    final seg2 =
        Path()
          ..moveTo(cx - 5, cy + 14)
          ..lineTo(cx + 20, cy - 14);

    final total = 2.0; // 2 segments
    final p1 = (progress * total).clamp(0.0, 1.0);
    final p2 = ((progress * total) - 1.0).clamp(0.0, 1.0);

    if (p1 > 0) {
      final m1 = seg1.computeMetrics().first;
      canvas.drawPath(m1.extractPath(0, m1.length * p1), paint);
    }
    if (p2 > 0) {
      final m2 = seg2.computeMetrics().first;
      canvas.drawPath(m2.extractPath(0, m2.length * p2), paint);
    }
  }

  @override
  bool shouldRepaint(_CheckPainter old) => old.progress != progress;
}

// ─────────────────────────────────────────────────────────────────────────────
// _ConfettiPainter — particle shower bursting from a center point
// ─────────────────────────────────────────────────────────────────────────────
class _ConfettiPainter extends CustomPainter {
  final double progress;
  final int seed;
  final Offset center;

  static const _colors = [
    Color(0xFF7C3AED),
    Color(0xFF9747FF),
    Color(0xFF43A047),
    Color(0xFF2E7D32),
    Color(0xFFFFC107),
    Color(0xFFFF7043),
    Color(0xFFE94A75),
    Color(0xFF2196F3),
    Color(0xFFFFFFFF),
  ];

  const _ConfettiPainter({
    required this.progress,
    required this.seed,
    required this.center,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const count = 72;
    final rng = math.Random(seed);

    for (int i = 0; i < count; i++) {
      final angle = rng.nextDouble() * math.pi * 2;
      final speed = rng.nextDouble() * 340 + 80;
      final delay = rng.nextDouble() * 0.25;
      final w = rng.nextDouble() * 10 + 4;
      final h = rng.nextDouble() * 5 + 2;
      final rot = rng.nextDouble() * math.pi * 2;
      final rotSpeed = (rng.nextDouble() - 0.5) * 10;
      final color = _colors[rng.nextInt(_colors.length)];
      final isCircle = rng.nextBool();

      final t = ((progress - delay) / (1.0 - delay)).clamp(0.0, 1.0);
      if (t <= 0) continue;

      final gravity = 280 * t * t;
      final x = center.dx + math.cos(angle) * speed * t;
      final y = center.dy + math.sin(angle) * speed * t * 0.6 + gravity;
      final alpha = (1.0 - math.pow(t, 1.5)).clamp(0.0, 1.0).toDouble();

      final paint =
          Paint()
            ..color = color.withValues(alpha: alpha)
            ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rot + rotSpeed * t);

      if (isCircle) {
        canvas.drawCircle(Offset.zero, w * 0.5, paint);
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromCenter(center: Offset.zero, width: w, height: h),
            const Radius.circular(2),
          ),
          paint,
        );
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}

// ─────────────────────────────────────────────────────────────────────────────
// _ScratchCTABanner
// ─────────────────────────────────────────────────────────────────────────────
class _ScratchCTABanner extends StatefulWidget {
  @override
  State<_ScratchCTABanner> createState() => _ScratchCTABannerState();
}

class _ScratchCTABannerState extends State<_ScratchCTABanner>
    with SingleTickerProviderStateMixin {
  static const Color _brandPrimary = Color(0xFF7C3AED);

  late AnimationController _shimmerCtrl;
  late Animation<double> _shimmerAnim;

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();
    _shimmerAnim = Tween<double>(
      begin: -1.5,
      end: 2.5,
    ).animate(CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerAnim,
      builder: (_, child) {
        return ShaderMask(
          shaderCallback:
              (bounds) => LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [
                  (_shimmerAnim.value - 0.4).clamp(0.0, 1.0),
                  _shimmerAnim.value.clamp(0.0, 1.0),
                  (_shimmerAnim.value + 0.4).clamp(0.0, 1.0),
                ],
                colors: const [
                  Color(0xFF7C3AED),
                  Color(0xFFB794F4),
                  Color(0xFF7C3AED),
                ],
              ).createShader(bounds),
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 13),
        decoration: BoxDecoration(
          color: _brandPrimary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _brandPrimary.withValues(alpha: 0.25),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _brandPrimary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.card_giftcard_rounded,
                color: _brandPrimary,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You earned a scratch card!',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF7C3AED),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Tap to reveal your reward →',
                  style: TextStyle(
                    fontFamily: 'NunitoSans',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF7C3AED),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _CountdownBar — thin progress line showing time before redirect
// ─────────────────────────────────────────────────────────────────────────────
class _CountdownBar extends StatelessWidget {
  final Animation<double> animation;
  static const Color _brandPrimary = Color(0xFF7C3AED);

  const _CountdownBar({required this.animation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
      child: Column(
        children: [
          AnimatedBuilder(
            animation: animation,
            builder:
                (_, __) => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Redirecting in ',
                      style: TextStyle(
                        fontFamily: 'NunitoSans',
                        fontSize: 11,
                        fontWeight: FontWeight.w400,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    Text(
                      '${((1.0 - animation.value) * 3).ceil()}s',
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _brandPrimary,
                      ),
                    ),
                  ],
                ),
          ),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: animation,
            builder:
                (_, __) => ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: animation.value,
                    minHeight: 3,
                    backgroundColor: const Color(0xFFF3F4F6),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color.lerp(
                        _brandPrimary,
                        const Color(0xFF43A047),
                        animation.value,
                      )!,
                    ),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
