# Xotic Elements API Documentation

## Overview

This API provides dynamic content management for the Xotic mobile application. It allows the Flutter app to fetch page structures, elements, and product data dynamically from the admin panel.

## Base URL

```
https://xotic.in/api/elements/
```

---

## Endpoints

### 1. Get Page Content

Fetches complete page structure with all elements and data.

**Endpoint:** `GET /api/elements/page.php`

**Parameters:**
| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| slug | string | Yes | Page slug (e.g., "homepage") |

**Example Request:**

```
GET https://xotic.in/api/elements/page.php?slug=homepage
```

**Example Response:**

```json
{
  "success": true,
  "timestamp": 1706608449,
  "page": {
    "page_id": 1,
    "title": "Home Page",
    "slug": "homepage",
    "meta": {
      "title": "Xotic - Shop Online",
      "description": "Best deals on electronics",
      "keywords": "electronics, shopping, deals"
    },
    "rows": [
      {
        "row_id": 1,
        "layout_type": 1,
        "styling": {
          "background_color": "#ffffff",
          "background_image": null,
          "height": "auto",
          "padding": "16px",
          "margin": "0",
          "border_radius": "0",
          "border_width": "0",
          "border_style": "solid",
          "border_color": "#000000"
        },
        "elements": [
          {
            "element_id": 1,
            "element_type": "banner_carousel",
            "title": "Main Banner",
            "config": {
              "autoplay": true,
              "interval": 3000,
              "loop": true,
              "effect": "slide",
              "show_pagination": true,
              "show_navigation": false
            },
            "banners": [
              {
                "title": "Summer Sale",
                "subtitle": "Up to 50% off",
                "link_url": "/sale",
                "image_url": "https://xotic.in/UploadImages/ElementImages/banner1.jpg",
                "type": "image"
              }
            ]
          },
          {
            "element_id": 2,
            "element_type": "product_gallery_1",
            "title": "Featured Products",
            "config": {
              "gallery_title": "Featured Products",
              "view_more_url": "/products/featured",
              "gallery_width": 1200,
              "slider": {
                "show_arrows": true,
                "autoplay": false,
                "interval": 3000,
                "direction": "left",
                "anim_speed": 600
              },
              "fields": {
                "image": true,
                "name": true,
                "price": true,
                "mrp": true,
                "discount": true,
                "rating": true
              },
              "banner": {
                "position": "none",
                "url": "",
                "type": "image"
              }
            },
            "products": [
              {
                "product_id": 123,
                "name": "iPhone 15 Pro",
                "short_description": "Latest flagship phone",
                "image_url": "https://xotic.in/UploadImages/Variant/iphone15.jpg",
                "price": {
                  "selling_price": 129999.0,
                  "mrp_price": 149999.0,
                  "discount_percentage": 13
                },
                "rating": {
                  "average": 4.5,
                  "count": 1250
                },
                "badges": {
                  "ribbon": "Best Seller",
                  "deal": "Flat 20% off",
                  "free_shipping": true
                },
                "url": "iphone-15-pro"
              }
            ]
          },
          {
            "element_id": 3,
            "element_type": "product_grid",
            "title": "Shop by Category",
            "config": {
              "view_all_link": "/categories"
            },
            "items": [
              {
                "title": "Electronics",
                "subtitle": "Latest gadgets",
                "link_url": "/category/electronics",
                "image_url": "https://xotic.in/UploadImages/ElementImages/electronics.jpg"
              },
              {
                "title": "Fashion",
                "subtitle": "Trending styles",
                "link_url": "/category/fashion",
                "image_url": "https://xotic.in/UploadImages/ElementImages/fashion.jpg"
              }
            ]
          }
        ]
      }
    ]
  }
}
```

---

### 2. List All Pages

Returns list of all available pages.

**Endpoint:** `GET /api/elements/pages.php`

**Parameters:** None

**Example Request:**

```
GET https://xotic.in/api/elements/pages.php
```

**Example Response:**

```json
{
  "success": true,
  "timestamp": 1706608449,
  "count": 3,
  "pages": [
    {
      "page_id": 1,
      "title": "Home Page",
      "slug": "homepage",
      "meta_title": "Xotic - Shop Online",
      "meta_description": "Best deals on electronics",
      "created_at": "2026-01-30 12:00:00"
    },
    {
      "page_id": 2,
      "title": "Deals Page",
      "slug": "deals",
      "meta_title": "Hot Deals - Xotic",
      "meta_description": "Amazing deals and offers",
      "created_at": "2026-01-29 10:30:00"
    }
  ]
}
```

---

## Element Types

### 1. banner_carousel

Displays a carousel of banner images/videos.

**Structure:**

```json
{
  "element_type": "banner_carousel",
  "config": {
    "autoplay": true,
    "interval": 3000,
    "loop": true,
    "effect": "slide",
    "show_pagination": true,
    "show_navigation": false
  },
  "banners": [
    {
      "title": "Banner Title",
      "subtitle": "Banner Subtitle",
      "link_url": "/destination",
      "image_url": "https://...",
      "type": "image"
    }
  ]
}
```

### 2. product_gallery_1/2/3/4

Displays a horizontal scrollable gallery of products.

**Structure:**

```json
{
  "element_type": "product_gallery_1",
  "config": {
    "gallery_title": "Featured Products",
    "view_more_url": "/products",
    "slider": {
      "autoplay": false,
      "interval": 3000
    },
    "fields": {
      "image": true,
      "name": true,
      "price": true
    }
  },
  "products": [...]
}
```

### 3. product_grid

Displays a grid of custom items (categories, collections, etc.).

**Structure:**

```json
{
  "element_type": "product_grid",
  "config": {
    "view_all_link": "/categories"
  },
  "items": [
    {
      "title": "Category Name",
      "subtitle": "Description",
      "link_url": "/category/electronics",
      "image_url": "https://..."
    }
  ]
}
```

### 4. product_grid_vertical

Displays products in a vertical grid with additional details.

**Structure:**

```json
{
  "element_type": "product_grid_vertical",
  "config": {
    "view_all_link": "/products",
    "vertical_layout": "default"
  },
  "items": [
    {
      "title": "Product Name",
      "subtitle": "Description",
      "image_url": "https://...",
      "additional_images": ["url1", "url2"],
      "price": "999",
      "original_price": "1299",
      "discount": "23%",
      "tag": "New Arrival",
      "rating": 4.5
    }
  ]
}
```

### 5. product_grid_vertical2

Displays actual products from database in vertical grid.

**Structure:**

```json
{
  "element_type": "product_grid_vertical2",
  "products": [
    {
      "product_id": 123,
      "name": "Product Name",
      "image_url": "https://...",
      "price": {
        "selling_price": 999.0,
        "mrp_price": 1299.0,
        "discount_percentage": 23
      }
    }
  ]
}
```

---

## Product Object Structure

```json
{
  "product_id": 123,
  "name": "Product Name",
  "short_description": "Brief description",
  "image_url": "https://xotic.in/UploadImages/Variant/product.jpg",
  "price": {
    "selling_price": 999.0,
    "mrp_price": 1299.0,
    "discount_percentage": 23
  },
  "rating": {
    "average": 4.5,
    "count": 150
  },
  "badges": {
    "ribbon": "Best Seller",
    "deal": "Flat 20% off",
    "free_shipping": true
  },
  "url": "product-slug"
}
```

---

## Error Responses

All errors follow this format:

```json
{
  "success": false,
  "error": {
    "message": "Error description",
    "code": 400
  },
  "timestamp": 1706608449
}
```

**Common Error Codes:**

- `400` - Bad Request (missing parameters)
- `404` - Not Found (page doesn't exist)
- `405` - Method Not Allowed
- `500` - Internal Server Error

---

## Best Practices

### 1. Caching

Cache API responses in your Flutter app for better performance:

```dart
// Cache for 5 minutes
final cacheExpiry = Duration(minutes: 5);
```

### 2. Error Handling

Always handle errors gracefully:

```dart
try {
  final response = await fetchHomePage();
  // Handle success
} catch (e) {
  // Show error message or cached content
}
```

### 3. Image Loading

Use cached network images for better performance:

```dart
CachedNetworkImage(
  imageUrl: product.imageUrl,
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
)
```

### 4. Deep Linking

Use the `url` field in products for navigation:

```dart
Navigator.pushNamed(context, '/product/${product.url}');
```

---

## Rate Limiting

Currently no rate limiting is implemented. Recommended limits:

- 60 requests per minute per IP
- 1000 requests per hour per IP

---

## Changelog

### Version 1.0 (2026-01-30)

- Initial release
- Support for homepage dynamic content
- Product galleries and grids
- Banner carousels
- Full product data integration

---

## Support

For API issues or questions, contact:

- Email: dev@xotic.in
- Documentation: https://docs.xotic.in/api
