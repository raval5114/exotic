import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domains/ads/ad_service.dart';

class AdProvider extends ChangeNotifier {
  int? _activeCampaignId;
  int? _activeClickId;
  int? _activeProductId;

  int? get activeCampaignId => _activeCampaignId;
  int? get activeClickId => _activeClickId;
  int? get activeProductId => _activeProductId;

  AdProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _activeCampaignId = prefs.getInt('active_campaign_id');
      _activeClickId = prefs.getInt('active_click_id');
      _activeProductId = prefs.getInt('active_product_id');
      notifyListeners();
    } catch (e) {
      print('AdProvider._loadFromPrefs Error: $e');
    }
  }

  Future<void> setActiveAd({int? campaignId, int? clickId, int? productId}) async {
    _activeCampaignId = campaignId;
    _activeClickId = clickId;
    _activeProductId = productId;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      if (campaignId != null) {
        await prefs.setInt('active_campaign_id', campaignId);
      } else {
        await prefs.remove('active_campaign_id');
      }
      
      if (clickId != null) {
        await prefs.setInt('active_click_id', clickId);
      } else {
        await prefs.remove('active_click_id');
      }

      if (productId != null) {
        await prefs.setInt('active_product_id', productId);
      } else {
        await prefs.remove('active_product_id');
      }
    } catch (e) {
      print('AdProvider.setActiveAd Error: $e');
    }
    
    notifyListeners();
  }

  Future<void> clearActiveAd() async {
    _activeCampaignId = null;
    _activeClickId = null;
    _activeProductId = null;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('active_campaign_id');
      await prefs.remove('active_click_id');
      await prefs.remove('active_product_id');
    } catch (e) {
      print('AdProvider.clearActiveAd Error: $e');
    }
    notifyListeners();
  }

  /// Attribute order conversion
  Future<void> attributeOrder({
    required int orderId,
    required double totalValue,
    required int? userId,
  }) async {
    if (_activeCampaignId == null) return;
    
    // Call AdService conversion endpoint
    await AdService.trackConversion(
      campaignId: _activeCampaignId!,
      orderId: orderId,
      userId: userId,
      clickId: _activeClickId,
      productId: _activeProductId,
      conversionValue: totalValue,
    );
    
    // Clear once attributed
    await clearActiveAd();
  }
}
