# 🏗️ Exotic — Project Architecture

> **Stack**: Flutter · Dart SDK ^3.7.2  
> **State Management**: BLoC + Provider (dual approach)  
> **Routing**: GoRouter  
> **DI**: GetIt  
> **Local Storage**: Hive  
> **Networking**: http  

---

## Table of Contents

1. [Overview](#overview)
2. [High-Level Architecture](#high-level-architecture)
3. [Directory Structure](#directory-structure)
4. [Layer Breakdown](#layer-breakdown)
5. [Feature Modules](#feature-modules)
6. [State Management Strategy](#state-management-strategy)
7. [Routing](#routing)
8. [Dependency Injection](#dependency-injection)
9. [Caching Strategy](#caching-strategy)
10. [Assets & Theme](#assets--theme)
11. [Key Dependencies](#key-dependencies)

---

## Overview

**Exotic** is a Flutter-based e-commerce mobile application. It follows a **layered clean-architecture** approach with:

- A **Data layer** holding BLoCs, domains (services), models, providers, and repositories.
- A **Controllers layer** acting as UI-bound business logic / widget-level controllers.
- A **View layer** containing thin screen/page widgets.
- **Utils** for cross-cutting concerns (injection, caching, helpers).

The project uses a **dual state-management pattern**:
- **flutter_bloc** (BLoC/Cubit) for server-driven, async feature flows.
- **Provider** (ChangeNotifier) for lighter, UI-local reactive state.

---

## High-Level Architecture

```
┌────────────────────────────────────────────────────────────────────┐
│                          main.dart                                 │
│          (MultiProvider + MultiBlocProvider bootstrap)             │
└──────────┬────────────────────┬────────────────────────────────────┘
           │                    │
    ┌──────▼──────┐      ┌──────▼──────┐
    │  GoRouter   │      │   GetIt DI  │
    │  (routes)   │      │ (injection) │
    └──────┬──────┘      └─────────────┘
           │
┌──────────▼──────────────────────────────────────────────┐
│                     VIEW LAYER                          │
│  lib/view/  —  Thin screens / page-entry widgets        │
└──────────┬──────────────────────────────────────────────┘
           │
┌──────────▼──────────────────────────────────────────────┐
│                  CONTROLLERS LAYER                      │
│  lib/controllers/  — Widget-level business logic,       │
│  composite components, rich UI controllers              │
└──────────┬──────────────────────────────────────────────┘
           │
┌──────────▼──────────────────────────────────────────────┐
│                    DATA LAYER                           │
│  lib/data/                                              │
│  ├── blocs/        BLoC / Cubit state machines          │
│  ├── domains/      Service / use-case objects           │
│  ├── models/       Data transfer objects                │
│  ├── providers/    ChangeNotifier reactive state        │
│  ├── repositories/ Abstract data contracts              │
│  ├── routes/       GoRouter config                      │
│  └── theme/        AppTheme extension                   │
└──────────┬──────────────────────────────────────────────┘
           │
┌──────────▼──────────────────────────────────────────────┐
│                  EXTERNAL SERVICES                      │
│  REST API (http) · Hive (local cache) ·                 │
│  Google Maps · Mailer · SMS Autofill                    │
└─────────────────────────────────────────────────────────┘
```

---

## Directory Structure

```
lib/
├── main.dart                          # App entry point, DI bootstrap, provider/bloc wiring
├── contexts/                          # Architecture docs & context notes
│   ├── ads.readme.md
│   ├── homepage_architecture_readme.md
│   └── project.arch.md                ← YOU ARE HERE
│
├── data/                              # DATA LAYER
│   ├── blocs/                         # BLoC / Cubit state machines
│   │   ├── auth/bloc/                 # auth_bloc, auth_event, auth_state
│   │   ├── cart/bloc/                 # cart_bloc, cart_event, cart_state
│   │   ├── homescreen/
│   │   │   ├── homepage/bloc/         # homepage_bloc, homepage_event, homepage_state
│   │   │   └── categories/
│   │   │       ├── bloc/              # categories_bloc, categories_event, categories_state
│   │   │       └── cubit/             # subcategories_cubit
│   │   ├── orderList/bloc/            # order_list_bloc, order_list_event, order_list_state
│   │   ├── productViewer/bloc/        # product_viewer_bloc, _event, _state
│   │   ├── products/bloc/             # fetch_products_bloc
│   │   ├── reviews/                   # reviews_bloc, reviews_event, reviews_state
│   │   ├── searchProduct/bloc/        # search_product_bloc, _event, _state
│   │   ├── splashScreen/bloc/         # splash_screen_bloc, _event, _state
│   │   ├── vendorStore/bloc/          # vender_bloc, vender_event, vender_state
│   │   ├── wishList/bloc/             # wishlist_bloc, wishlist_event, wishlist_state
│   │   └── address/bloc/              # address_bloc, address_event, address_state
│   │
│   ├── domains/                       # Business-logic / Service objects (use cases)
│   │   ├── ads/                       # ad_service.dart
│   │   ├── auth/                      # auth.dart
│   │   ├── brands/                    # brands.dart
│   │   ├── cart/                      # cart_service.dart
│   │   ├── homesrceen/
│   │   │   ├── homepage/              # homepage.dart, homepage_caching_service.dart
│   │   │   └── categories/            # categories.dart
│   │   ├── orderList/                 # orderList.dart
│   │   ├── productViewer/             # productViewer.dart
│   │   ├── reviews/                   # reviews.dart
│   │   ├── searchProduct/             # searchProduct.dart
│   │   ├── vendorStore/               # vendorStore.dart
│   │   ├── wishlist/                  # wishlist.dart
│   │   ├── address/                   # addresses_domain.dart
│   │   ├── product.dart               # ProductService (top-level domain)
│   │   └── fetch_product_impl.dart
│   │
│   ├── models/                        # DTOs / data models
│   │   ├── Homepage/
│   │   │   ├── PageModel.dart
│   │   │   ├── homepageModel.dart
│   │   │   ├── elements/              # Banner, carousel, grid, strip element models
│   │   │   └── cacheModeling/         # tabs_cache.dart
│   │   ├── Interaction/
│   │   │   ├── interactions.dart
│   │   │   └── abtract/
│   │   ├── address_model.dart
│   │   ├── brands.dart
│   │   ├── cart.dart
│   │   ├── categories.dart
│   │   ├── homepage_page_model.dart
│   │   ├── metaData.dart
│   │   ├── order_list_model.dart
│   │   ├── product_orignal.dart
│   │   ├── reviews.dart
│   │   ├── search_product_model.dart
│   │   ├── singleProductModel.dart
│   │   ├── user.dart
│   │   └── wishlist.dart
│   │
│   ├── providers/                     # ChangeNotifier providers (lighter reactive state)
│   │   ├── ad_provider.dart
│   │   ├── address_provider.dart
│   │   ├── brands_provider.dart
│   │   ├── cart_provider.dart
│   │   ├── categories_provider.dart
│   │   ├── homepage_provider.dart
│   │   ├── interaction_provider.dart
│   │   ├── meta_data_provider.dart
│   │   ├── order_list_provider.dart
│   │   ├── product_provider.dart
│   │   ├── reviews_provider.dart
│   │   ├── search_product_provider.dart
│   │   ├── user_login_provider.dart
│   │   ├── user_provider.dart
│   │   └── wishlist_provider.dart
│   │
│   ├── repositories/                  # Abstract contracts / repository implementations
│   │   ├── address/                   # addressesRepo.dart
│   │   ├── ads/                       # ad_repo.dart
│   │   ├── auth/                      # auth.dart
│   │   ├── brands/                    # brands.dart
│   │   ├── cart/                      # cart.dart
│   │   ├── homescreen/
│   │   │   ├── homepage/              # homepage.dart, homepage_caching_service.dart
│   │   │   └── categories.dart/
│   │   ├── orderList/                 # orderRepo.dart
│   │   ├── productViewer/             # IProductViewerRepo.dart
│   │   ├── products/                  # fetchProduct.dart, products.dart
│   │   ├── reviews/                   # reviews.dart
│   │   ├── searchProductPage/         # searchProductPage.dart
│   │   ├── vendorStore/               # vendorStore.dart
│   │   └── wishlist/                  # wishlist.dart
│   │
│   ├── routes/
│   │   └── routes.dart                # GoRouter configuration (all named routes)
│   │
│   └── theme/
│       └── app_theme.dart             # AppTheme ThemeExtension (brand tokens)
│
├── controllers/                       # CONTROLLERS LAYER (UI-bound components)
│   ├── Homescreen/
│   │   ├── Cart/                      # cartComponent.dart + shared/
│   │   ├── Categories/
│   │   ├── EditProfile/
│   │   ├── Homepage/
│   │   │   ├── homePageController.dart
│   │   │   ├── sliver_homepage_controller.dart
│   │   │   ├── pageComponent.dart
│   │   │   ├── rowPage.dart
│   │   │   ├── Elements/              # Homepage element renderers
│   │   │   ├── lazyloading/
│   │   │   └── src/
│   │   ├── Profile/
│   │   └── widgets/
│   ├── ProductViewer/
│   │   ├── productViewer.dart
│   │   └── src/
│   ├── Reviews/
│   │   ├── reviewsController.dart
│   │   └── src/
│   ├── address/
│   │   ├── AddressComponent.dart
│   │   ├── addAddressComponent.dart
│   │   ├── addAddressMainComponent.dart
│   │   ├── showAddressInHompage.dart
│   │   ├── updateAddressComponent.dart
│   │   ├── viewAddressComponent.dart
│   │   └── src/
│   ├── auth/
│   │   ├── auth_main_component.dart   # Main auth orchestrator
│   │   ├── Signin/
│   │   ├── Signup/
│   │   ├── forgetPassword/
│   │   ├── subscreen/
│   │   └── src/
│   ├── offersAndCoupens/
│   │   ├── offersAndCoupensComponent.dart
│   │   └── src/
│   ├── orderDetails/
│   │   ├── animatedDeliveyStatusComponent.dart
│   │   ├── orderDetailsComponent.dart
│   │   ├── orderDetailsDeliveryStatusComponent.dart
│   │   └── src/
│   ├── orderList/
│   │   ├── orderListComponent.dart
│   │   ├── orderListOrderShowingComponent.dart
│   │   └── src/
│   ├── payment/
│   │   ├── paymentController.dart
│   │   ├── orderPaymentController.dart
│   │   ├── orderPaymentOptions.dart
│   │   └── src/
│   ├── products/
│   │   ├── productShellController.dart
│   │   ├── productScreenController.dart
│   │   ├── productScreenComponent.dart
│   │   ├── productScreenLoadingController.dart
│   │   └── shared/
│   ├── searchProduct/
│   │   ├── searchProductComponent.dart
│   │   ├── searchProductDiscoverProduct.dart
│   │   ├── searchProductGridComponent.dart
│   │   ├── searchProductPopularProduct.dart
│   │   ├── searchProductRecentSearch.dart
│   │   ├── searchQuerySectionComponent.dart
│   │   └── src/
│   ├── splashscreen/
│   │   └── splashScreenComponent.dart
│   ├── vendorStore/
│   │   ├── vendorStore.dart
│   │   ├── vendorStoreProductsComponent.dart
│   │   └── src/
│   ├── wishlist/
│   │   ├── wishlist.dart
│   │   └── src/
│   └── src/
│       ├── appbar.dart                # Shared custom AppBar
│       └── ad_blocks/                 # Ad block rendering
│
├── view/                              # VIEW LAYER (thin screen entry points)
│   ├── Address/
│   │   ├── addAdress.dart
│   │   ├── updateAddress.dart
│   │   └── viewAddress.dart
│   ├── auth/
│   │   ├── auth_main.dart
│   │   ├── Signin/
│   │   ├── Signup/
│   │   ├── forgotPassword/
│   │   └── updatePassword/
│   ├── brandStore/
│   │   └── brandStore.dart
│   ├── homescreen/
│   │   ├── homescreen.dart            # Shell with bottom nav bar
│   │   └── sections/
│   │       ├── homescreen.dart        # Home tab content
│   │       ├── cart.dart
│   │       ├── categories.dart
│   │       └── profile.dart
│   ├── oderlist/
│   │   └── orderList.dart
│   ├── offersAndCoupens/
│   │   └── offersAndCoupens.dart
│   ├── orderCancelationPages/
│   │   ├── orderCancelPage.dart
│   │   └── orderCancelPageConfirmation.dart
│   ├── orderDetails/
│   │   ├── orderDetails.dart
│   │   └── orderDeliveryStatus.dart
│   ├── payment/
│   │   ├── payment.dart
│   │   ├── orderPaymentScreen.dart
│   │   ├── orderPaymentCompletionScreen.dart
│   │   └── orderPaymentSuccessfullScreen.dart
│   ├── productViewer/
│   │   └── productViewer.dart
│   ├── productgrid/
│   │   └── productgridViewer.dart
│   ├── products/
│   │   ├── productScreen.dart
│   │   └── allReviewsScreen.dart
│   ├── reviews/
│   │   └── ReviewScreen.dart
│   ├── searchProduct/
│   │   ├── searchProduct.dart
│   │   └── searchProductGrid.dart
│   ├── splashscreen/
│   │   └── splashScreen.dart
│   ├── venderStore/
│   │   └── venderStore.dart
│   ├── widgets/                       # Shared reusable widgets
│   │   ├── product_tile.dart
│   │   └── searched_items_widget.dart
│   └── wishlist/
│       └── wishlist.dart
│
├── utils/                             # CROSS-CUTTING UTILITIES
│   ├── injection.dart                 # GetIt DI setup (setUpGetItLocator)
│   ├── User.dart                      # User utility
│   ├── adImages.dart                  # Ad image helpers
│   ├── auth_dialog.dart               # Reusable auth dialog
│   ├── cachedImage.dart               # Cached network image wrapper
│   ├── categories.dart                # Category list utilities
│   ├── constants.dart                 # App constants
│   ├── errorFormat.dart               # Error formatting
│   ├── exception.dart                 # Custom exceptions
│   ├── image_formatter.dart           # Image format utilities
│   ├── newProductList.dart            # Product list builder
│   ├── products.dart                  # Product utilities
│   ├── searchProduct.dart             # Search utilities
│   ├── cache/                         # Hive cache helpers
│   │   └── homepageCache.dart
│   └── interactions/                  # (reserved / empty)
│
└── Test/                              # Manual/integration test files
    ├── AuthTesting.dart
    ├── CartTesting.dart
    ├── SingleProductCalling.dart
    ├── categories_testing.dart
    ├── product_showing_testing.dart
    ├── search_product_testing.dart
    ├── sigin_page.dart
    ├── signinWithCredentials.dart
    ├── testDNS.dart
    ├── AdTesting/
    ├── HomepagesTesting/
    ├── ProductViewerTesting/
    ├── Reviews/
    └── SearchProduct/
```

---

## Layer Breakdown

### Entry Point — `main.dart`

`main.dart` bootstraps the entire application:

1. **Hive initialisation** — opens the `homepageCache` Hive box.
2. **GetIt setup** — calls `setUpGetItLocator()` which registers all singletons.
3. **MultiProvider** — wraps the widget tree with all `ChangeNotifier` providers:
   - `UserLoginProvider`, `UserProvider`, `CategoriesProvider`, `BrandsProvider`
   - `ProductProvider`, `CartProvider`, `WishlistProvider`, `MetaDataProvider`
   - `HomepageProvider`, `SearchProductProvider`, `OrderListProvider`
   - `AddressProvider`, `AdProvider`, `InteractionProvider`
4. **MultiBlocProvider** (via BlocProvider list) — registers all BLoC / Cubit instances:
   - `FetchProductBloc`, `VenderBloc`, `SplashScreenBloc`, `AuthBloc`
   - `HomepageBloc`, `CategoriesBloc`, `CartBloc`, `WishlistBloc`
   - `SubcategoriesCubit`, `SearchProductBloc`, `OrderListBloc`, `AddressBloc`
5. **MaterialApp.router** — uses `goRoutes` (GoRouter config) and `AppTheme.light()`.

---

### Data Layer — `lib/data/`

The data layer is subdivided into six sub-directories, each with a specific responsibility:

#### `blocs/`

BLoC/Cubit state machines. Each feature has its own `bloc/` sub-folder with three files:
- `*_bloc.dart` — the `Bloc<Event, State>` class, event handlers, API calls.
- `*_event.dart` — sealed event classes (triggers).
- `*_state.dart` — sealed state classes (UI reactions).

| BLoC | Responsibility |
|------|----------------|
| `AuthBloc` | Login, logout, token management |
| `HomepageBloc` | Homepage data fetch & refresh |
| `CategoriesBloc` | Category tree loading |
| `SubcategoriesCubit` | Sub-category navigation state |
| `CartBloc` | Cart CRUD operations |
| `WishlistBloc` | Wishlist add/remove |
| `FetchProductBloc` | Product list pagination |
| `ProductViewerBloc` | Single product detail fetch |
| `SearchProductBloc` | Debounced search queries |
| `OrderListBloc` | Order history fetch |
| `AddressBloc` | Address CRUD |
| `VenderBloc` | Vendor store data |
| `SplashScreenBloc` | Init / auth-check on startup |
| `ReviewsBloc` | Product reviews fetch/submit |

#### `domains/`

Service / use-case objects (pure Dart classes). These encapsulate business logic and directly call repositories or HTTP endpoints.

| Domain Service | Purpose |
|----------------|---------|
| `HomePageRepo` | Homepage sections API |
| `HomepageCachingService` | Hive-based homepage cache layer |
| `CategoriesRepo` | Category list API |
| `ProductService` | Product listing & detail API |
| `BrandsServices` | Brand list API |
| `CartService` | Cart API (add/remove/update) |
| `SearchproductRepo` | Search API |
| `WishlistService` | Wishlist API |
| `AdService` | Ads API (complex multi-type ad rendering) |
| `AuthService` | Login / register / OTP APIs |
| `AddressesDomain` | Address CRUD API |
| `ReviewsService` | Reviews API |
| `OrderListService` | Order history API |

#### `models/`

Dart data-transfer objects (DTOs). All use `fromJson` / `toJson` patterns (Equatable where relevant).

Key models:

| Model | Description |
|-------|-------------|
| `ProductOrignal` | Full product model (complex, 14KB) |
| `SingleProductModel` | Single product detail (8.5KB) |
| `HomepageModel` / `PageModel` | Homepage section rendering models |
| `OrderListModel` | Order history |
| `Cart` | Cart items |
| `AddressModel` | Shipping addresses |
| `ReviewsModel` | Product reviews |
| `SearchProductModel` | Search results |
| `WishlistModel` | Wishlist items |
| `UserModel` | Authenticated user profile |
| `MetaData` | API metadata |
| `BrandsModel` | Brand data |
| `CategoriesModel` | Category tree |
| `InteractionsModel` | User interaction tracking |

#### `providers/`

`ChangeNotifier`-based reactive state. Used for:
- UI-reactive but non-async-heavy state.
- Shared UI state across the widget tree (e.g., `CartProvider`, `WishlistProvider`).
- User session (`UserLoginProvider`, `UserProvider`).

#### `repositories/`

Abstract contracts defining data-access APIs. Implementations are injected via GetIt.

#### `routes/` & `theme/`

- `routes.dart` — single `GoRouter` instance with all named routes.
- `app_theme.dart` — `AppTheme` `ThemeExtension` defining brand colour tokens.

---

### Controllers Layer — `lib/controllers/`

Acts as a **UI controller / presenter layer**. Each controller corresponds to a feature screen and contains:
- Stateful widget logic (tab management, animation controllers).
- Composition of multiple child widgets into full-screen components.
- Business-logic calls via BLoC/Provider.

| Controller Module | Key Files |
|-------------------|-----------|
| `Homescreen/Homepage/` | `homePageController`, `sliver_homepage_controller`, `rowPage`, `pageComponent` |
| `Homescreen/Cart/` | `cartComponent` |
| `Homescreen/Categories/` | Category grid/list UI |
| `auth/` | `auth_main_component` — full auth flow orchestrator |
| `ProductViewer/` | `productViewer` — product detail page shell |
| `products/` | `productShellController`, `productScreenController` |
| `searchProduct/` | Search UI components (recent, popular, discover, grid) |
| `Reviews/` | `reviewsController` — full reviews page (20KB) |
| `address/` | Add / View / Update address forms |
| `payment/` | Payment gateway integration |
| `orderList/` | Order history list UI |
| `orderDetails/` | Order detail + animated delivery status |
| `wishlist/` | Wishlist page |
| `vendorStore/` | Vendor product listing |
| `offersAndCoupens/` | Coupons & offers page |
| `splashscreen/` | Splash screen component |
| `src/appbar.dart` | Shared custom app bar (11KB) |

---

### View Layer — `lib/view/`

Thin **page entry points** that are the GoRouter route targets. Each file is typically a `StatelessWidget` or minimal `StatefulWidget` that delegates to the corresponding controller.

| Route | View File |
|-------|-----------|
| `/` | `view/splashscreen/splashScreen.dart` |
| `/auth` | `view/auth/auth_main.dart` |
| `/home` | `view/homescreen/sections/homescreen.dart` (ShellRoute child) |
| `/categories` | `view/homescreen/sections/categories.dart` |
| `/cart` | `view/homescreen/sections/cart.dart` |
| `/profile` | `view/homescreen/sections/profile.dart` |
| `/ProductsViewer` | `view/productViewer/productViewer.dart` |
| `/productGrid` | `view/productgrid/productgridViewer.dart` |
| `/searchProductPage` | `view/searchProduct/searchProduct.dart` |
| `/wishlist` | `view/wishlist/wishlist.dart` |
| `/orderList` | `view/oderlist/orderList.dart` |
| `/reviews` | `view/reviews/ReviewScreen.dart` |
| `/addAddress` | `view/Address/addAdress.dart` |
| `/viewAddress` | `view/Address/viewAddress.dart` |
| `/updateAddress` | `view/Address/updateAddress.dart` |
| `/payment` | `view/payment/payment.dart` |
| `/coupensAndOffers` | `view/offersAndCoupens/offersAndCoupens.dart` |

The `Homescreen` shell (`view/homescreen/homescreen.dart`) wraps the bottom-nav routes with a persistent navigation bar.

---

### Utils — `lib/utils/`

| File | Purpose |
|------|---------|
| `injection.dart` | GetIt DI locator setup (`setUpGetItLocator`) |
| `constants.dart` | App-wide constants |
| `auth_dialog.dart` | Reusable login-prompt dialog |
| `cachedImage.dart` | CachedNetworkImage wrapper with placeholder |
| `errorFormat.dart` | Standardized error message formatting |
| `exception.dart` | Custom exception classes |
| `image_formatter.dart` | Image URL processing utilities |
| `categories.dart` | Category data helpers |
| `adImages.dart` | Ad image asset helpers |
| `newProductList.dart` | Product list builders |
| `cache/homepageCache.dart` | Hive box cache helper |

---

### Contexts — `lib/contexts/`

Documentation folder for developer reference:

| File | Content |
|------|---------|
| `ads.readme.md` | Ad system architecture |
| `homepage_architecture_readme.md` | Homepage data flow architecture |
| `project.arch.md` | This file — whole-project architecture |

---

## Feature Modules

Each feature follows a consistent pattern:

```
Feature
 ├── data/blocs/<feature>/bloc/         BLoC (event → state)
 ├── data/domains/<feature>/            Service / use-case
 ├── data/models/<feature model>        DTO
 ├── data/providers/<feature>_provider  ChangeNotifier (if needed)
 ├── data/repositories/<feature>/       Repository contract
 ├── controllers/<feature>/             UI controllers/components
 └── view/<feature>/                    Thin screen entry point
```

### Feature Coverage Matrix

| Feature | BLoC | Domain | Provider | Repository |
|---------|:----:|:------:|:--------:|:----------:|
| Auth | ✅ | ✅ | ✅ | ✅ |
| Homescreen / Homepage | ✅ | ✅ | ✅ | ✅ |
| Categories | ✅ + Cubit | ✅ | ✅ | ✅ |
| Cart | ✅ | ✅ | ✅ | ✅ |
| Wishlist | ✅ | ✅ | ✅ | ✅ |
| Products | ✅ | ✅ | ✅ | ✅ |
| ProductViewer | ✅ | ✅ | — | ✅ |
| Search | ✅ | ✅ | ✅ | ✅ |
| Reviews | ✅ | ✅ | ✅ | ✅ |
| Orders / OrderList | ✅ | ✅ | ✅ | ✅ |
| Address | ✅ | ✅ | ✅ | ✅ |
| Ads | — | ✅ | ✅ | ✅ |
| Brands | — | ✅ | ✅ | ✅ |
| VendorStore | ✅ | ✅ | — | ✅ |
| Payment | — | — | — | — |
| Offers & Coupons | — | — | — | — |
| SplashScreen | ✅ | — | — | — |

---

## State Management Strategy

The app uses **two complementary patterns**:

```
┌─────────────────────────────────────────────────────┐
│                  BLoC Pattern                       │
│  For: async server calls, complex state transitions │
│  Packages: bloc ^9.0.0, flutter_bloc ^9.1.1         │
│                                                     │
│  Event ──► Bloc ──► State ──► UI rebuild            │
│              │                                      │
│              ▼                                      │
│         Domain Service ──► Repository ──► API       │
└─────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────┐
│             Provider Pattern (ChangeNotifier)        │
│  For: lightweight reactive state, cross-widget data │
│  Package: provider ^6.1.5                           │
│                                                     │
│  ChangeNotifier ──► notifyListeners ──► UI rebuild  │
│        │                                            │
│        ▼                                            │
│   Domain Service / local state mutation             │
└─────────────────────────────────────────────────────┘
```

Both patterns are registered at root in `main.dart` and accessed anywhere via `context.read<T>()` or `BlocProvider.of<T>(context)`.

---

## Routing

GoRouter (`go_router ^15.1.2`) is used with a **ShellRoute** for the main navigation shell:

```
/                     → SplashScreen
/auth                 → AuthMainScreen
/home                 → [ShellRoute] HomeScreen
/categories           → [ShellRoute] CategoriesScreen
/cart                 → [ShellRoute] CartScreen
/profile              → [ShellRoute] ProfileScreen
/ProductsViewer       → ProductViewer   (extra: {url, title})
/productGrid          → ProductGridViewer (extra: {title, items})
/reviews              → ReviewScreen   (extra: ReviewsProvider)
/searchProductPage    → SearchProductPage
/wishlist             → WishlistScreen
/orderList            → OrderListPage
/addAddress           → AddAddress
/viewAddress          → ViewAddress
/updateAddress        → UpdateAddress  (extra: Address)
/payment              → PaymentScreen
/coupensAndOffers     → OffersandCoupens
/dynamicRoute         → Dynamic widget builder (dev use)
```

Navigation uses `context.go('/route')` or `context.push('/route', extra: data)`.

---

## Dependency Injection

`GetIt` (`get_it ^8.0.3`) is the service locator. All singletons are registered in `lib/utils/injection.dart`:

```dart
// Hive cache box
getit.registerLazySingleton<Box>(() => homepageCacheBox);

// Caching service
getit.registerLazySingleton<HomepageCachingService>(...);

// Domain services
getit.registerLazySingleton<HomePageRepo>(() => HomePageRepo());
getit.registerLazySingleton<CategoriesRepo>(() => CategoriesRepo());
getit.registerLazySingleton<ProductService>(() => ProductService());
getit.registerLazySingleton<BrandsServices>(() => BrandsServices());
getit.registerLazySingleton<CartService>(() => CartService());
getit.registerLazySingleton<SearchproductRepo>(() => SearchproductRepo());
getit.registerLazySingleton<WishlistService>(() => WishlistService());
getit.registerLazySingleton<UserLoginProvider>(() => UserLoginProvider());
getit.registerLazySingleton<ReviewsProvider>(() => ReviewsProvider());
```

Access in code: `getit<ServiceType>()`.

---

## Caching Strategy

The homepage uses a **two-level caching strategy**:

```
Request Homepage Data
        │
        ▼
 HomepageCachingService
        │
        ├── Cache HIT ──► Return cached Hive data (fast path)
        │
        └── Cache MISS ──► HomePageRepo (HTTP API call)
                                │
                                ▼
                          Store in Hive box
                                │
                                ▼
                          Return to Bloc → State → UI
```

Hive box: `homepageCache` (opened at startup, registered as singleton via GetIt).

---

## Assets & Theme

### Asset Directories

| Asset Path | Contents |
|-----------|---------|
| `assets/src/` | Login blobs, bubble background images |
| `assets/logo/` | App logo |
| `assets/icons/` | App icons directory |
| `assets/images/categories/` | Category images |
| `assets/images/adImages/` | Advertisement images |
| `assets/images/coupons/` | Coupon images |
| `assets/images/wishlist/` | Wishlist placeholder |
| `assets/images/cart/` | Cart empty-state image |

### Custom Fonts

| Family | Style |
|--------|-------|
| Roboto | Regular + Italic |
| NunitoSans | Regular + Italic |
| Raleway | Variable-weight + Italic |
| Poppins | Black + BlackItalic |

### Brand Colour Tokens (`AppTheme`)

| Token | Hex | Usage |
|-------|-----|-------|
| `brandPrimary` | `#7C3AED` | Primary purple — buttons, active states |
| `brandSecondary` | `#9747FF` | Secondary purple — accents |
| `brandPink` | `#E94A75` | Error / highlight accent |
| `surface` | `#FFFFFF` | Card & page backgrounds |
| `onSurface` | `#000000` | Primary text |

---

## Key Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_bloc` | ^9.1.1 | BLoC state management |
| `provider` | ^6.1.5 | ChangeNotifier state management |
| `go_router` | ^15.1.2 | Declarative routing |
| `get_it` | ^8.0.3 | Dependency injection |
| `hive` / `hive_flutter` | ^2.2.3 / ^1.1.0 | Local persistence |
| `http` | ^1.6.0 | REST API calls |
| `cached_network_image` | ^3.4.1 | Network image caching |
| `google_maps_flutter` | ^2.17.0 | Maps (address / delivery) |
| `carousel_slider` | ^5.0.0 | Homepage banners |
| `shimmer` | ^3.0.0 | Loading skeletons |
| `smooth_page_indicator` | ^1.2.1 | Carousel page dots |
| `scratcher` | ^2.5.0 | Scratch-card coupons |
| `image_picker` | ^1.2.1 | Profile photo upload |
| `sms_autofill` | ^2.4.1 | OTP auto-fill |
| `mailer` | ^6.4.1 | Email functionality |
| `shared_preferences` | ^2.5.3 | Lightweight key-value store |
| `equatable` | ^2.0.8 | Value equality in models |
| `rxdart` | ^0.28.0 | Reactive streams (search debounce) |
| `csc_picker_plus` | ^0.0.3 | Country / State / City picker |
| `url_launcher` | ^6.3.2 | External URL / link opening |
| `flutter_svg` | ^2.1.0 | SVG rendering |
| `intl` | ^0.20.2 | Date / number formatting |
| `gap` | ^3.0.1 | Spacing utility widget |
| `field_suggestion` | ^0.2.6 | Search field suggestions |

---

*Last updated: 2026-06-26 — auto-generated from project analysis.*
