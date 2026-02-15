import 'package:flutter/material.dart';

final List<Map<String, dynamic>> products = [
  {
    "productName": "Noise ColorFit Pro 4 Smartwatch",
    "imgages": ["assets/images/categories/smartwatch1.jpg"],
    "ratings": 4,
    "discount": 25,
    "discountedPrice": 2999.00,
    "initialPrice": 3999.00,
    "isFreeDelivery": true,
    "sizeChart": {
      "sizeChart": ["S", "M"],
    },
    "policies": [
      {
        "icon": Icons.local_shipping,
        "title": "Free Delivery by",
        "subtitle": "24 Apr, Wednesday",
      },
      {"icon": Icons.restart_alt, "title": "15 days return policy"},
      {"icon": Icons.money, "title": "Cash on Delivery Available"},
    ],
    "offers": [
      {
        "title": "New User Offer",
        "highlight": "₹200 off",
        "description": "Applicable for first-time users only",
        "tncLink": "T&C",
      },
      {
        "title": "Combo Offer",
        "highlight": "",
        "description": "Buy with earbuds and get extra 10% off",
        "tncLink": "T&C",
      },
    ],
    "bankOffers": [
      {
        "icon": Icons.credit_card,
        "label": "Credit Card EMI",
        "amount": "₹500/month",
        "iconColor": Colors.green,
      },
      {
        "icon": Icons.credit_card_outlined,
        "label": "Debit EMI",
        "amount": "₹600/month",
        "iconColor": Colors.orange,
      },
    ],
    "delivery": {
      "name": "Karan",
      "pincode": "500001",
      "addressLine": "Charminar Road, Hyderabad",
      "onChange": () {},
    },
    "productDetails": {
      "Display": "1.8\" AMOLED",
      "Battery Life": "7 Days",
      "Water Resistance": "IP68",
      "Compatibility": "Android & iOS",
    },
    "sellerName": "Noise Official",
    "isSellerTrusted": true,
    "sellersRatings": 4.5,
    "reviews": [
      {
        "rating": 4.5,
        "reviewText": "Value for money!",
        "sizeInfo": null,
        "qualityText": "Features are top-notch",
      },
      {
        "rating": 4.0,
        "reviewText": "Decent for workouts",
        "sizeInfo": null,
        "qualityText": "Accurate tracking",
      },
    ],
  },
  {
    "productName": "Samsung Galaxy M14 5G Smartphone",
    "imgages": ["assets/images/categories/phone1.jpg"],
    "ratings": 4,
    "discount": 20,
    "discountedPrice": 10999.00,
    "initialPrice": 13999.00,
    "isFreeDelivery": true,
    "sizeChart": {
      "sizeChart": ["S", "M"],
    },
    "policies": [
      {
        "icon": Icons.local_shipping,
        "title": "Free Delivery by",
        "subtitle": "26 Apr, Friday",
      },
      {"icon": Icons.restart_alt, "title": "10 days replacement policy"},
      {"icon": Icons.money, "title": "Cash on Delivery Available"},
    ],
    "offers": [
      {
        "title": "Prepaid Offer",
        "highlight": "₹500 off",
        "description": "On Prepaid Transactions",
        "tncLink": "T&C",
      },
      {
        "title": "Exchange Offer",
        "highlight": "",
        "description": "Up to ₹8,000 off on exchange",
        "tncLink": "T&C",
      },
    ],
    "bankOffers": [
      {
        "icon": Icons.credit_card,
        "label": "Credit Card",
        "amount": "10% Instant Discount",
        "iconColor": Colors.green,
      },
      {
        "icon": Icons.account_balance_wallet,
        "label": "UPI",
        "amount": "Flat ₹300 Cashback",
        "iconColor": Colors.orange,
      },
    ],
    "delivery": {
      "name": "Priya",
      "pincode": "600001",
      "addressLine": "T Nagar, Chennai",
      "onChange": () {},
    },
    "productDetails": {
      "Display": "6.6\" PLS LCD",
      "Battery": "6000mAh",
      "Processor": "Exynos 1330",
      "Camera": "50MP Triple Camera",
    },
    "sellerName": "Samsung India",
    "isSellerTrusted": true,
    "sellersRatings": 4.6,
    "reviews": [
      {
        "rating": 4.5,
        "reviewText": "Smooth performance",
        "sizeInfo": null,
        "qualityText": "Excellent battery life",
      },
      {
        "rating": 4.0,
        "reviewText": "Good display quality",
        "sizeInfo": null,
        "qualityText": "Camera is decent",
      },
    ],
  },
  {
    "productName": "Adidas Men’s Running Shoes",
    "imgages": ["assets/images/categories/shoes1.jpg"],
    "ratings": 4,
    "discount": 35,
    "discountedPrice": 2599.00,
    "initialPrice": 3999.00,
    "isFreeDelivery": true,
    "sizeChart": {
      "sizeChart": ["S", "M"],
    },
    "policies": [
      {
        "icon": Icons.local_shipping,
        "title": "Free Delivery by",
        "subtitle": "27 Apr, Saturday",
      },
      {"icon": Icons.restart_alt, "title": "15 days return policy"},
      {"icon": Icons.money, "title": "Cash on Delivery Available"},
    ],
    "offers": [
      {
        "title": "Seasonal Sale",
        "highlight": "Extra 15% off",
        "description": "Running Shoes Fest Offer",
        "tncLink": "T&C",
      },
    ],
    "bankOffers": [
      {
        "icon": Icons.credit_card_outlined,
        "label": "Credit EMI",
        "amount": "₹300/month",
        "iconColor": Colors.purple,
      },
    ],
    "delivery": {
      "name": "Vikram",
      "pincode": "700001",
      "addressLine": "Park Street, Kolkata",
      "onChange": () {},
    },
    "productDetails": {
      "Material": "Mesh",
      "Closure": "Lace-Up",
      "Sole": "Rubber",
      "Usage": "Running, Training",
    },
    "sellerName": "Adidas Official",
    "isSellerTrusted": true,
    "sellersRatings": 4.3,
    "reviews": [
      {
        "rating": 4.5,
        "reviewText": "Perfect grip for jogging",
        "sizeInfo": "Size 9",
        "qualityText": "Soft and durable",
      },
      {
        "rating": 4.0,
        "reviewText": "Good quality shoes",
        "sizeInfo": "Size 8",
        "qualityText": "Stylish and comfortable",
      },
    ],
  },
  {
    "productName": "Prestige Induction Cooktop PIC 20",
    "imgages": ["assets/images/categories/kitchen1.jpg"],
    "ratings": 4,
    "discount": 40,
    "discountedPrice": 1799.00,
    "initialPrice": 2999.00,
    "isFreeDelivery": true,
    "sizeChart": {
      "sizeChart": ["S", "M"],
    },
    "policies": [
      {
        "icon": Icons.local_shipping,
        "title": "Free Delivery by",
        "subtitle": "28 Apr, Sunday",
      },
      {"icon": Icons.restart_alt, "title": "7 days replacement policy"},
      {"icon": Icons.money, "title": "Cash on Delivery Available"},
    ],
    "offers": [
      {
        "title": "Kitchen Combo Offer",
        "highlight": "",
        "description": "Get ₹150 off with cookware combo",
        "tncLink": "T&C",
      },
    ],
    "bankOffers": [
      {
        "icon": Icons.credit_card,
        "label": "Credit Card EMI",
        "amount": "₹200/month",
        "iconColor": Colors.teal,
      },
    ],
    "delivery": {
      "name": "Sneha",
      "pincode": "380001",
      "addressLine": "C G Road, Ahmedabad",
      "onChange": () {},
    },
    "productDetails": {
      "Power": "1600 Watts",
      "Preset Menus": "Indian Menu Options",
      "Body Material": "Plastic",
      "Warranty": "1 Year",
    },
    "sellerName": "Prestige Retail",
    "isSellerTrusted": true,
    "sellersRatings": 4.2,
    "reviews": [
      {
        "rating": 4.2,
        "reviewText": "Heats up quickly",
        "sizeInfo": null,
        "qualityText": "Energy efficient",
      },
      {
        "rating": 4.0,
        "reviewText": "Good for daily cooking",
        "sizeInfo": null,
        "qualityText": "Build quality is fine",
      },
    ],
  },

  {
    "productName": "boAt Rockerz 255 Pro+ Wireless Earphones",
    "imgages": ["assets/images/categories/earphones1.jpg"],
    "ratings": 4,
    "discount": 30,
    "discountedPrice": 1399.00,
    "initialPrice": 1999.00,
    "isFreeDelivery": true,
    "sizeChart": {
      "sizeChart": ["S", "M"],
    },
    "policies": [
      {
        "icon": Icons.local_shipping,
        "title": "Free Delivery by",
        "subtitle": "25 Apr, Thursday",
      },
      {"icon": Icons.restart_alt, "title": "7 days return policy"},
      {"icon": Icons.money, "title": "Cash on Delivery Available"},
    ],
    "offers": [
      {
        "title": "Festival Offer",
        "highlight": "Extra 10% off",
        "description": "Grab now during Mega Music Fest",
        "tncLink": "T&C",
      },
      {
        "title": "Partner Offer",
        "highlight": "",
        "description": "Buy with power bank and get ₹100 off",
        "tncLink": "T&C",
      },
    ],
    "bankOffers": [
      {
        "icon": Icons.credit_card,
        "label": "Credit Card",
        "amount": "Flat ₹100 off",
        "iconColor": Colors.blue,
      },
      {
        "icon": Icons.credit_card_outlined,
        "label": "Wallet",
        "amount": "5% Cashback",
        "iconColor": Colors.purple,
      },
    ],
    "delivery": {
      "name": "Arjun",
      "pincode": "110001",
      "addressLine": "Connaught Place, New Delhi",
      "onChange": () {},
    },
    "productDetails": {
      "Playback Time": "40 Hours",
      "Charging Time": "1.5 Hours",
      "Bluetooth": "5.0",
      "IP Rating": "IPX7",
      "Dual Pairing": "Yes",
    },
    "sellerName": "boAt Official",
    "isSellerTrusted": true,
    "sellersRatings": 4.5,
    "reviews": [
      {
        "rating": 4.5,
        "reviewText": "Battery backup is amazing!",
        "sizeInfo": null,
        "qualityText": "Perfect for travel",
      },
      {
        "rating": 4.0,
        "reviewText": "Good audio quality",
        "sizeInfo": null,
        "qualityText": "Clear and bass-heavy",
      },
    ],
  },
];
