import 'dart:convert';

import 'package:exotic/Test/HomepagesTesting/model/interactions/elements/exoticComponents.dart';
import 'package:exotic/Test/HomepagesTesting/model/interactions/elements/exoticHomepageElement.dart';
import 'package:exotic/Test/HomepagesTesting/model/interactions/elements/exoticPage.dart';
import 'package:exotic/Test/HomepagesTesting/model/interactions/elements/exoticProduct.dart';
import 'package:exotic/Test/HomepagesTesting/model/interactions/interactions.dart';
import 'package:exotic/Test/HomepagesTesting/model/interactions/shell/interactionShell.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

///Interaction Provider Testing v.0.1
///--------------------------------------------------------

///this is for the testing purpose do not use this in production
class InteractionTestProvider extends ChangeNotifier {
  // ── Constants ───────────────────────────────────────────────────────────────
  static const String _storageKey = 'test_interactions';

  // ── State ───────────────────────────────────────────────────────────────────
  Interactions _interaction = Interactions();

  // ── Getters ─────────────────────────────────────────────────────────────────

  /// The raw [Interactions] container.
  Interactions get interaction => _interaction;

  /// All page-type interactions.
  List<Exoticpage> get pages =>
      List.unmodifiable(_interaction.interactions.whereType<Exoticpage>());

  /// All product-type interactions.
  List<ExoticProduct> get products =>
      List.unmodifiable(_interaction.interactions.whereType<ExoticProduct>());

  /// All component-type interactions.
  List<Exoticcomponents> get components => List.unmodifiable(
    _interaction.interactions.whereType<Exoticcomponents>(),
  );

  /// All homepageElement-type interactions.
  List<ExotichomepageElement> get homepageElements => List.unmodifiable(
    _interaction.interactions.whereType<ExotichomepageElement>(),
  );

  // ── Constructor ─────────────────────────────────────────────────────────────
  InteractionTestProvider() {
    _loadInteractions();
  }

  // ── Public API ──────────────────────────────────────────────────────────────

  /// Adds an [InteractionShell] to [_interaction].
  ///
  /// - Deduplicates by [interactionId] (existing entry removed, new one
  ///   appended to the tail so it is treated as most-recent).
  /// - Persists state to [SharedPreferences].
  /// - Calls [notifyListeners].
  void addInteraction(InteractionShell interaction) {
    _interaction.interactions.removeWhere(
      (e) => e.interactionId == interaction.interactionId,
    );
    _interaction.addInteraction(interaction);

    _saveToPrefs();
    notifyListeners();
  }

  // ── Persistence ─────────────────────────────────────────────────────────────

  /// Loads interactions from [SharedPreferences].
  ///
  /// Stored format:
  /// ```json
  /// {
  ///   "interaction": [ { ...InteractionShell fields... } ],
  ///   "createdAt":   "2026-06-16T10:00:00.000",
  ///   "updatedAt":   "2026-06-16T10:05:00.000"
  /// }
  /// ```
  Future<void> _loadInteractions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString == null || jsonString.isEmpty) return;

      final Map<String, dynamic> decoded =
          json.decode(jsonString) as Map<String, dynamic>;

      // Interactions.fromJson expects {"interactions": [...]}
      _interaction = Interactions.fromJson({
        'interactions': decoded['interaction'] ?? [],
      });

      notifyListeners();
    } catch (e) {
      debugPrint('InteractionTestProvider – error loading from prefs: $e');
    }
  }

  /// Serialises [_interaction] to [SharedPreferences].
  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final now = DateTime.now().toIso8601String();

      // Preserve the original createdAt if already stored.
      String createdAt = now;
      final existing = prefs.getString(_storageKey);
      if (existing != null && existing.isNotEmpty) {
        final prev = json.decode(existing) as Map<String, dynamic>;
        createdAt = (prev['createdAt'] as String?) ?? now;
      }

      await prefs.setString(
        _storageKey,
        json.encode({
          'interaction':
              _interaction.interactions.map((e) => e.toJson()).toList(),
          'createdAt': createdAt,
          'updatedAt': now,
        }),
      );
    } catch (e) {
      debugPrint('InteractionTestProvider – error saving to prefs: $e');
    }
  }

  /// Clears all interactions from memory and [SharedPreferences].
  Future<void> clearAllInteractions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_storageKey);
      _interaction = Interactions();
      notifyListeners();
    } catch (e) {
      debugPrint('InteractionTestProvider – error clearing interactions: $e');
    }
  }
}
