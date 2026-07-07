# Exotic Ads Flutter Service

A production-ready Flutter advertisement service for integrating **Exotic Ads** into Flutter applications.

The service automatically handles:

- Advertisement placement retrieval
- Impression tracking
- Click tracking (CPC)
- Conversion tracking (ROI)
- Offline mock advertisements for local development

---

# Features

- ✅ Fetch advertisements based on page and position
- ✅ Automatic impression logging
- ✅ Click tracking
- ✅ Conversion tracking
- ✅ Local fallback advertisements
- ✅ Supports Product Ads and Brand Ads
- ✅ Clean Repository Pattern implementation


# Project Structure

```
lib/
│
├── data/
│   ├── repositories/
│   │     └── ads/
│   │           └── ad_repo.dart
│   │
│   └── services/
│         └── ad_service.dart
```

---

# API Base URL

```
https://xotic.in/api/ads
```

---

# Supported Pages

Advertisements can be requested for the following pages:

| Page |
|-------|
| homepage |
| category |
| product |
| search |
| cart |
| checkout |
| product-grid |
---

# Supported Positions

Each page supports four advertisement positions.

| Position |
|----------|
| top |
| middle |
| bottom |
| sidebar |

---

# Advertisement Types

The backend currently supports:

- `promote_product`
- `promote_brand`

---

# Installation

Add the service inside your project.

```dart
final adService = AdService();
```

---

# Fetch Advertisements

```dart
final ads = await adService.fetchAdPlacement(
    page: "homepage",
    position: "top",
    userId: 15,
);
```

## Parameters

| Parameter | Required | Description |
|------------|----------|-------------|
| page | ✅ | Current application page |
| position | ✅ | Ad position |
| userId | ❌ | Current logged in user |
| categoryId | ❌ | Category filtering |
| keyword | ❌ | Search keyword |
| limit | ❌ | Maximum ads |

---

# Response

Example:

```json
{
  "placement": {
    "id": 1,
    "vc_name": "Premium Brands",
    "ad_type": "promote_brand"
  },
  "ads": [
    {
      "campaign_id": 42,
      "banner_id": 10,
      "banner_image_url": "...",
      "vc_campaign_name": "Summer Luxury Fashion"
    }
  ]
}
```

---

# Track Click

Whenever a user clicks an advertisement:

```dart
await adService.trackClick(
    campaignId: 42,
    adType: "banner",
    bannerId: 10,
    userId: 15,
);
```

Supported ad types:

- banner
- product_grid
- search

---

# Track Conversion

After successful checkout:

```dart
await adService.trackConversion(
    campaignId: 42,
    orderId: 1256,
    clickId: 17,
    userId: 15,
    conversionValue: 2499,
);
```

This helps calculate:

- ROI
- Conversion Rate
- Campaign Performance

---

# Offline Mock Mode

If the backend is unavailable, the service automatically returns premium mock advertisements.

Mock data exists for:

- Homepage
- Category
- Product
- Search
- Cart
- Checkout
- Product-grid
Each contains:

- Top Ads
- Middle Ads
- Bottom Ads
- Sidebar Ads

This allows UI development without backend dependency.

---

# Automatic Impression Tracking

Calling

```dart
fetchAdPlacement()
```

automatically logs impressions on the backend.

No additional implementation is required.

---

# Error Handling

The service gracefully handles:

- Network failures
- Invalid responses
- Backend downtime

When an API request fails:

1. Returns local mock advertisements (if available)
2. Returns `null` if no mock data exists

---

# Architecture

```
UI
 │
 ▼
Repository
 │
 ▼
AdService
 │
 ▼
HTTP API
 │
 ▼
Exotic Ads Backend
```

---

# API Endpoints

| Endpoint | Description |
|-----------|-------------|
| `/get_placements.php` | Fetch advertisement placements |
| `/track_click.php` | Record advertisement clicks |
| `/track_conversion.php` | Record successful conversions |

---

# Technologies Used

- Flutter
- Dart
- HTTP Package
- Repository Pattern
- REST API

---

# Future Improvements

- Cached advertisements
- Retry mechanism
- Analytics dashboard
- Ad frequency capping
- User segmentation
- A/B testing support
- Banner preloading

---

# License

This project is intended for integration with the Exotic Ads platform and follows the licensing terms of the parent application.