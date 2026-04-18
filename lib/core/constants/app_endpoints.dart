class AppEndpoints {
  AppEndpoints._();

  static const String baseUrl =
      'https://cairo-trip-production.up.railway.app/api';

  // ── Auth ──
  static const String login = '/auth/login';
  static const String signUp = '/auth/register';
  static const String profile = '/auth/profile';
  static const String logout = '/auth/logout';

  // ── Places ──
  static const String budget = '/budget/calculate';

  // ── Booking ──
  static const String createBooking = '/bookings';
  static const String getBookings = '/bookings';
  static String cancelBooking(int bookingId) => '/bookings/$bookingId/cancel';

  // ── Explore ──
  static const String explore = '/explore';
  static const String exploreSearch = '/explore/search';
  static const String exploreFilter = '/explore/filter';

  // ── Favourites ──
  static const String getFavourites = '/favourites';
  static String favouriteToggle(int placeId) => '/favourites/$placeId/toggle';

  // ── Trips ──
  static const String getTrips = '/trips';
  static const String getCompletedTrips = '/trips/completed';
  static const String getUpcomingTrips = '/trips/upcoming';

  // ── Ratings ──
  static const String rateTrip = '/ratings';

  // ── Support ──
  static const String support = '/support';
}
