import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scratcher/widgets.dart';

// ─────────────────────────────────────────────────────────────────────────────
// CouponTile
// ─────────────────────────────────────────────────────────────────────────────
class CouponTile extends StatefulWidget {
  final bool isScratched;
  const CouponTile({super.key, required this.isScratched});

  @override
  State<CouponTile> createState() => _CouponTileState();
}

class _CouponTileState extends State<CouponTile> with TickerProviderStateMixin {
  // ── Brand ────────────────────────────────────────────────────────────────
  static const Color _brandPrimary = Color(0xFF7C3AED);

  // ── Overlay / scratcher ──────────────────────────────────────────────────
  final OverlayPortalController _overlayController = OverlayPortalController();
  final GlobalKey<ScratcherState> _scratcherKey    = GlobalKey<ScratcherState>();

  bool   _isScratched   = false;
  double _scratchPercent = 0.0;   // 0–100
  bool   _userHasStartedScratching = false;

  // ── Animations ───────────────────────────────────────────────────────────
  late AnimationController _pulseCtrl;      // locked-card lock pulse
  late Animation<double>   _pulseAnim;

  late AnimationController _shimmerCtrl;    // locked-card shimmer sweep
  late Animation<double>   _shimmerAnim;

  late AnimationController _revealCtrl;     // reward pop-in
  late Animation<double>   _revealScale;
  late Animation<double>   _revealFade;
  late Animation<Offset>   _codeSlide;

  late AnimationController _confettiCtrl;   // particle shower
  late Animation<double>   _confettiFade;

  late AnimationController _hintFadeCtrl;   // scratch-hint fade-out
  late Animation<double>   _hintOpacity;

  @override
  void initState() {
    super.initState();
    _isScratched = widget.isScratched;

    // ── Pulse (lock icon) ─────────────────────────────────────────────────
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.93, end: 1.07)
        .animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    // ── Shimmer sweep ─────────────────────────────────────────────────────
    _shimmerCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
    _shimmerAnim = Tween<double>(begin: -1.5, end: 2.5)
        .animate(CurvedAnimation(parent: _shimmerCtrl, curve: Curves.easeInOut));

    // ── Reveal pop-in ─────────────────────────────────────────────────────
    _revealCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _revealScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _revealCtrl, curve: Curves.elasticOut),
    );
    _revealFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _revealCtrl,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
      ),
    );
    _codeSlide = Tween<Offset>(begin: const Offset(0, 0.6), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _revealCtrl,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    // ── Confetti ──────────────────────────────────────────────────────────
    _confettiCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _confettiFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _confettiCtrl,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    // ── Hint fade ────────────────────────────────────────────────────────
    _hintFadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      value: 1.0,
    );
    _hintOpacity = _hintFadeCtrl.drive(CurveTween(curve: Curves.easeOut));

    if (_isScratched) {
      _revealCtrl.value = 1.0;
    }
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _shimmerCtrl.dispose();
    _revealCtrl.dispose();
    _confettiCtrl.dispose();
    _hintFadeCtrl.dispose();
    super.dispose();
  }

  // ── Called when scratch threshold is crossed ─────────────────────────────
  void _onThreshold() {
    HapticFeedback.heavyImpact();
    _scratcherKey.currentState?.reveal(
      duration: const Duration(milliseconds: 500),
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() => _isScratched = true);
        _revealCtrl.forward(from: 0);
        _confettiCtrl.forward(from: 0);
        Future.delayed(const Duration(milliseconds: 200), () {
          HapticFeedback.mediumImpact();
        });
      }
    });
  }

  void _onScratchChange(double percent) {
    setState(() => _scratchPercent = percent);
    if (!_userHasStartedScratching && percent > 1) {
      _userHasStartedScratching = true;
      _hintFadeCtrl.reverse(); // fade out the hint
    }
  }

  @override
  Widget build(BuildContext context) {
    return OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: (_) => _buildOverlay(context),
      child: GestureDetector(
        onTap: () {
          // Reset hint & scratch state for the overlay each open
          if (!_isScratched) {
            setState(() {
              _scratchPercent = 0;
              _userHasStartedScratching = false;
            });
            _hintFadeCtrl.value = 1.0;
          }
          _overlayController.toggle();
        },
        child: _isScratched ? _buildRevealedCard() : _buildLockedCard(),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // OVERLAY
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildOverlay(BuildContext context) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: _overlayController.hide,
        child: Container(
          color: Colors.black.withValues(alpha: 0.70),
          child: Center(
            child: GestureDetector(
              onTap: () {}, // absorb taps inside card
              child: _OverlayCard(
                isScratched: _isScratched,
                scratchPercent: _scratchPercent,
                scratcherKey: _scratcherKey,
                revealScale: _revealScale,
                revealFade: _revealFade,
                codeSlide: _codeSlide,
                confettiCtrl: _confettiCtrl,
                confettiFade: _confettiFade,
                hintOpacity: _hintOpacity,
                onScratchChange: _onScratchChange,
                onThreshold: _onThreshold,
                onClose: _overlayController.hide,
                onCopy: () {
                  Clipboard.setData(const ClipboardData(text: 'EXOTIC100'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Code copied!',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: _brandPrimary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // LOCKED GRID TILE
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildLockedCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AnimatedBuilder(
        animation: _shimmerAnim,
        builder: (_, child) {
          return ShaderMask(
            shaderCallback: (bounds) {
              return LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  (_shimmerAnim.value - 0.4).clamp(0.0, 1.0),
                  _shimmerAnim.value.clamp(0.0, 1.0),
                  (_shimmerAnim.value + 0.4).clamp(0.0, 1.0),
                ],
                colors: const [
                  Colors.white,
                  Color(0xFFDDCCFF),
                  Colors.white,
                ],
              ).createShader(bounds);
            },
            blendMode: BlendMode.srcATop,
            child: child,
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF7C3AED), Color(0xFF9747FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _brandPrimary.withValues(alpha: 0.32),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative circles
              Positioned(
                right: -20, bottom: -20,
                child: _circle(84, 0.09),
              ),
              Positioned(
                left: -12, top: -12,
                child: _circle(52, 0.07),
              ),
              Positioned(
                right: 10, top: 10,
                child: _circle(24, 0.06),
              ),

              // Dashed border hint
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CustomPaint(painter: _DashedBorderPainter()),
                ),
              ),

              // Central content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: _pulseAnim,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.20),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.30),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          Icons.lock_rounded,
                          color: Colors.white,
                          size: 26,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Tap to Scratch',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Reveal your reward',
                      style: TextStyle(
                        fontFamily: 'NunitoSans',
                        fontSize: 10,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.70),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────────────────
  // REVEALED GRID TILE
  // ─────────────────────────────────────────────────────────────────────────
  Widget _buildRevealedCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _brandPrimary.withValues(alpha: 0.22),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: _brandPrimary.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: _SmallRevealContent(
          revealScale: _revealScale,
          revealFade: _revealFade,
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────
  Widget _circle(double size, double opacity) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: opacity),
        ),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// _OverlayCard  — the big modal with the scratcher
// ─────────────────────────────────────────────────────────────────────────────
class _OverlayCard extends StatelessWidget {
  final bool isScratched;
  final double scratchPercent;
  final GlobalKey<ScratcherState> scratcherKey;
  final Animation<double> revealScale;
  final Animation<double> revealFade;
  final Animation<Offset> codeSlide;
  final AnimationController confettiCtrl;
  final Animation<double> confettiFade;
  final Animation<double> hintOpacity;
  final ValueChanged<double> onScratchChange;
  final VoidCallback onThreshold;
  final VoidCallback onClose;
  final VoidCallback onCopy;

  static const Color _brandPrimary   = Color(0xFF7C3AED);
  static const Color _brandSecondary = Color(0xFF9747FF);

  const _OverlayCard({
    required this.isScratched,
    required this.scratchPercent,
    required this.scratcherKey,
    required this.revealScale,
    required this.revealFade,
    required this.codeSlide,
    required this.confettiCtrl,
    required this.confettiFade,
    required this.hintOpacity,
    required this.onScratchChange,
    required this.onThreshold,
    required this.onClose,
    required this.onCopy,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Card
        Container(
          width: 310,
          height: 380,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.28),
                blurRadius: 32,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: isScratched
                ? _buildRevealedOverlayContent(context)
                : _buildScratchSurface(),
          ),
        ),

        // Confetti layer (outside/above card)
        if (isScratched)
          Positioned.fill(
            child: IgnorePointer(
              child: FadeTransition(
                opacity: confettiFade,
                child: AnimatedBuilder(
                  animation: confettiCtrl,
                  builder: (_, __) => CustomPaint(
                    painter: _ConfettiPainter(
                      progress: confettiCtrl.value,
                      seed: 42,
                    ),
                  ),
                ),
              ),
            ),
          ),

        // Close button (top-right)
        Positioned(
          top: 0,
          right: 0,
          child: GestureDetector(
            onTap: onClose,
            child: Container(
              margin: const EdgeInsets.all(8),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close_rounded, size: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  // ── Scratch surface ────────────────────────────────────────────────────
  Widget _buildScratchSurface() {
    return Column(
      children: [
        // Top label
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7C3AED), Color(0xFF9747FF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: const Column(
            children: [
              Text(
                '🎁 Scratch Card',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Use your finger to scratch & reveal',
                style: TextStyle(
                  fontFamily: 'NunitoSans',
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),

        // Scratch area
        Expanded(
          child: Stack(
            children: [
              // The scratcher widget
              Scratcher(
                key: scratcherKey,
                brushSize: 52,
                threshold: 42,
                color: _brandSecondary,
                image: null,
                onChange: onScratchChange,
                onThreshold: onThreshold,
                child: Container(
                  color: Colors.white,
                  child: _RewardPreview(),
                ),
              ),

              // Animated scratch hint — fades out when user starts scratching
              Positioned.fill(
                child: IgnorePointer(
                  child: FadeTransition(
                    opacity: hintOpacity,
                    child: _ScratchHint(),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Progress bar
        _ScratchProgressBar(percent: scratchPercent),
      ],
    );
  }

  // ── Revealed overlay content ──────────────────────────────────────────
  Widget _buildRevealedOverlayContent(BuildContext context) {
    return FadeTransition(
      opacity: revealFade,
      child: ScaleTransition(
        scale: revealScale,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success icon with ring
              _AnimatedSuccessIcon(),

              const SizedBox(height: 18),

              // Amount
              const Text(
                '₹100 OFF',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: _brandPrimary,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Congratulations! You won a discount.',
                style: TextStyle(
                  fontFamily: 'NunitoSans',
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 22),

              // Code box — slides in after scale animation
              SlideTransition(
                position: codeSlide,
                child: _CouponCodeBox(onCopy: onCopy),
              ),

              const SizedBox(height: 14),

              Text(
                'Valid for 7 days  •  Min. order ₹499',
                style: TextStyle(
                  fontFamily: 'NunitoSans',
                  fontSize: 11,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _RewardPreview — visible beneath the scratch layer
// ─────────────────────────────────────────────────────────────────────────────
class _RewardPreview extends StatelessWidget {
  static const Color _brandPrimary = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: const BoxDecoration(
              color: Color(0xFFE8F5E9),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.celebration_rounded,
              color: Color(0xFF2E7D32),
              size: 42,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            '₹100 OFF',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: _brandPrimary,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'On your next order',
            style: TextStyle(
              fontFamily: 'NunitoSans',
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ScratchHint — animated fingerprint + wave hint
// ─────────────────────────────────────────────────────────────────────────────
class _ScratchHint extends StatefulWidget {
  @override
  State<_ScratchHint> createState() => _ScratchHintState();
}

class _ScratchHintState extends State<_ScratchHint>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveCtrl;
  late Animation<double> _waveAnim;
  late Animation<Offset> _swipeAnim;

  @override
  void initState() {
    super.initState();
    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _waveAnim = Tween<double>(begin: 0.85, end: 1.15)
        .animate(CurvedAnimation(parent: _waveCtrl, curve: Curves.easeInOut));

    _swipeAnim = Tween<Offset>(
      begin: const Offset(-0.15, 0),
      end: const Offset(0.15, 0),
    ).animate(CurvedAnimation(parent: _waveCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _waveCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF9747FF).withValues(alpha: 0.82),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SlideTransition(
              position: _swipeAnim,
              child: ScaleTransition(
                scale: _waveAnim,
                child: Icon(
                  Icons.swipe_rounded,
                  size: 56,
                  color: Colors.white.withValues(alpha: 0.90),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Scratch Here!',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.4,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Slide your finger across the card',
              style: TextStyle(
                fontFamily: 'NunitoSans',
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ScratchProgressBar
// ─────────────────────────────────────────────────────────────────────────────
class _ScratchProgressBar extends StatelessWidget {
  final double percent; // 0–100
  static const Color _brandPrimary = Color(0xFF7C3AED);

  const _ScratchProgressBar({required this.percent});

  @override
  Widget build(BuildContext context) {
    final clamped = percent.clamp(0.0, 100.0);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                clamped >= 40 ? 'Almost there!' : 'Scratch progress',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: clamped >= 40 ? _brandPrimary : const Color(0xFF9CA3AF),
                ),
              ),
              Text(
                '${clamped.toInt()}%',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: clamped >= 40 ? _brandPrimary : const Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: clamped / 100),
              duration: const Duration(milliseconds: 150),
              builder: (_, value, __) => LinearProgressIndicator(
                value: value,
                minHeight: 6,
                backgroundColor: const Color(0xFFF3F4F6),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.lerp(
                    const Color(0xFF9747FF),
                    const Color(0xFF7C3AED),
                    value,
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

// ─────────────────────────────────────────────────────────────────────────────
// _AnimatedSuccessIcon — pulsing ring + bouncing check
// ─────────────────────────────────────────────────────────────────────────────
class _AnimatedSuccessIcon extends StatefulWidget {
  @override
  State<_AnimatedSuccessIcon> createState() => _AnimatedSuccessIconState();
}

class _AnimatedSuccessIconState extends State<_AnimatedSuccessIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _ring;
  late Animation<double> _icon;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _ring = Tween<double>(begin: 1.0, end: 1.18)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _icon = Tween<double>(begin: 0.95, end: 1.05)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer pulsing ring
            Transform.scale(
              scale: _ring.value,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF43A047).withValues(alpha: 0.12),
                ),
              ),
            ),
            // Inner circle + icon
            Transform.scale(
              scale: _icon.value,
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFE8F5E9),
                ),
                child: const Icon(
                  Icons.celebration_rounded,
                  color: Color(0xFF2E7D32),
                  size: 36,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _CouponCodeBox
// ─────────────────────────────────────────────────────────────────────────────
class _CouponCodeBox extends StatefulWidget {
  final VoidCallback onCopy;
  const _CouponCodeBox({required this.onCopy});

  @override
  State<_CouponCodeBox> createState() => _CouponCodeBoxState();
}

class _CouponCodeBoxState extends State<_CouponCodeBox> {
  bool _copied = false;
  static const Color _brandPrimary = Color(0xFF7C3AED);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5FA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _brandPrimary.withValues(alpha: 0.22),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Your Coupon Code',
                style: TextStyle(
                  fontFamily: 'NunitoSans',
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'EXOTIC100',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: _brandPrimary,
                  letterSpacing: 2.0,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              widget.onCopy();
              setState(() => _copied = true);
              Future.delayed(const Duration(seconds: 2), () {
                if (mounted) setState(() => _copied = false);
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: _copied ? const Color(0xFF2E7D32) : _brandPrimary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _copied ? Icons.check_rounded : Icons.copy_rounded,
                    size: 13,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    _copied ? 'Copied!' : 'Copy',
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _SmallRevealContent — compact revealed tile content (grid card)
// ─────────────────────────────────────────────────────────────────────────────
class _SmallRevealContent extends StatelessWidget {
  final Animation<double> revealScale;
  final Animation<double> revealFade;
  static const Color _brandPrimary = Color(0xFF7C3AED);

  const _SmallRevealContent({
    required this.revealScale,
    required this.revealFade,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: revealFade,
      child: ScaleTransition(
        scale: revealScale,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8F5E9),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.celebration_rounded,
                  color: Color(0xFF2E7D32),
                  size: 28,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                '₹100 OFF',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: _brandPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'On your next order',
                style: TextStyle(
                  fontFamily: 'NunitoSans',
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _brandPrimary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'EXOTIC100',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: _brandPrimary,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// _ConfettiPainter — pure CustomPainter particle shower
// ─────────────────────────────────────────────────────────────────────────────
class _ConfettiPainter extends CustomPainter {
  final double progress; // 0.0 → 1.0
  final int seed;

  static const _colors = [
    Color(0xFF7C3AED),
    Color(0xFF9747FF),
    Color(0xFFE94A75),
    Color(0xFFFFC107),
    Color(0xFF43A047),
    Color(0xFF2196F3),
    Color(0xFFFF7043),
    Color(0xFFFFFFFF),
  ];

  const _ConfettiPainter({required this.progress, required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    const particleCount = 60;
    final rng = math.Random(seed);

    for (int i = 0; i < particleCount; i++) {
      final startX  = rng.nextDouble() * size.width;
      final speedX  = (rng.nextDouble() - 0.5) * 280;
      final speedY  = rng.nextDouble() * 600 + 200;
      final rot     = rng.nextDouble() * math.pi * 2;
      final rotSpd  = (rng.nextDouble() - 0.5) * 8;
      final w       = rng.nextDouble() * 10 + 5;
      final h       = rng.nextDouble() * 6 + 3;
      final delay   = rng.nextDouble() * 0.3;
      final color   = _colors[rng.nextInt(_colors.length)];
      final isCircle = rng.nextBool();

      final t = ((progress - delay) / (1.0 - delay)).clamp(0.0, 1.0);
      if (t <= 0) continue;

      final x = startX + speedX * t;
      final y = -30 + speedY * t + 200 * t * t; // gravity
      final alpha = (1.0 - t * 0.85).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = color.withValues(alpha: alpha)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rot + rotSpd * t);

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
// _DashedBorderPainter — dashed inner border on locked card
// ─────────────────────────────────────────────────────────────────────────────
class _DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashLen = 6.0;
    const gap     = 4.0;
    const stroke  = 1.2;
    final paint   = Paint()
      ..color  = Colors.white.withValues(alpha: 0.35)
      ..strokeWidth = stroke
      ..style  = PaintingStyle.stroke;
    final radius = const Radius.circular(10);
    final path   = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        radius,
      ));
    final metrics = path.computeMetrics().first;
    double dist = 0;
    while (dist < metrics.length) {
      final end = (dist + dashLen).clamp(0.0, metrics.length);
      canvas.drawPath(metrics.extractPath(dist, end), paint);
      dist += dashLen + gap;
    }
  }

  @override
  bool shouldRepaint(_DashedBorderPainter _) => false;
}
