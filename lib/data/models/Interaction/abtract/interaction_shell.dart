/// Abstract base class that every interaction entry must implement.
///`
/// All concrete interaction types ([InteractionPageModel],
/// [InteractionProductModel]) extend this class so that they can be stored
/// together in a single `List<InteractionsShell>`.`
abstract class InteractionsShell {
  /// The category / screen this interaction was triggered from.
  InteractionType get interactionType;

  /// ISO-8601 timestamp of when this interaction was recorded.
  String get lastViewedAt;

  /// Serialises this interaction to a JSON-compatible map.
  Map<String, dynamic> toJson();
}

///InteractionType — shared enum used by all interaction kinds
enum InteractionType {
  //Product Showing Screens
  productView,
  productGridView,

  //Main Pages
  homeScreen,
  categoryPage,
  cartPage, // Cart Page
  wishlistPage, // Wishlist Page
  //Order Pages
  orderPage,
  orderTrackingPage,
  orderSummaryPage,
  orderPaymentPage,
  orderConfirmedPage,

  //HomeScreen Elements
  tabPageView,
  banner,
  imageGallery,
  mobile3dIconGallery,
  mobileBudgetDeals,
  mobileCategoryStrip,
  mobileCharmSlider,
  mobileGridOffer,
  mobileOfferStrip,
  mobileSponsoredBanner,
  mobileSuggestionGrid,
  mobilePromoBanner,
  adBanner,
  categoryView,
  adProductList,

  //Category Page Elements
  categoryParentItem,
  categoryChildItem,

  //Profile Page and features
  couponsPage,
  helpAndSupportPage,
  latestUpdatesAndOffersPage,
  editProfilePage,
  savedCardsAndGiftPage,
  selectLanguagePage,
  notificationPage,
  privacyCenterPage,
  reviewsPage,
  qaPage,
  sellOnExotic,
  termsAndConditionsAndLicencesPage,
  browseFAQPage,
  logOut,

  //Search Page
  searchPage,
}
