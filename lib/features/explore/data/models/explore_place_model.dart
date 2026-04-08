// lib/features/explore/data/models/explore_place_model.dart

import 'package:your_cairo_trip/features/places/data/model/budget_response_model.dart';

class ExplorePlaceModel {
  final int id;
  final LocalizedTextModel name;
  final LocalizedTextModel? description;
  final String? imageUrl;
  final bool isFree;
  final LocalizedTextModel? price;
  final num priceNumber;
  final LocalizedTextModel? workingHours;
  final LocalizedTextModel? location;
  final double ratingAvg;
  final int totalBookings;
  final List<LocalizedTextModel> activities;
  bool isFavourite;
  final bool isBooked;

  ExplorePlaceModel({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.isFree,
    this.price,
    required this.priceNumber,
    this.workingHours,
    this.location,
    required this.ratingAvg,
    required this.totalBookings,
    required this.activities,
    required this.isFavourite,
    required this.isBooked,
  });

  factory ExplorePlaceModel.fromJson(Map<String, dynamic> json) {
    // ── Parse Activities ──
    final List<LocalizedTextModel> activitiesList = [];
    final activitiesJson = json['activities'];

    if (activitiesJson is Map<String, dynamic>) {
      final List<dynamic>? arList = activitiesJson['ar'];
      final List<dynamic>? enList = activitiesJson['en'];

      if (arList != null && enList != null) {
        for (int i = 0; i < arList.length; i++) {
          activitiesList.add(
            LocalizedTextModel(
              ar: arList[i].toString(),
              en: enList.length > i
                  ? enList[i].toString()
                  : enList.last.toString(),
            ),
          );
        }
      }
    } else if (activitiesJson is List) {
      for (final item in activitiesJson) {
        activitiesList.add(LocalizedTextModel.fromJson(item));
      }
    }

    return ExplorePlaceModel(
      id: json['id'] ?? 0,
      name: LocalizedTextModel.fromJson(json['name'] ?? {}),
      description: json['description'] != null
          ? LocalizedTextModel.fromJson(json['description'])
          : null,
      imageUrl: json['image_url'] ?? json['image'],
      isFree: json['is_free'] ?? false,
      price: json['price'] != null
          ? LocalizedTextModel.fromJson(json['price'])
          : null,
      priceNumber: json['price_number'] ?? 0,
      workingHours: json['working_hours'] != null
          ? LocalizedTextModel.fromJson(json['working_hours'])
          : null,
      location: json['location'] != null
          ? LocalizedTextModel.fromJson(json['location'])
          : null,
      ratingAvg: (json['rating_avg'] as num?)?.toDouble() ?? 0.0,
      totalBookings: json['total_bookings'] ?? 0,
      activities: activitiesList,
      isFavourite: json['is_favourite'] ?? false,
      isBooked: json['is_booked'] ?? false,
    );
  }

  // ── helper للسعر ──
  String? getPrice(String langCode) {
    if (isFree) return null;
    if (price != null) return price!.localized(langCode);
    if (priceNumber > 0) return priceNumber.toString();
    return null;
  }
}
