class BookingRequestModel {
  final int placeId;
  final String bookingDate;
  final int personCount;

  BookingRequestModel({
    required this.placeId,
    required this.bookingDate,
    required this.personCount,
  });

  Map<String, dynamic> toJson() {
    return {
      'place_id': placeId,
      'booking_date': bookingDate,
      'person_count': personCount,
    };
  }
}
