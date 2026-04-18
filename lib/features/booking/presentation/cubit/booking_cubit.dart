import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:your_cairo_trip/core/error/failures.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../../../../core/storage/token_manager.dart';
import '../../data/models/booking_request_model.dart';
import '../../data/repositories/booking_repository.dart';
import 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingRepository _bookingRepository;

  BookingCubit(this._bookingRepository) : super(BookingInitial());

  Future<void> createBooking({
    required int placeId,
    required DateTime selectedDate,
    required int personCount,
    required num pricePerPerson,
    // ── التكلفة التقريبية لكل الأماكن ──
    required num estimatedTotalCost,
  }) async {
    // ── Validation: التاريخ ──
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
    );

    if (selected.isBefore(today)) {
      emit(BookingFailure(AppTranslationKeys.bookingDatePast.tr()));
      return;
    }

    // ── Validation: التكلفة المتوقعة مقارنة بالتكلفة التقريبية ──
    if (pricePerPerson > 0) {
      final expectedTotal = pricePerPerson * personCount;
      if (expectedTotal > estimatedTotalCost) {
        emit(
          BookingFailure(
            AppTranslationKeys.bookingBudgetExceeded.tr(
              namedArgs: {
                'total': expectedTotal.toString(),
                'budget': estimatedTotalCost.toString(),
              },
            ),
          ),
        );
        return;
      }
    }

    emit(BookingLoading());

    try {
      final token = await TokenManager.getToken();
      if (token == null) {
        emit(BookingFailure(AppTranslationKeys.bookingLoginRequired.tr()));
        return;
      }

      // ── Format Date ──
      final formattedDate =
          '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';

      final request = BookingRequestModel(
        placeId: placeId,
        bookingDate: formattedDate,
        personCount: personCount,
      );

      final response = await _bookingRepository.createBooking(
        request: request,
        token: token,
      );

      emit(BookingSuccess(response));
    } on ServerFailure catch (e) {
      emit(BookingFailure(e.message));
    } on NetworkFailure catch (_) {
      emit(BookingFailure(AppTranslationKeys.noInternet.tr()));
    } catch (e) {
      emit(BookingFailure(AppTranslationKeys.bookingUnexpectedError.tr()));
    }
  }
}
