import 'dart:convert';

import 'package:exotic/data/models/interactions.dart';
import 'package:exotic/data/models/product_orignal.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InteractionProvider extends ChangeNotifier {
  // ── Constants ─────────────────────────────────────────────────────────────
  static const String _storageKey = 'user_interactions';

  /// Maximum number of interactions kept in history.
  static const int maxInteractions = 20;

  // ── State ──────────────────────────────────────────────────────────────────
  /// Flat list of all recorded interactions (capped at [maxInteractions]).
  List<InteractionProductModel> _interactions = [];

  /// Convenience wrapper that exposes the list as a [RecentlyAdded] object.
  RecentlyAdded get recentlyAdded => RecentlyAdded(
    product: List.unmodifiable(_interactions),
    lastViewedAt:
        _interactions.isNotEmpty
            ? _interactions.last.lastViewedAt
            : DateTime.now().toIso8601String(),
  );

  /// Unmodifiable view of the raw interaction list.
  List<InteractionProductModel> get interactions =>
      List.unmodifiable(_interactions);

  // ── Constructor ────────────────────────────────────────────────────────────
  InteractionProvider() {
    loadFromPrefs();
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Loads persisted interactions from [SharedPreferences].
  ///
  /// Called automatically on construction; can also be called manually to
  /// force a re-hydration (e.g. after clearing prefs in settings).
  Future<void> loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final decoded = json.decode(jsonString);
        try {
          if (decoded is Map<String, dynamic>) {
            // Stored as a RecentlyAdded envelope.
            final recentlyAddedData = RecentlyAdded.fromJson(decoded);
            _interactions = recentlyAddedData.product.toList();
          } else if (decoded is List<dynamic>) {
            // Fallback: stored as a raw JSON array.
            _interactions =
                decoded
                    .map(
                      (e) => InteractionProductModel.fromJson(
                        e as Map<String, dynamic>,
                      ),
                    )
                    .toList();
          }
        } catch (decodeErr) {
          // Stored data used an old/incompatible schema — wipe and start fresh.
          debugPrint(
            'InteractionProvider – stale prefs schema, clearing: $decodeErr',
          );
          _interactions = [];
          await prefs.remove(_storageKey);
        }
        _enforceLimit();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('InteractionProvider – error loading from prefs: $e');
    }
  }

  /// Records a new interaction for [product] of the given [interactionType].
  ///
  /// • If the product already exists in the list for the same [interactionType],
  ///   its [lastViewedAt] timestamp is refreshed and it is moved to the end.
  /// • If the list would exceed [maxInteractions] (20), the oldest entry is
  ///   removed first.
  void addInteraction({
    required ProductModel product,
    required InteractionType interactionType,
  }) {
    final now = DateTime.now().toIso8601String();

    // Check for an existing entry with the same product + type.
    final existingIndex = _interactions.indexWhere(
      (e) =>
          e.product.pId == product.pId && e.interactionType == interactionType,
    );

    if (existingIndex != -1) {
      // Remove old entry so we can re-insert it at the tail (most-recent).
      _interactions.removeAt(existingIndex);
    }

    final newEntry = InteractionProductModel(
      product: product,
      lastViewedAt: now,
      interactionId: DateTime.now().millisecondsSinceEpoch,
      interactionType: interactionType,
    );

    _interactions.add(newEntry);
    _enforceLimit();
    _saveToPrefs();
    _logInteractions();
    notifyListeners();
  }

  /// Removes a single interaction by the product's [pId].
  void removeInteraction(String pId) {
    _interactions.removeWhere((e) => e.product.pId == pId);
    _saveToPrefs();
    _logInteractions();
    notifyListeners();
  }

  /// Removes all interactions of a specific [interactionType].
  void removeByType(InteractionType interactionType) {
    _interactions.removeWhere((e) => e.interactionType == interactionType);
    _saveToPrefs();
    _logInteractions();
    notifyListeners();
  }

  /// Clears **all** recorded interactions.
  Future<void> clearAll() async {
    _interactions.clear();
    await _saveToPrefs();
    _logInteractions();
    notifyListeners();
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  /// Drops the oldest entries when the list exceeds [maxInteractions].
  void _enforceLimit() {
    if (_interactions.length > maxInteractions) {
      _interactions = _interactions.sublist(
        _interactions.length - maxInteractions,
      );
    }
  }

  /// Persists the current list to [SharedPreferences] as a [RecentlyAdded]
  /// JSON envelope.
  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final envelope = RecentlyAdded(
        product: _interactions,
        lastViewedAt:
            _interactions.isNotEmpty
                ? _interactions.last.lastViewedAt
                : DateTime.now().toIso8601String(),
      );
      await prefs.setString(_storageKey, json.encode(envelope.toJson()));
    } catch (e) {
      debugPrint('InteractionProvider – error saving to prefs: $e');
    }
  }

  // ── Console JSON Logger ────────────────────────────────────────────────────

  /// Pretty-prints the current [_interactions] list as a JSON array
  /// to the Flutter debug console after every mutation.
  void _logInteractions() {
    const encoder = JsonEncoder.withIndent('  ');
    debugPrint(encoder.convert(_interactions.map((e) => e.toJson()).toList()));
  }
}
