class BookingResponseModel {
  final bool success;
  final BookingMessageModel message;
  final BookingDataModel data;

  BookingResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BookingResponseModel.fromJson(Map<String, dynamic> json) {
    return BookingResponseModel(
      success: json['success'] ?? false,
      message: BookingMessageModel.fromJson(json['message'] ?? {}),
      data: BookingDataModel.fromJson(json['data'] ?? {}),
    );
  }
}

// ── Message ──
class BookingMessageModel {
  final String ar;
  final String en;

  BookingMessageModel({required this.ar, required this.en});

  factory BookingMessageModel.fromJson(Map<String, dynamic> json) {
    return BookingMessageModel(ar: json['ar'] ?? '', en: json['en'] ?? '');
  }

  String localized(String langCode) => langCode == 'ar' ? ar : en;
}

// ── Booking Data ──
class BookingDataModel {
  final int id;
  final BookingPlaceModel place;
  final String bookingDate;
  final int personCount;
  final BookingLocalizedModel totalPrice;
  final num totalPriceNumber;
  final String status;
  final BookingLocalizedModel statusLabel;
  final String createdAt;

  BookingDataModel({
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

  factory BookingDataModel.fromJson(Map<String, dynamic> json) {
    return BookingDataModel(
      id: json['id'] ?? 0,
      place: BookingPlaceModel.fromJson(json['place'] ?? {}),
      bookingDate: json['booking_date'] ?? '',
      personCount: json['person_count'] ?? 0,
      totalPrice: BookingLocalizedModel.fromJson(json['total_price'] ?? {}),
      totalPriceNumber: json['total_price_number'] ?? 0,
      status: json['status'] ?? '',
      statusLabel: BookingLocalizedModel.fromJson(json['status_label'] ?? {}),
      createdAt: json['created_at'] ?? '',
    );
  }
}

// ── Place في الـ Booking ──
class BookingPlaceModel {
  final int id;
  final BookingLocalizedModel name;
  final String? imageUrl;
  final BookingLocalizedModel? location;

  BookingPlaceModel({
    required this.id,
    required this.name,
    this.imageUrl,
    this.location,
  });

  factory BookingPlaceModel.fromJson(Map<String, dynamic> json) {
    return BookingPlaceModel(
      id: json['id'] ?? 0,
      name: BookingLocalizedModel.fromJson(
        json['name'] is Map ? json['name'] : {'ar': '', 'en': ''},
      ),
      imageUrl: json['image_url'],
      location: json['location'] != null
          ? BookingLocalizedModel.fromJson(
              json['location'] is Map
                  ? json['location']
                  : {'ar': json['location'], 'en': json['location']},
            )
          : null,
    );
  }
}

// ── Localized Model ──
class BookingLocalizedModel {
  final String ar;
  final String en;

  BookingLocalizedModel({required this.ar, required this.en});

  factory BookingLocalizedModel.fromJson(Map<String, dynamic> json) {
    return BookingLocalizedModel(
      ar: json['ar']?.toString() ?? '',
      en: json['en']?.toString() ?? '',
    );
  }

  String localized(String langCode) => langCode == 'ar' ? ar : en;
}
