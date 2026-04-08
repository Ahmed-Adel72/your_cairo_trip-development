// lib/core/constants/app_translation_keys.dart

class AppTranslationKeys {
  AppTranslationKeys._();

  // ── Common ──
  static const String loading = 'common.loading';
  static const String error = 'common.error';
  static const String noInternet = 'common.no_internet';

  // ── Auth Login ──
  static const String loginTitle = 'auth.login.title';
  static const String loginEmail = 'auth.login.email';
  static const String loginPassword = 'auth.login.password';
  static const String loginBtn = 'auth.login.login_btn';
  static const String loginNoAccount = 'auth.login.no_account';
  static const String loginCreateAccount = 'auth.login.create_account';
  static const String loginEmailRequired = 'auth.login.email_required';
  static const String loginPasswordRequired = 'auth.login.password_required';
  static const String loginUnexpectedError = 'auth.login.unexpected_error';

  // ── Auth SignUp ──
  static const String signUpTitle = 'auth.signup.title';
  static const String signUpName = 'auth.signup.name';
  static const String signUpEmail = 'auth.signup.email';
  static const String signUpPhone = 'auth.signup.phone';
  static const String signUpPassword = 'auth.signup.password';
  static const String signUpConfirmPassword = 'auth.signup.confirm_password';
  static const String signUpBtn = 'auth.signup.signup_btn';
  static const String signUpHaveAccount = 'auth.signup.have_account';
  static const String signUpLogin = 'auth.signup.login';
  static const String signUpNameRequired = 'auth.signup.name_required';
  static const String signUpEmailRequired = 'auth.signup.email_required';
  static const String signUpPhoneRequired = 'auth.signup.phone_required';
  static const String signUpPasswordRequired = 'auth.signup.password_required';
  static const String signUpConfirmPasswordRequired =
      'auth.signup.confirm_password_required';
  static const String signUpPasswordMismatch = 'auth.signup.password_mismatch';
  static const String signUpUnexpectedError = 'auth.signup.unexpected_error';

  // ── Home ──
  static const String homeAppTitle = 'home.app_title';
  static const String homeBadgeText = 'home.badge_text';
  static const String homeHeadlineStart = 'home.headline_start';
  static const String homeHeadlineMiddle = 'home.headline_middle';
  static const String homeHeadlineEnd = 'home.headline_end';
  static const String homeBudgetLabel = 'home.budget_label';
  static const String homePersonCountLabel = 'home.person_count_label';
  static const String homeBudgetHint = 'home.budget_hint';
  static const String homeCurrency = 'home.currency';
  static const String homeDiscoverBtn = 'home.discover_btn';
  static const String homeBudgetRequired = 'home.budget_required';
  static const String homeBudgetInvalid = 'home.budget_invalid';
  static const String homePersonCountInvalid = 'home.person_count_invalid';
  static const String homeUnexpectedError = 'home.unexpected_error';

  // ── Places ──
  static const String placesTitle = 'places.title';
  static const String placesFree = 'places.free';
  static const String placesPaid = 'places.paid';
  static const String placesDetails = 'places.details';
  static const String placesImageNotFound = 'places.image_not_found';
  static const String placesBookTrip = 'places.book_trip';
  static const String placesBudgetLabel = 'places.budget_label';
  static const String placesCostLabel = 'places.cost_label';
  static const String placesRemainingLabel = 'places.remaining_label';
  static const String placesCurrency = 'places.currency';
  static const String placesCount = 'places.places_count';
  static const String placesNoPlaces = 'places.no_places';
  static const String placesSummaryLabel = 'places.summary_label';

  // ── Place Details ──
  static const String placeDetailsTicketPrice = 'place_details.ticket_price';
  static const String placeDetailsWorkingHours = 'place_details.working_hours';
  static const String placeDetailsActivities = 'place_details.activities';
  static const String placeDetailsLocation = 'place_details.location';
  static const String placeDetailsNoWorkingHours =
      'place_details.no_working_hours';
  static const String placeDetailsNoActivities = 'place_details.no_activities';
  static const String placeDetailsNoLocation = 'place_details.no_location';
  static const String placeDetailsFreeEntry = 'place_details.free_entry';

  // ── Booking ──
  static const String bookingTitle = 'booking.title';
  static const String bookingConfirm = 'booking.confirm';
  static const String bookingSelectDate = 'booking.select_date';
  static const String bookingPersonCount = 'booking.person_count';
  static const String bookingSuccess = 'booking.success';
  static const String bookingStatusPending = 'booking.status_pending';
  static const String bookingTotalPrice = 'booking.total_price';
  static const String bookingDate = 'booking.booking_date';
  static const String bookingPlaceName = 'booking.place_name';
  static const String bookingDateRequired = 'booking.date_required';
  static const String bookingDatePast = 'booking.date_past';
  static const String bookingUnexpectedError = 'booking.unexpected_error';
  static const String bookingStatus = 'booking.status';

  // ── Explore ──
  static const String exploreTitle = 'explore.title';
  static const String exploreSearchHint = 'explore.search_hint';
  static const String exploreAll = 'explore.all';
  static const String exploreFree = 'explore.free';
  static const String explorePaid = 'explore.paid';
  static const String exploreNoResults = 'explore.no_results';
  static const String exploreBooked = 'explore.booked';
  static const String exploreBook = 'explore.book';
  static const String exploreFavouriteAdded = 'explore.favourite_added';
  static const String exploreFavouriteRemoved = 'explore.favourite_removed';
  static const String exploreUnexpectedError = 'explore.unexpected_error';
  static const String exploreBookingsCount = 'explore.bookings_count';

  // ── Profile ──
  static const String profileTitle = 'profile.title';
  static const String profileName = 'profile.name';
  static const String profileEmail = 'profile.email';
  static const String profilePhone = 'profile.phone';
  static const String profileEdit = 'profile.edit';
  static const String profileLogout = 'profile.logout';
  static const String profileTrips = 'profile.trips';
  static const String profileFavourites = 'profile.favourites';
  static const String profileLanguage = 'profile.language';
  static const String profileSave = 'profile.save';
  static const String profileUpdateSuccess = 'profile.update_success';
  static const String profileLogoutSuccess = 'profile.logout_success';
  static const String profileLogoutConfirm = 'profile.logout_confirm';

  // ── My Trips ──
  static const String myTripsTitle = 'my_trips.title';
  static const String myTripsCompleted = 'my_trips.completed';
  static const String myTripsUpcoming = 'my_trips.upcoming';
  static const String myTripsNoCompleted = 'my_trips.no_completed';
  static const String myTripsNoUpcoming = 'my_trips.no_upcoming';
  static const String myTripsRate = 'my_trips.rate';
  static const String myTripsRateEdit = 'my_trips.rate_edit';
  static const String myTripsRateTitle = 'my_trips.rate_title';
  static const String myTripsRateSave = 'my_trips.rate_save';
  static const String myTripsRateSuccess = 'my_trips.rate_success';
  static const String myTripsPeople = 'my_trips.people';
  static const String myTripsUnexpectedError = 'my_trips.unexpected_error';

  // ── Favourites ──
  static const String favouritesTitle = 'favourites.title';
  static const String favouritesEmpty = 'favourites.empty';
  static const String favouritesEmptySubtitle = 'favourites.empty_subtitle';
  static const String favouritesRemoved = 'favourites.removed';
  static const String favouritesDetails = 'favourites.details';
  static const String favouritesBook = 'favourites.book';
  static const String favouritesUnexpectedError = 'favourites.unexpected_error';

  // ── My Bookings ──
  static const String myBookingsTitle = 'my_bookings.title';
  static const String myBookingsCancel = 'my_bookings.cancel';
  static const String myBookingsCancelConfirm = 'my_bookings.cancel_confirm';
  static const String myBookingsCancelSuccess = 'my_bookings.cancel_success';
  static const String myBookingsNoBookings = 'my_bookings.no_bookings';
  static const String myBookingsUnexpectedError =
      'my_bookings.unexpected_error';

  // ── Support ──
  static const String supportTitle = 'support.title';
  static const String supportName = 'support.name';
  static const String supportEmail = 'support.email';
  static const String supportPhone = 'support.phone';
  static const String supportProblem = 'support.problem';
  static const String supportSend = 'support.send';
  static const String supportSuccess = 'support.success';
  static const String supportNameRequired = 'support.name_required';
  static const String supportEmailRequired = 'support.email_required';
  static const String supportPhoneRequired = 'support.phone_required';
  static const String supportProblemRequired = 'support.problem_required';
  static const String supportUnexpectedError = 'support.unexpected_error';

  // ── Settings ──
  static const String settingsTitle = 'settings.title';
  static const String settingsAbout = 'settings.about';
  static const String settingsAboutSubtitle = 'settings.about_subtitle';
  static const String settingsPrivacy = 'settings.privacy';
  static const String settingsPrivacySubtitle = 'settings.privacy_subtitle';
  static const String settingsWebsite = 'settings.website';
  static const String settingsWebsiteSubtitle = 'settings.website_subtitle';
  static const String settingsWebsiteSoon = 'settings.website_soon';
  static const String settingsSupport = 'settings.support';
  static const String settingsSupportSubtitle = 'settings.support_subtitle';
  static const String settingsLanguage = 'settings.language';
  static const String settingsLanguageSubtitle = 'settings.language_subtitle';
  static const String settingsLanguageAr = 'settings.language_ar';
  static const String settingsLanguageEn = 'settings.language_en';
  static const String settingsLanguageChanged = 'settings.language_changed';

  // ── Support ──
  static const String supportHeaderTitle = 'support.header_title';
  static const String supportHeaderSubtitle = 'support.header_subtitle';
  static const String supportNameHint = 'support.name_hint';
  static const String supportPhoneHint = 'support.phone_hint';
  static const String supportEmailHint = 'support.email_hint';
  static const String supportProblemHint = 'support.problem_hint';
  static const String supportSending = 'support.sending';
  static const String supportSuccessTitle = 'support.success_title';
  static const String supportSuccessSubtitle = 'support.success_subtitle';
  static const String supportSuccessBtn = 'support.success_btn';
  static const String supportNameInvalid = 'support.name_invalid';
  static const String supportPhoneInvalid = 'support.phone_invalid';
  static const String supportEmailInvalid = 'support.email_invalid';
  static const String supportProblemInvalid = 'support.problem_invalid';

  static const String bookingBudgetExceeded = 'booking.budget_exceeded';
  static const String bookingLoginRequired = 'booking.login_required';
}
