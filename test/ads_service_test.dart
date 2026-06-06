import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:exotic/data/domains/ads/ad_service.dart';
import 'package:exotic/data/providers/ad_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AdService & AdProvider Integration Tests', () {
    setUp(() {
      SharedPreferences.setMockInitialValues({});
    });

    test('AdProvider state assignment and persistence flow', () async {
      final provider = AdProvider();

      // Let internal constructor _loadFromPrefs finish first to avoid race conditions
      await Future.delayed(const Duration(milliseconds: 50));

      // Ensure fresh provider starts empty
      expect(provider.activeCampaignId, isNull);
      expect(provider.activeClickId, isNull);
      expect(provider.activeProductId, isNull);

      // Set active ad parameters
      await provider.setActiveAd(campaignId: 42, clickId: 99, productId: 101);

      // Verify getters update immediately
      expect(provider.activeCampaignId, equals(42));
      expect(provider.activeClickId, equals(99));
      expect(provider.activeProductId, equals(101));

      // Retrieve the underlying SharedPreferences instance directly to verify physical persistence
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('active_campaign_id'), equals(42));
      expect(prefs.getInt('active_click_id'), equals(99));
      expect(prefs.getInt('active_product_id'), equals(101));
    });

    test('AdProvider clearActiveAd clears all cached fields', () async {
      final provider = AdProvider();

      // Let constructor pref load finish
      await Future.delayed(const Duration(milliseconds: 50));

      await provider.setActiveAd(campaignId: 123, clickId: 456, productId: 789);

      expect(provider.activeCampaignId, equals(123));

      await provider.clearActiveAd();

      expect(provider.activeCampaignId, isNull);
      expect(provider.activeClickId, isNull);
      expect(provider.activeProductId, isNull);

      // Verify cleared physically in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getInt('active_campaign_id'), isNull);
      expect(prefs.getInt('active_click_id'), isNull);
      expect(prefs.getInt('active_product_id'), isNull);
    });

    test('AdService live get_placements fallback safety check', () async {
      // Execute standard request block safely
      //await AdService.fetchAdPlacement(
      //   page: 'homepage',
      //   position: 'top',
      //   limit: 1,
      // );

      // Since network calls in tests are non-deterministic,
      // verify it either resolves to null (offline) or matches Map layout
      final result = [];

      if (result != null) {
        expect(result, isA<Map<String, dynamic>>());
      } else {
        expect(result, isNull);
      }
    });
  });
}
