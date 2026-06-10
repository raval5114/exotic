import 'dart:convert';

import 'package:exotic/data/models/Interaction/interactions.dart';
import 'package:exotic/data/models/product_orignal.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InteractionProvider extends ChangeNotifier {
  // ── Constants ──────────────────────────────────────────────────────────────
  static const String _storageKey = 'user_interactions';

  /// Maximum number of interactions kept in history.
  static const int maxInteractions = 20;

  // ── State ──────────────────────────────────────────────────────────────────

  /// Flat list of all recorded interactions (capped at [maxInteractions]).
  ///
  /// Each entry is either an [InteractionPageModel] (page navigation) or an
  /// [InteractionProductModel] (product view).
  List<InteractionsShell> _interactions = [];

  // ── Typed getters ──────────────────────────────────────────────────────────

  /// All interactions (unmodifiable).
  List<InteractionsShell> get interactions => List.unmodifiable(_interactions);

  /// Only page-type interactions.
  List<InteractionPageModel> get pageInteractions =>
      List.unmodifiable(_interactions.whereType<InteractionPageModel>());

  /// Only product-type interactions.
  List<InteractionProductModel> get productInteractions =>
      List.unmodifiable(_interactions.whereType<InteractionProductModel>());

  // ── JSON getters ───────────────────────────────────────────────────────────

  /// All interactions serialised as a flat JSON-compatible list.
  ///
  /// Each map includes a `'kind'` discriminator (`'product'` or `'page'`)
  /// so consumers can distinguish the two types without importing the models.
  List<Map<String, dynamic>> get interactionsAsJson =>
      List.unmodifiable(_interactions.map((e) => e.toJson()));

  /// Only **product** interactions as JSON maps.
  ///
  /// Each map contains the full [ProductModel] under the `'product'` key
  /// (same structure as [ProductModel.toJson]) plus `'lastViewedAt'`,
  /// `'interactionId'`, and `'interactionType'`.
  List<Map<String, dynamic>> get productInteractionsAsJson =>
      List.unmodifiable(
        _interactions
            .whereType<InteractionProductModel>()
            .map((e) => e.toJson()),
      );

  /// Only **page** interactions as JSON maps.
  ///
  /// Each map contains `'pageName'`, `'lastViewedAt'`, and `'interactionType'`.
  List<Map<String, dynamic>> get pageInteractionsAsJson =>
      List.unmodifiable(
        _interactions.whereType<InteractionPageModel>().map((e) => e.toJson()),
      );

  /// Product interactions wrapped in a [RecentlyAdded] envelope.
  RecentlyAdded get recentlyAdded {
    final products =
        _interactions.whereType<InteractionProductModel>().toList();
    return RecentlyAdded(
      products: List.unmodifiable(products),
      lastViewedAt: products.isNotEmpty
          ? products.last.lastViewedAt
          : DateTime.now().toIso8601String(),
    );
  }

  // ── Constructor ────────────────────────────────────────────────────────────

  InteractionProvider() {
    loadFromPrefs();
  }

  // ── Public API ─────────────────────────────────────────────────────────────

  /// Records an interaction.
  ///
  /// - If [interactionType] is [InteractionType.productView], a
  ///   [InteractionProductModel] is created — [product] is required in this case.
  /// - For every other [InteractionType], a [InteractionPageModel] is created —
  ///   [pageName] is required in that case.
  ///
  /// If a duplicate entry already exists (same product+type or same page type),
  /// its timestamp is refreshed and it is moved to the tail of the list
  /// (most-recent). The list is capped at [maxInteractions] (20).
  void addInteraction({
    required InteractionType interactionType,
    ProductModel? product,
    String? pageName,
  }) {
    final now = DateTime.now().toIso8601String();

    if (interactionType == InteractionType.productView) {
      assert(
        product != null,
        'addInteraction: `product` must be provided when interactionType is productView.',
      );
      if (product == null) return;

      // Remove any existing entry for the same product.
      _interactions.removeWhere(
        (e) =>
            e is InteractionProductModel &&
            e.product.pId == product.pId &&
            e.interactionType == interactionType,
      );

      _interactions.add(
        InteractionProductModel(
          product: product,
          lastViewedAt: now,
          interactionId: DateTime.now().millisecondsSinceEpoch.toString(),
          interactionType: interactionType,
        ),
      );
    } else {
      assert(
        pageName != null,
        'addInteraction: `pageName` must be provided for page-type interactions.',
      );

      // Remove any existing entry for the same page type.
      _interactions.removeWhere(
        (e) =>
            e is InteractionPageModel &&
            e.interactionType == interactionType,
      );

      _interactions.add(
        InteractionPageModel(
          interactionType: interactionType,
          pageName: pageName ?? interactionType.name,
          lastViewedAt: now,
        ),
      );
    }

    _enforceLimit();
    _saveToPrefs();
    _logInteractions();
    notifyListeners();
  }

  /// Removes a single **product** interaction by the product's [pId].
  void removeProduct(String pId) {
    _interactions.removeWhere(
      (e) => e is InteractionProductModel && e.product.pId == pId,
    );
    _saveToPrefs();
    _logInteractions();
    notifyListeners();
  }

  /// Removes a **page** interaction by [interactionType].
  void removePage(InteractionType interactionType) {
    _interactions.removeWhere(
      (e) =>
          e is InteractionPageModel && e.interactionType == interactionType,
    );
    _saveToPrefs();
    _logInteractions();
    notifyListeners();
  }

  /// Removes **all** interactions of a specific [interactionType],
  /// regardless of their kind (page or product).
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

  // ── Persistence ────────────────────────────────────────────────────────────

  /// Loads persisted interactions from [SharedPreferences].
  ///
  /// Called automatically on construction; can also be called manually to
  /// force a re-hydration (e.g. after clearing prefs in settings).
  Future<void> loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_storageKey);
      if (jsonString == null || jsonString.isEmpty) return;

      final decoded = json.decode(jsonString);
      try {
        if (decoded is List<dynamic>) {
          // Current format: flat JSON array with a 'kind' discriminator.
          _interactions = decoded
              .map((e) => _deserialise(e as Map<String, dynamic>))
              .whereType<InteractionsShell>()
              .toList();
        } else if (decoded is Map<String, dynamic>) {
          // Legacy format: stored as a RecentlyAdded envelope (products only).
          final envelope = RecentlyAdded.fromJson(decoded);
          _interactions = envelope.products.toList();
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
    } catch (e) {
      debugPrint('InteractionProvider – error loading from prefs: $e');
    }
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  /// Deserialises a single JSON map into the correct [InteractionsShell]
  /// subtype using the `kind` discriminator field.
  InteractionsShell? _deserialise(Map<String, dynamic> map) {
    switch (map['kind'] as String?) {
      case 'page':
        return InteractionPageModel.fromJson(map);
      case 'product':
      default:
        return InteractionProductModel.fromJson(map);
    }
  }

  /// Drops the oldest entries when the list exceeds [maxInteractions].
  void _enforceLimit() {
    if (_interactions.length > maxInteractions) {
      _interactions = _interactions.sublist(
        _interactions.length - maxInteractions,
      );
    }
  }

  /// Persists the current list to [SharedPreferences] as a flat JSON array.
  Future<void> _saveToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        _storageKey,
        json.encode(_interactions.map((e) => e.toJson()).toList()),
      );
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
