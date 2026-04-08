// lib/features/profile/data/models/trip_model.dart

class TripLocalizedModel {
  final String ar;
  final String en;

  TripLocalizedModel({required this.ar, required this.en});

  factory TripLocalizedModel.fromJson(Map<String, dynamic> json) {
    return TripLocalizedModel(
      ar: json['ar']?.toString() ?? '',
      en: json['en']?.toString() ?? '',
    );
  }

  String localized(String langCode) => langCode == 'ar' ? ar : en;
}

// ── Trip Place ──
class TripPlaceModel {
  final int id;
  final TripLocalizedModel name;
  final String imageUrl;
  final TripLocalizedModel location;

  TripPlaceModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.location,
  });

  factory TripPlaceModel.fromJson(Map<String, dynamic> json) {
    return TripPlaceModel(
      id: json['id'] ?? 0,
      name: TripLocalizedModel.fromJson(json['name'] ?? {}),
      imageUrl: json['image_url'] ?? '',
      location: TripLocalizedModel.fromJson(json['location'] ?? {}),
    );
  }
}

// ── Trip ──
class TripModel {
  final int id;
  final TripPlaceModel place;
  final String tripDate;
  final int personCount;
  final TripLocalizedModel price;
  final double priceNumber;
  final String status;
  final TripLocalizedModel statusLabel;
  final bool isRated;
  final double? rating;
  final String createdAt;

  TripModel({
    required this.id,
    required this.place,
    required this.tripDate,
    required this.personCount,
    required this.price,
    required this.priceNumber,
    required this.status,
    required this.statusLabel,
    required this.isRated,
    this.rating,
    required this.createdAt,
  });

  factory TripModel.fromJson(Map<String, dynamic> json) {
    return TripModel(
      id: json['id'] ?? 0,
      place: TripPlaceModel.fromJson(json['place'] ?? {}),
      tripDate: json['trip_date'] ?? '',
      personCount: json['person_count'] ?? 0,
      price: TripLocalizedModel.fromJson(json['price'] ?? {}),
      priceNumber: (json['price_number'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? '',
      statusLabel: TripLocalizedModel.fromJson(json['status_label'] ?? {}),
      isRated: json['is_rated'] ?? false,
      rating: json['rating'] != null
          ? (json['rating'] as num).toDouble()
          : null,
      createdAt: json['created_at'] ?? '',
    );
  }
}
