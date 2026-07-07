# 📋 Pending Issues & Work

> **Created At:** 2026-07-07T15:30:41Z

---

## 🐛 Pending Issues

### 1. Fixing Address API

**Problem:**
- Default address out of multiple addresses is not working.

**Solution:**
- Fix the update API at `api/customers/address_update.php` — make the field `ca_is_default` updatable.
- If an address is set as default, the previously default address should be automatically unset.

---

### 2. Ad Block API

**Problem:**
- Ad Block does not exist for the app; currently working on mock data.

**Solution:**
- Create the API based on the spec file at [`ads.service.md`](file:///d:/Flutter/freelance/exotic/lib/contexts/ads/ads.service.md).

---

### 3. Product Redirection from Homepage

**Problem:**
- Homepage elements currently do not include any product redirection to any specific screen.

**Solution:**
- Specify included products for each homepage element (needs to be added in homepage APIs).
- The API response must indicate whether it links to a **single product** or a **group of products**.

---

### 4. Payment Processing API

**Problem:**
- App is currently working on static widgets that only show the UI of the payment process.
- A real API is needed for the following flows:

**Solution:**
- Convert the entire payment processing flow to API-driven (order placement, payment mode selection).
- Convert payment status tracking to API-driven (order payment status tracking).

---

### 5. Your Review Status Showing

**Problem:**
- No API exists for showing reviews.
- Needs discussion on how the review flow will work:
  - From the product screen
  - A dedicated review screen showing more reviews for that product
  - A screen where the user can see all their reviews and their statuses

**Solution:**
- An API is needed at `/api/reviews/**` that returns the status of a customer's reviews.
- More product reviews are needed so that work on the product screen and product review screen can be observed and refactored if needed.

---

## 🔌 Pending APIs

| # | Area |
|---|------|
| 1 | Coupons and Offers |
| 2 | In-App and Push Notifications |
| 3 | Sell on Xotic |
| 4 | Vendor Details and Products |
| 5 | Terms, Policies, and Licences |
| 6 | FAQ |
| 7 | Privacy Center |
| 8 | Api for sending user intraction on elements of homepage |
| 9 | Api for sharing products |
