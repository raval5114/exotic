import 'package:go_router/go_router.dart';
import 'package:exotic/data/theme/app_theme.dart';
import 'package:exotic/view/auth/Signin/signin.dart';
import 'package:exotic/view/auth/Signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainAuthComponenState extends StatefulWidget {
  const MainAuthComponenState({super.key});

  @override
  State<MainAuthComponenState> createState() => _MainAuthComponenStateState();
}

class _MainAuthComponenStateState extends State<MainAuthComponenState>
    with TickerProviderStateMixin {
  late final AnimationController _entryCtrl;
  late final AnimationController _floatCtrl;

  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;
  late final Animation<double> _logoScaleAnim;
  late final Animation<double> _floatAnim;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    // ── Entry animation (runs once) ──────────────────────────────────────────
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnim = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.1, 1.0, curve: Curves.easeOutCubic),
      ),
    );
    _logoScaleAnim = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(
        parent: _entryCtrl,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    // ── Subtle floating loop ─────────────────────────────────────────────────
    _floatCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut),
    );

    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _floatCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).extension<AppTheme>()!;
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Gradient background ─────────────────────────────────────────
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  t.brandPrimary,
                  const Color(0xFF5B21B6),
                  t.brandSecondary,
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // ── Decorative circles ──────────────────────────────────────────
          Positioned(
            top: -80,
            right: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.06),
              ),
            ),
          ),
          Positioned(
            top: 80,
            left: -90,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: 260,
            right: -40,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: t.brandPink.withValues(alpha: 0.3),
              ),
            ),
          ),

          // ── Content ─────────────────────────────────────────────────────
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: t.spaceXXL),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // ── Logo + tagline ────────────────────────────────────────
                  FadeTransition(
                    opacity: _fadeAnim,
                    child: AnimatedBuilder(
                      animation: _floatAnim,
                      builder: (_, child) => Transform.translate(
                        offset: Offset(0, _floatAnim.value),
                        child: child,
                      ),
                      child: ScaleTransition(
                        scale: _logoScaleAnim,
                        child: Column(
                          children: [
                            // Logo
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  width: 1.5,
                                ),
                              ),
                              child: Image.asset(
                                'assets/logo/logo.png',
                                height: 72,
                                width: 72,
                                errorBuilder: (_, __, ___) => const Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 72,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: t.spaceLG),
                            Text(
                              'Exotic',
                              style: theme.textTheme.displaySmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.5,
                              ),
                            ),
                            SizedBox(height: t.spaceXS),
                            Text(
                              'Shop the extraordinary',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: Colors.white.withValues(alpha: 0.75),
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const Spacer(flex: 3),

                  // ── Bottom card ───────────────────────────────────────────
                  SlideTransition(
                    position: _slideAnim,
                    child: FadeTransition(
                      opacity: _fadeAnim,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(t.spaceXXL),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(t.radiusLG + 8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 40,
                              offset: const Offset(0, -8),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Handle pill
                            Container(
                              width: 40,
                              height: 4,
                              margin: EdgeInsets.only(bottom: t.spaceLG),
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),

                            Text(
                              'Welcome',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: t.spaceXS),
                            Text(
                              'Sign in to discover curated products\njust for you',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.black45,
                                height: 1.6,
                              ),
                            ),

                            SizedBox(height: t.spaceXXL),

                            // ── Get Started ──────────────────────────────────
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: t.brandPrimary,
                                  foregroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(t.radiusMD),
                                  ),
                                ),
                                onPressed: () => context.push(
                                  '/dynamicRoute',
                                  extra: () => SignupScreen(),
                                ),
                                child: Text(
                                  "Get Started",
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: t.spaceMD),

                            // ── Sign In ──────────────────────────────────────
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: t.brandPrimary,
                                  side: BorderSide(
                                    color: t.brandPrimary.withValues(alpha: 0.4),
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(t.radiusMD),
                                  ),
                                ),
                                onPressed: () => context.push(
                                  '/dynamicRoute',
                                  extra: () => SigninScreen(),
                                ),
                                child: Text(
                                  "Sign In",
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: t.brandPrimary,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: t.spaceMD),

                            // ── Guest ────────────────────────────────────────
                            TextButton(
                              onPressed: () => context.go('/home'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.black45,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Continue as Guest',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: t.spaceXS),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 12,
                                    color: Colors.black38,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: t.spaceLG),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
