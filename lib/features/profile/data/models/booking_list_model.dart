// lib/features/profile/data/models/booking_list_model.dart

class BookingListLocalizedModel {
  final String ar;
  final String en;

  BookingListLocalizedModel({required this.ar, required this.en});

  factory BookingListLocalizedModel.fromJson(Map<String, dynamic> json) {
    return BookingListLocalizedModel(
      ar: json['ar']?.toString() ?? '',
      en: json['en']?.toString() ?? '',
    );
  }

  String localized(String langCode) => langCode == 'ar' ? ar : en;
}

// ── Booking Place ──
class BookingListPlaceModel {
  final int id;
  final BookingListLocalizedModel name;
  final String imageUrl;
  final BookingListLocalizedModel location;

  BookingListPlaceModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.location,
  });

  factory BookingListPlaceModel.fromJson(Map<String, dynamic> json) {
    return BookingListPlaceModel(
      id: json['id'] ?? 0,
      name: BookingListLocalizedModel.fromJson(json['name'] ?? {}),
      imageUrl: json['image_url'] ?? '',
      location: BookingListLocalizedModel.fromJson(json['location'] ?? {}),
    );
  }
}

// ── Booking ──
class BookingListModel {
  final int id;
  final BookingListPlaceModel place;
  final String bookingDate;
  final int personCount;
  final BookingListLocalizedModel totalPrice;
  final double totalPriceNumber;
  final String status;
  final BookingListLocalizedModel statusLabel;
  final String createdAt;

  BookingListModel({
    required this.id,
    required this.place,
    required this.bookingDate,
    required this.personCount,
    required this.totalPrice,
    required this.totalPriceNumber,
    required this.status,
    required this.statusLabel,
    required this.createdAt,
  });

  factory BookingListModel.fromJson(Map<String, dynamic> json) {
    return BookingListModel(
      id: json['id'] ?? 0,
      place: BookingListPlaceModel.fromJson(json['place'] ?? {}),
      bookingDate: json['booking_date'] ?? '',
      personCount: json['person_count'] ?? 0,
      totalPrice: BookingListLocalizedModel.fromJson(json['total_price'] ?? {}),
      totalPriceNumber: (json['total_price_number'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? '',
      statusLabel: BookingListLocalizedModel.fromJson(
        json['status_label'] ?? {},
      ),
      createdAt: json['created_at'] ?? '',
    );
  }
}
