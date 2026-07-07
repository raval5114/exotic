# AdBlock Widget System — Context & Usage Guide

> Source: `lib/controllers/src/ad_blocks/widgets/`

---

## Overview

The `AdBlock` widget is the **single entry-point** for all advertisement rendering in the Exotic app. It fetches its own placement data, decides which ad sub-widget to render based on `ad_type` from the backend, and handles loading shimmer and empty-state silently.

Internally it delegates to one of three sub-widgets:

| Sub-widget | Renders when | File |
|---|---|---|
| `ProductTopAdSlider` | `page == 'product'` AND `position == 'top'` | `ad_block.dart` (inline) |
| `BannerAdWidget` | `ad_type == 'promote_brand'` | `banner_ad_widget.dart` |
| `ProductAdWidget` | `ad_type == 'promote_product'` or `'display_product'` | `product_ad_widget.dart` |

---

## AdBlock — Entry-point Widget

**File:** `lib/controllers/src/ad_blocks/widgets/ad_block.dart`

### Constructor

```dart
AdBlock({
  required String page,       // e.g. 'product', 'search', 'homepage'
  required String position,   // 'top' | 'middle' | 'bottom' | 'sidebar'
  int? categoryId,            // optional category filter
  String? keyword,            // optional search keyword
  int limit = 3,              // max ads to fetch (default 3)
})
```

### Supported Pages & Positions

| Page | Positions |
|---|---|
| `homepage` | `top`, `middle`, `bottom`, `sidebar` |
| `category` | `top`, `middle`, `bottom`, `sidebar` |
| `product` | `top`, `middle`, `bottom`, `sidebar` |
| `search` | `top`, `middle`, `bottom`, `sidebar` |
| `cart` | `top`, `middle`, `bottom`, `sidebar` |
| `checkout` | `top`, `middle`, `bottom`, `sidebar` |
| `product-grid` | `top`, `middle`, `bottom` |

### Lifecycle

1. `initState` → calls `_loadAds()`
2. `_loadAds()` → reads `UserProvider` for `userId`, then calls `AdService.fetchAdPlacement()`
3. On result → `setState` sets `_placement` and `_ads`, logs an `InteractionType.adProductList` or `InteractionType.adBanner` event via `InteractionProvider`
4. `build` → picks the correct sub-widget based on `page`, `position`, `ad_type`

### Render Decision Tree

```
AdBlock.build()
 │
 ├─ _isLoading == true
 │    └─ _AdShimmer (banner shimmer OR product carousel shimmer OR top-slider shimmer)
 │
 ├─ _ads.isEmpty || _placement == null
 │    └─ SizedBox.shrink()  ← renders nothing, never breaks layout
 │
 ├─ page == 'product' && position == 'top'
 │    └─ ProductTopAdSlider  ← compact 62px horizontal PageView
 │
 ├─ ad_type == 'promote_brand'
 │    └─ BannerAdWidget (one per ad in _ads list, stacked vertically)
 │
 └─ ad_type == 'promote_product' | 'display_product'
      └─ Horizontal ListView of ProductAdWidget cards (height: 255)
```

### Usage Examples

```dart
// Homepage top banner
AdBlock(page: 'homepage', position: 'top')

// Product page top compact slider
AdBlock(page: 'product', position: 'top', limit: 5)

// Mid-grid sponsored products (e.g. inside ProductViewerItemsWidget)
AdBlock(page: 'product', position: 'middle', limit: 4)

// Search page with keyword targeting
AdBlock(page: 'search', position: 'bottom', keyword: 'shoes', limit: 3)

// Category page with category targeting
AdBlock(page: 'category', position: 'sidebar', categoryId: 12)
```

### Required Providers (must be in ancestor widget tree)

| Provider | Used for |
|---|---|
| `UserProvider` | Reads `customerId` for personalised ad targeting |
| `AdProvider` | Stores `campaignId`, `clickId`, `productId` for conversion tracking |
| `InteractionProvider` | Logs ad impression interactions |

---

## ProductTopAdSlider — Compact Top-of-Page Slider

**File:** `lib/controllers/src/ad_blocks/widgets/ad_block.dart` (inline class)

### What it looks like
- Height: **62 px**
- Horizontal `PageView` with dot indicators
- Light purple card (`#F9F6FF`) with a product thumbnail, name, price, MRP, discount %, "AD" pill badge, and chevron
- Activates only for `page: 'product'` + `position: 'top'`

### Click behaviour
1. Calls `AdService.trackClick(adType: 'product_grid', ...)`
2. Stores campaign in `AdProvider`
3. Dispatches `FetchingSingleProductEvent` on `FetchProductBloc`
4. Navigates to `/dynamicRoute` → `ProductsShell`

---

## BannerAdWidget — Full-width Brand Banner

**File:** `lib/controllers/src/ad_blocks/widgets/banner_ad_widget.dart`

### What it looks like
- Full-width image (height: **180 px**), rounded corners (`r=20`)
- Dark gradient overlay from bottom
- Purple **"SPONSORED"** badge top-left
- Campaign name + "Shop Now →" CTA bottom-right
- Tap: scale animation (1.0 → 0.98 → 1.0), then `launchUrl` to `cb_banner_url`

### Key ad data fields consumed

| Field | Description |
|---|---|
| `banner_image_url` | Hero image URL |
| `vc_campaign_name` | Shown as title |
| `campaign_id` | Used for click tracking |
| `banner_id` | Used for click tracking |
| `cb_banner_url` | External URL to open on tap |

### Click behaviour
1. Calls `AdService.trackClick(adType: 'banner', bannerId: ..., campaignId: ...)`
2. Stores campaign in `AdProvider` (for conversion tracking at checkout)
3. Launches `cb_banner_url` externally via `url_launcher`

---

## ProductAdWidget — Sponsored Product Card (Horizontal Carousel)

**File:** `lib/controllers/src/ad_blocks/widgets/product_ad_widget.dart`

### What it looks like
- Card width: **175 px**, inside a horizontal `ListView`
- Product image fills top area
- Purple "Sponsored" label + product name + selling price + MRP (strikethrough)
- Red discount % badge top-left (shown only if discount > 0)
- Tap: scale animation (1.0 → 0.97 → 1.0), then navigates to product detail

### Key ad data fields consumed

| Field | Description |
|---|---|
| `product_image_url` | Product image |
| `product_name` | Card title |
| `selling_price` | Current price |
| `mrp` | Original price (strikethrough) |
| `campaign_id` | Used for click tracking |
| `product_id` | Used for click tracking + navigation |

### adType parameter
Passed from `AdBlock` — determines the click-tracking type:
- `'product_grid'` — used when shown inside product/category page
- `'search'` — used when shown inside search results

### Click behaviour
1. Calls `AdService.trackClick(adType: widget.adType, productId: ..., campaignId: ...)`
2. Stores campaign in `AdProvider`
3. Dispatches `FetchingSingleProductEvent` on `FetchProductBloc`
4. Navigates to `/dynamicRoute` → `ProductsShell`

---

## _AdShimmer — Loading Placeholder

**File:** `lib/controllers/src/ad_blocks/widgets/ad_block.dart` (private inline class)

Renders while `_isLoading == true`. Three variants selected automatically:

| Condition | Shimmer shape |
|---|---|
| `isTopSlider == true` | Single 62 px rounded bar |
| `isBanner == true` | Single 180 px full-width card |
| Neither (product carousel) | Title line + 3 product card rectangles (255 px tall) |

Uses a custom `AnimationController` with a sweeping gradient (no `shimmer` package dependency).

---

## Integration in ProductViewerItemsWidget

**File:** `lib/controllers/ProductViewer/src/ProductViewerItemsWidget.dart`

`AdBlock` is injected into the product grid every **5–10 items** (randomised) using a `CustomScrollView` + `SliverGrid` + `SliverToBoxAdapter` pattern:

```dart
AdBlock(page: 'product', position: position, limit: 4)
// position cycles randomly through: 'middle', 'bottom', 'sidebar'
```

This ensures the ad type returned from the backend varies naturally between banner ads and product carousel ads within the same product listing page.

---

## Tracking Flow Summary

```
User sees AdBlock
    │
    └─ AdService.fetchAdPlacement()  ← automatic impression logged server-side
           │
           └─ User taps ad
                  │
                  └─ AdService.trackClick()  ← click_id returned
                         │
                         └─ AdProvider.setActiveAd(campaignId, clickId, productId)
                                │
                                └─ User completes checkout
                                       │
                                       └─ AdService.trackConversion()  ← ROI tracked
```

---

## Notes for Developers

- **Never nest `AdBlock` inside a non-scrollable fixed-height parent** — it may render nothing (shimmer fills height) or overflow. Always use it as a sliver child or in a scrollable column.
- **`SizedBox.shrink()` fallback** — if no ads are available, `AdBlock` renders zero-size. It is safe to always include it and it will not break layout.
- **`limit` param** — for carousel (product) ads, set `limit: 4` or higher to populate the horizontal scroll meaningfully. For banners (`promote_brand`) a single ad is usually sufficient (`limit: 1`).
- **Interaction tracking** — the `InteractionProvider.addInteraction()` call inside `_loadAds()` fires after ads load. It will throw if `_placement` is null (guarded by the `if (result != null)` block).
