import 'package:exotic/controllers/Homescreen/Homepage/Elements/banner_carosol.dart';
import 'package:exotic/controllers/Homescreen/Homepage/Elements/mobile_3d_icon_tray_component.dart';
import 'package:exotic/controllers/Homescreen/Homepage/Elements/mobile_budget_deals_component.dart';
import 'package:exotic/controllers/Homescreen/Homepage/Elements/mobile_category_grid.dart';
import 'package:exotic/controllers/Homescreen/Homepage/Elements/mobile_charm_slider.dart';
import 'package:exotic/controllers/Homescreen/Homepage/Elements/mobile_featured_slider.dart';
import 'package:exotic/controllers/Homescreen/Homepage/Elements/mobile_grid_offers.dart';
import 'package:exotic/controllers/Homescreen/Homepage/Elements/mobile_offer_strip.dart';
import 'package:exotic/controllers/Homescreen/Homepage/Elements/mobile_sponsored_banner.dart';
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
  final Rows rows;
  const RowPageComponent({super.key, required this.rows});

  @override
  State<RowPageComponent> createState() => _RowPageComponentState();
}

class _RowPageComponentState extends State<RowPageComponent> {
  @override
  Widget build(BuildContext context) {
    Styling styling = widget.rows.styling;
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
          child = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: BannerCarouselWidget(banners: element.items),
          );
        } else if (element is MobileSuggestionGrid) {
          child = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: MobileSuggestionProducts(
              title: element.title,
              config: element.config,
              products: element.items,
            ),
          );
        } else if (element is Mobile3DIconTrayElement) {
          child = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Mobile3dIconTrayComponent(element: element),
          );
        } else if (element is MobileBudgetDealsElement) {
          child = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: MobileBudgetDealsComponent(element: element),
          );
        } else if (element is MobileCategoryGridElement) {
          child = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: MobileCategoryGridComponent(element: element),
          );
        } else if (element is MobileCharmSliderElement) {
          child = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: MobileCharmSliderWidget(element: element),
          );
        } else if (element is MobileFeaturedSliderElement) {
          child = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: MobileFeaturedSliderWidget(element: element),
          );
        } else if (element is MobileGridOffersElement) {
          child = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: MobileGridOffersWidget(element: element),
          );
        } else if (element is MobileOfferStripElement) {
          child = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: MobileOfferStripWidget(element: element),
          );
        } else if (element is MobileSponsoredBanner) {
          child = Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: MobileSponsoredBannerWidget(element: element),
          );
        } else {
          debugPrint('Unhandled PageElement Widget: ${element.runtimeType}');
        }

        if (child != null) {
          widgets.add(child);

          // Add divider only if NOT the last element
          if (i < elements.length - 1) {
            widgets.add(const Divider(color: Colors.black, thickness: 0.8));
          }
        }
      }

      return widgets;
    }

    return Container(
      decoration: BoxDecoration(color: hexToColor(styling.backgroud_color)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, // ✅ IMPORTANT
        children: parseElementToWidget(widget.rows.elements),
      ),
    );
  }
}
