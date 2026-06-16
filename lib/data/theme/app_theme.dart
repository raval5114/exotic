import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// AppTheme — a ThemeExtension that surfaces brand, spacing and radius tokens
// to every widget tree via  Theme.of(context).extension<AppTheme>()!
// ─────────────────────────────────────────────────────────────────────────────
class AppTheme extends ThemeExtension<AppTheme> {
  // ── Brand colors ────────────────────────────────────────────────────────────
  final Color brandPrimary;
  final Color brandSecondary;
  final Color brandPink;

  // ── Spacing (8-pt grid) ─────────────────────────────────────────────────────
  final double spaceXS;  // 4
  final double spaceSM;  // 8
  final double spaceMD;  // 12
  final double spaceLG;  // 16
  final double spaceXL;  // 20
  final double spaceXXL; // 24

  // ── Border-radius ───────────────────────────────────────────────────────────
  final double radiusSM; // 8
  final double radiusMD; // 12
  final double radiusLG; // 16

  const AppTheme({
    required this.brandPrimary,
    required this.brandSecondary,
    required this.brandPink,
    required this.spaceXS,
    required this.spaceSM,
    required this.spaceMD,
    required this.spaceLG,
    required this.spaceXL,
    required this.spaceXXL,
    required this.radiusSM,
    required this.radiusMD,
    required this.radiusLG,
  });

  /// The single source-of-truth for the app's light theme tokens.
  const AppTheme.light()
      : brandPrimary   = const Color(0xFF7C3AED),
        brandSecondary = const Color(0xFF9747FF),
        brandPink      = const Color(0xFFE94A75),
        spaceXS        = 4.0,
        spaceSM        = 8.0,
        spaceMD        = 12.0,
        spaceLG        = 16.0,
        spaceXL        = 20.0,
        spaceXXL       = 24.0,
        radiusSM       = 8.0,
        radiusMD       = 12.0,
        radiusLG       = 16.0;

  // ── ThemeExtension boilerplate ───────────────────────────────────────────────
  @override
  AppTheme copyWith({
    Color? brandPrimary,
    Color? brandSecondary,
    Color? brandPink,
    double? spaceXS,
    double? spaceSM,
    double? spaceMD,
    double? spaceLG,
    double? spaceXL,
    double? spaceXXL,
    double? radiusSM,
    double? radiusMD,
    double? radiusLG,
  }) {
    return AppTheme(
      brandPrimary:   brandPrimary   ?? this.brandPrimary,
      brandSecondary: brandSecondary ?? this.brandSecondary,
      brandPink:      brandPink      ?? this.brandPink,
      spaceXS:        spaceXS        ?? this.spaceXS,
      spaceSM:        spaceSM        ?? this.spaceSM,
      spaceMD:        spaceMD        ?? this.spaceMD,
      spaceLG:        spaceLG        ?? this.spaceLG,
      spaceXL:        spaceXL        ?? this.spaceXL,
      spaceXXL:       spaceXXL       ?? this.spaceXXL,
      radiusSM:       radiusSM       ?? this.radiusSM,
      radiusMD:       radiusMD       ?? this.radiusMD,
      radiusLG:       radiusLG       ?? this.radiusLG,
    );
  }

  @override
  AppTheme lerp(AppTheme? other, double t) {
    if (other == null) return this;
    return AppTheme(
      brandPrimary:   Color.lerp(brandPrimary,   other.brandPrimary,   t)!,
      brandSecondary: Color.lerp(brandSecondary, other.brandSecondary, t)!,
      brandPink:      Color.lerp(brandPink,      other.brandPink,      t)!,
      spaceXS:        lerpDouble(spaceXS,   other.spaceXS,   t),
      spaceSM:        lerpDouble(spaceSM,   other.spaceSM,   t),
      spaceMD:        lerpDouble(spaceMD,   other.spaceMD,   t),
      spaceLG:        lerpDouble(spaceLG,   other.spaceLG,   t),
      spaceXL:        lerpDouble(spaceXL,   other.spaceXL,   t),
      spaceXXL:       lerpDouble(spaceXXL,  other.spaceXXL,  t),
      radiusSM:       lerpDouble(radiusSM,  other.radiusSM,  t),
      radiusMD:       lerpDouble(radiusMD,  other.radiusMD,  t),
      radiusLG:       lerpDouble(radiusLG,  other.radiusLG,  t),
    );
  }

  static double lerpDouble(double a, double b, double t) =>
      a + (b - a) * t;
}
