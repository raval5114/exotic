import 'package:exotic/controllers/Homescreen/Homepage/Elements/banner_carosol.dart';
import 'package:exotic/controllers/Homescreen/Homepage/Elements/mobile_3d_icon_tray_component.dart';
import 'package:exotic/controllers/Homescreen/Homepage/Elements/mobile_budget_deals_component.dart';
import 'package:exotic/controllers/Homescreen/Homepage/Elements/mobile_category_grid.dart';
import 'package:exotic/controllers/Homescreen/Homepage/Elements/mobile_charm_slider.dart';
import 'package:exotic/controllers/Homescreen/Homepage/Elements/mobile_featured_slider.dart';
import 'package:exotic/controllers/Homescreen/Homepage/Elements/mobile_grid_offers.dart';
import 'package:exotic/controllers/Homescreen/Homepage/Elements/mobile_offer_strip.dart';
import 'package:exotic/controllers/Homescreen/Homepage/Elements/mobile_banner_widget.dart';
import 'package:exotic/controllers/Homescreen/Homepage/Elements/product_gallery.dart';
import 'package:exotic/data/models/Homepage/PageModel.dart';
import 'package:exotic/data/models/Homepage/elements/mobile-promo-banner.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_3d_icon_tray.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_budget_deals.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_category_strip.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_charm_slider.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_feature_slider.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_grid_offer.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_offer_strip.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_sponsored_banner.dart';
import 'package:exotic/data/models/Homepage/elements/mobile_suggestion_grid.dart';
import 'package:exotic/data/models/Homepage/elements/shell/Element.dart';
import 'package:flutter/material.dart';

class RowPageComponent extends StatefulWidget {
  final String tabName;
  final Rows rows;
  const RowPageComponent({
    super.key,
    required this.rows,
    required this.tabName,
  });

  @override
  State<RowPageComponent> createState() => _RowPageComponentState();
}

class _RowPageComponentState extends State<RowPageComponent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.08),
      end: Offset.zero,
    ).animate(_fadeAnimation);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex'; // add full opacity
    }
    return Color(int.parse(hex, radix: 16));
  }

  List<Widget> parseElementToWidget(List<PageElement> elements) {
    List<Widget> widgets = [];

    for (int i = 0; i < elements.length; i++) {
      final element = elements[i];

      Widget? child;

      if (element is MobilePromoBanner) {
        child = BannerCarouselWidget(
          title: element.title,
          banners: element.items,
          tabName: widget.tabName,
        );
      } else if (element is MobileSuggestionGrid) {
        child = MobileSuggestionProducts(
          title: element.title,
          config: element.config,
          products: element.items,
          tabName: widget.tabName,
        );
      } else if (element is Mobile3DIconTrayElement) {
        child = Mobile3dIconTrayComponent(
          element: element,
          tabName: widget.tabName,
        );
      } else if (element is MobileBudgetDealsElement) {
        child = MobileBudgetDealsComponent(
          element: element,
          tabName: widget.tabName,
        );
      } else if (element is MobileCategoryGridElement) {
        child = MobileCategoryGridComponent(
          element: element,
          tabName: widget.tabName,
        );
      } else if (element is MobileCharmSliderElement) {
        child = MobileCharmSliderWidget(
          element: element,
          tabName: widget.tabName,
        );
      } else if (element is MobileFeaturedSliderElement) {
        child = MobileFeaturedSliderWidget(
          element: element,
          tabName: widget.tabName,
        );
      } else if (element is MobileGridOffersElement) {
        child = MobileGridOffersWidget(
          element: element,
          tabName: widget.tabName,
        );
      } else if (element is MobileOfferStripElement) {
        child = MobileOfferStripWidget(
          element: element,
          tabName: widget.tabName,
        );
      } else if (element is MobileSponsoredBanner) {
        child = MobileSponsoredBannerWidget(
          element: element,
          tabName: widget.tabName,
        );
      } else {
        debugPrint('Unhandled PageElement Widget: ${element.runtimeType}');
      }

      if (child != null) {
        widgets.add(child);

        // Balanced vertical spacing between elements
        if (i < elements.length - 1) {
          widgets.add(const SizedBox(height: 12));
        }
      }
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    Styling styling = widget.rows.styling;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
          decoration: BoxDecoration(color: hexToColor(styling.backgroud_color)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: parseElementToWidget(widget.rows.elements),
          ),
        ),
      ),
    );
  }
}
