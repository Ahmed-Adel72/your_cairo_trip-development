// lib/features/booking/presentation/widgets/booking_calendar_widget.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';

class BookingCalendarWidget extends StatelessWidget {
  final DateTime focusedMonth;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;

  const BookingCalendarWidget({
    super.key,
    required this.focusedMonth,
    required this.selectedDate,
    required this.onDateSelected,
    required this.onPreviousMonth,
    required this.onNextMonth,
  });

  // ── أسماء الشهور بالعربي والإنجليزي ──
  static const List<String> _monthsEn = [
    'JANUARY',
    'FEBRUARY',
    'MARCH',
    'APRIL',
    'MAY',
    'JUNE',
    'JULY',
    'AUGUST',
    'SEPTEMBER',
    'OCTOBER',
    'NOVEMBER',
    'DECEMBER',
  ];

  static const List<String> _monthsAr = [
    'يناير',
    'فبراير',
    'مارس',
    'أبريل',
    'مايو',
    'يونيو',
    'يوليو',
    'أغسطس',
    'سبتمبر',
    'أكتوبر',
    'نوفمبر',
    'ديسمبر',
  ];

  // ── أيام الأسبوع بالعربي والإنجليزي ──
  static const List<String> _daysEn = [
    'Su',
    'Mo',
    'Tu',
    'We',
    'Th',
    'Fr',
    'Sa',
  ];

  static const List<String> _daysAr = ['أح', 'إث', 'ث', 'أر', 'خ', 'ج', 'س'];

  List<DateTime?> _getDaysInMonth() {
    final firstDay = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final lastDay = DateTime(focusedMonth.year, focusedMonth.month + 1, 0);
    final startWeekday = firstDay.weekday % 7;

    final List<DateTime?> days = [];
    for (int i = 0; i < startWeekday; i++) {
      days.add(null);
    }
    for (int i = 1; i <= lastDay.day; i++) {
      days.add(DateTime(focusedMonth.year, focusedMonth.month, i));
    }
    return days;
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isPastDay(DateTime day) {
    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);
    final dayOnly = DateTime(day.year, day.month, day.day);
    return dayOnly.isBefore(todayOnly);
  }

  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;
    final isAr = langCode == 'ar';
    final days = _getDaysInMonth();
    final months = isAr ? _monthsAr : _monthsEn;
    final dayHeaders = isAr ? _daysAr : _daysEn;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          // ── Month Navigation ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onPreviousMonth,
                icon: Icon(
                  // ── الأيقونة بتتغير حسب اتجاه اللغة ──
                  isAr
                      ? Icons.chevron_right_rounded
                      : Icons.chevron_left_rounded,
                  color: AppColors.textDark,
                  size: 28.sp,
                ),
              ),

              // ── Month + Year ──
              Text(
                '${months[focusedMonth.month - 1]} ${focusedMonth.year}',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: isAr ? 0 : 1,
                ),
              ),

              IconButton(
                onPressed: onNextMonth,
                icon: Icon(
                  isAr
                      ? Icons.chevron_left_rounded
                      : Icons.chevron_right_rounded,
                  color: AppColors.textDark,
                  size: 28.sp,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // ── Day Headers ──
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: dayHeaders.map((day) {
              return SizedBox(
                width: 36.w,
                child: Text(
                  day,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 8.h),

          // ── Calendar Grid ──
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1,
            ),
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              if (day == null) return const SizedBox();

              final isSelected = _isSameDay(day, selectedDate);
              final isToday = _isSameDay(day, DateTime.now());
              final isPast = _isPastDay(day);

              return GestureDetector(
                // ── مش هيختار تاريخ ماضي ──
                onTap: isPast ? null : () => onDateSelected(day),
                child: Container(
                  margin: EdgeInsets.all(3.r),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : isToday
                        ? AppColors.primary.withOpacity(0.15)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: TextStyle(
                        // ── الأيام الماضية بتبقى رمادية ──
                        color: isPast
                            ? Colors.grey.withOpacity(0.4)
                            : isSelected
                            ? AppColors.white
                            : AppColors.textDark,
                        fontSize: 13.sp,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
