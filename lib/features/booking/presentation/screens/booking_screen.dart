// lib/features/booking/presentation/screens/booking_screen.dart

import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../../../../core/di/service_locator.dart';
import '../../../places/presentation/cubit/places_cubit.dart';
import '../cubit/booking_cubit.dart';
import '../cubit/booking_state.dart';
import '../widgets/booking_header_widget.dart';
import '../widgets/booking_calendar_widget.dart';
import '../widgets/booking_footer_widget.dart';
import '../widgets/booking_success_sheet.dart';

class BookingScreen extends StatefulWidget {
  final int placeId;
  final String placeName;
  final String? placeImage;
  final num totalCost;
  final num pricePerPerson;
  final num estimatedTotalCost;

  // ── nullable: موجود لما بييجي من places، مش موجود من explore أو favourites ──
  final PlacesCubit? placesCubit;

  const BookingScreen({
    super.key,
    required this.placeId,
    required this.placeName,
    this.placeImage,
    this.totalCost = 0,
    this.pricePerPerson = 0,
    this.estimatedTotalCost = 0,
    this.placesCubit,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  DateTime _focusedMonth = DateTime.now();
  int _personCount = 1;

  void _onDateSelected(DateTime date) => setState(() => _selectedDate = date);

  void _onPreviousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1);
    });
  }

  void _onNextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1);
    });
  }

  void _incrementPerson() => setState(() => _personCount++);

  void _decrementPerson() {
    if (_personCount > 1) setState(() => _personCount--);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<BookingCubit>(),
      child: BlocConsumer<BookingCubit, BookingState>(
        listener: (context, state) {
          if (state is BookingSuccess) {
            BookingSuccessSheet.show(
              context,
              bookingResponse: state.bookingResponse,
            ).then((_) {
              if (context.mounted) {
                // ── لو جاي من places ──
                if (widget.placesCubit != null) {
                  // ── نعمل markAsBooked بالتكلفة الفعلية من الـ response ──
                  widget.placesCubit!.markAsBooked(
                    placeId: widget.placeId,
                    bookedCost: state.bookingResponse.data.totalPriceNumber,
                  );

                  // ── نرجع لـ PlacesListScreen مباشرة ──
                  Navigator.popUntil(
                    context,
                    (route) => route.settings.name == '/places',
                  );
                } else {
                  // ── لو جاي من explore أو favourites نرجع للخلف عادي ──
                  Navigator.pop(context);
                }
              }
            });
          }
          if (state is BookingFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is BookingLoading;

          return Directionality(
            textDirection: context.locale.languageCode == 'ar'
                ? ui.TextDirection.rtl
                : ui.TextDirection.ltr,
            child: Scaffold(
              backgroundColor: const Color(0xFFF5F5F5),
              appBar: AppBar(
                backgroundColor: AppColors.primary,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  AppTranslationKeys.bookingTitle.tr(),
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.white,
                    size: 20.sp,
                  ),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(20.r),
                  ),
                ),
              ),
              body: SingleChildScrollView(
                padding: EdgeInsets.all(16.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),

                    BookingHeaderWidget(
                      placeName: widget.placeName,
                      placeImage: widget.placeImage,
                    ),

                    SizedBox(height: 20.h),

                    BookingCalendarWidget(
                      focusedMonth: _focusedMonth,
                      selectedDate: _selectedDate,
                      onDateSelected: _onDateSelected,
                      onPreviousMonth: _onPreviousMonth,
                      onNextMonth: _onNextMonth,
                    ),

                    SizedBox(height: 20.h),

                    BookingFooterWidget(
                      personCount: _personCount,
                      onIncrement: _incrementPerson,
                      onDecrement: _decrementPerson,
                      isLoading: isLoading,
                      pricePerPerson: widget.pricePerPerson,
                      estimatedTotalCost: widget.estimatedTotalCost,
                      onConfirm: () {
                        context.read<BookingCubit>().createBooking(
                          placeId: widget.placeId,
                          selectedDate: _selectedDate,
                          personCount: _personCount,
                          pricePerPerson: widget.pricePerPerson,
                          estimatedTotalCost: widget.estimatedTotalCost,
                        );
                      },
                    ),

                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
