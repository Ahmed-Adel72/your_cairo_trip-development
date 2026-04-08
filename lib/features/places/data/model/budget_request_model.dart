// lib/features/places/data/models/budget_request_model.dart

class BudgetRequestModel {
  final double budget;
  final int personCount;

  BudgetRequestModel({required this.budget, required this.personCount});

  Map<String, dynamic> toJson() {
    return {'budget': budget, 'person_count': personCount};
  }
}
