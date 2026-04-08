// lib/features/places/data/models/budget_response_model.dart

class BudgetResponseModel {
  final bool success;
  final BudgetInfoModel budgetInfo;
  final BudgetStatsModel stats;
  final List<PlaceItemResponseModel> selectedPlaces;
  final List<PlaceItemResponseModel> notSelectedPlaces;

  BudgetResponseModel({
    required this.success,
    required this.budgetInfo,
    required this.stats,
    required this.selectedPlaces,
    required this.notSelectedPlaces,
  });

  factory BudgetResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map<String, dynamic> ? json['data'] : json;

    return BudgetResponseModel(
      success: json['success'] ?? false,
      budgetInfo: BudgetInfoModel.fromJson(data['budget_info'] ?? {}),
      stats: BudgetStatsModel.fromJson(data['stats'] ?? {}),
      selectedPlaces:
          (data['selected_places'] as List?)
              ?.map(
                (e) =>
                    PlaceItemResponseModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      notSelectedPlaces:
          (data['not_selected_places'] as List?)
              ?.map(
                (e) =>
                    PlaceItemResponseModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }
}

// ── Budget Info ──
class BudgetInfoModel {
  final BudgetAmountModel enteredBudget;
  final int personCount;
  final BudgetAmountModel totalCost;
  final BudgetAmountModel remainingBudget;
  final BudgetSummaryModel summary;

  BudgetInfoModel({
    required this.enteredBudget,
    required this.personCount,
    required this.totalCost,
    required this.remainingBudget,
    required this.summary,
  });

  factory BudgetInfoModel.fromJson(Map<String, dynamic> json) {
    return BudgetInfoModel(
      enteredBudget: BudgetAmountModel.fromJson(json['entered_budget'] ?? {}),
      personCount: json['person_count'] ?? 0,
      totalCost: BudgetAmountModel.fromJson(json['total_cost'] ?? {}),
      remainingBudget: BudgetAmountModel.fromJson(
        json['remaining_budget'] ?? {},
      ),
      summary: BudgetSummaryModel.fromJson(json['summary'] ?? {}),
    );
  }
}

// ── Budget Amount ──
class BudgetAmountModel {
  final num number;
  final String ar;
  final String en;

  BudgetAmountModel({required this.number, required this.ar, required this.en});

  factory BudgetAmountModel.fromJson(Map<String, dynamic> json) {
    return BudgetAmountModel(
      number: json['number'] ?? 0,
      ar: json['ar'] ?? '',
      en: json['en'] ?? '',
    );
  }

  String localized(String langCode) => langCode == 'ar' ? ar : en;
}

// ── Budget Summary ──
class BudgetSummaryModel {
  final String ar;
  final String en;

  BudgetSummaryModel({required this.ar, required this.en});

  factory BudgetSummaryModel.fromJson(Map<String, dynamic> json) {
    return BudgetSummaryModel(ar: json['ar'] ?? '', en: json['en'] ?? '');
  }

  String localized(String langCode) => langCode == 'ar' ? ar : en;
}

// ── Budget Stats ──
class BudgetStatsModel {
  final int selectedCount;
  final int notSelectedCount;
  final int totalPlaces;

  BudgetStatsModel({
    required this.selectedCount,
    required this.notSelectedCount,
    required this.totalPlaces,
  });

  factory BudgetStatsModel.fromJson(Map<String, dynamic> json) {
    return BudgetStatsModel(
      selectedCount: json['selected_count'] ?? 0,
      notSelectedCount: json['not_selected_count'] ?? 0,
      totalPlaces: json['total_places'] ?? 0,
    );
  }
}

// ── Localized Text ──
class LocalizedTextModel {
  final String ar;
  final String en;

  LocalizedTextModel({required this.ar, required this.en});

  factory LocalizedTextModel.fromJson(dynamic json) {
    if (json is Map<String, dynamic>) {
      return LocalizedTextModel(
        ar: json['ar']?.toString() ?? '',
        en: json['en']?.toString() ?? '',
      );
    }
    return LocalizedTextModel(
      ar: json?.toString() ?? '',
      en: json?.toString() ?? '',
    );
  }

  String localized(String langCode) => langCode == 'ar' ? ar : en;
}

// ── Place Item ──
class PlaceItemResponseModel {
  final int id;
  final LocalizedTextModel name;
  final LocalizedTextModel? description;
  final String? imageUrl;
  final bool isFree;
  final LocalizedTextModel? priceLocalized;
  final num? priceNumber;
  final LocalizedTextModel? location;
  final LocalizedTextModel? workingHours;
  final List<LocalizedTextModel> activities;
  final double ratingAvg;
  final int totalBookings;
  final bool canAfford;
  final num pricePerPerson;
  final num totalCost;

  // ── جديد ──
  final bool isBooked;

  PlaceItemResponseModel({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.isFree,
    this.priceLocalized,
    this.priceNumber,
    this.location,
    this.workingHours,
    this.activities = const [],
    this.ratingAvg = 0,
    this.totalBookings = 0,
    this.canAfford = true,
    this.pricePerPerson = 0,
    this.totalCost = 0,
    this.isBooked = false,
  });

  factory PlaceItemResponseModel.fromJson(Map<String, dynamic> json) {
    // ── Parse Price ──
    LocalizedTextModel? priceLoc;
    num? priceNum;
    final rawPrice = json['price'];
    if (rawPrice is Map<String, dynamic>) {
      priceLoc = LocalizedTextModel.fromJson(rawPrice);
    } else if (rawPrice is num) {
      priceNum = rawPrice;
    }

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

    return PlaceItemResponseModel(
      id: json['id'] ?? 0,
      name: LocalizedTextModel.fromJson(json['name'] ?? {}),
      description: json['description'] != null
          ? LocalizedTextModel.fromJson(json['description'])
          : null,
      imageUrl: json['image_url'] ?? json['image'],
      isFree: json['is_free'] ?? false,
      priceLocalized: priceLoc,
      priceNumber: priceNum ?? json['price_number'],
      location: json['location'] != null
          ? LocalizedTextModel.fromJson(json['location'])
          : null,
      workingHours: json['working_hours'] != null
          ? LocalizedTextModel.fromJson(json['working_hours'])
          : null,
      activities: activitiesList,
      ratingAvg: (json['rating_avg'] as num?)?.toDouble() ?? 0.0,
      totalBookings: json['total_bookings'] ?? 0,
      canAfford: json['can_afford'] ?? true,
      pricePerPerson: json['price_per_person'] ?? 0,
      totalCost: json['total_cost'] ?? 0,

      // ── جديد ──
      isBooked: json['is_booked'] ?? false,
    );
  }

  String? getPrice(String langCode) {
    if (isFree) return null;
    if (priceLocalized != null) return priceLocalized!.localized(langCode);
    if (priceNumber != null) return priceNumber.toString();
    return null;
  }
}
