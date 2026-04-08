// lib/features/home/presentation/screens/home_screen.dart

import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/storage/token_manager.dart';
import '../../../places/presentation/cubit/places_cubit.dart';
import '../../../places/presentation/cubit/places_state.dart';
import '../../../places/presentation/screens/places_list_screen.dart';
import '../widgets/top_bar_widget.dart';
import '../widgets/image_carousel_widget.dart';
import '../widgets/badge_widget.dart';
import '../widgets/headline_widget.dart';
import '../widgets/budget_card_widget.dart';
import '../../data/models/place_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _budgetController = TextEditingController();
  final TextEditingController _personCountController = TextEditingController(
    text: '1',
  );

  final List<PlaceModel> _places = PlacesData.cairoPlaces;

  @override
  void dispose() {
    _budgetController.dispose();
    _personCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;
    final isAr = langCode == 'ar';

    return BlocProvider(
      create: (_) => sl<PlacesCubit>(),
      child: BlocConsumer<PlacesCubit, PlacesState>(
        listener: (context, state) {
          if (state is PlacesSuccess) {
            final placesCubit = context.read<PlacesCubit>();

            Navigator.push(
              context,
              // ── نضيف RouteSettings عشان الـ popUntil يلاقيها ──
              MaterialPageRoute(
                settings: const RouteSettings(name: '/places'),
                builder: (_) => BlocProvider.value(
                  value: placesCubit,
                  child: PlacesListScreen(budgetResponse: state.budgetResponse),
                ),
              ),
            );
          }
          if (state is PlacesFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is PlacesLoading;

          return Directionality(
            textDirection: isAr ? ui.TextDirection.rtl : ui.TextDirection.ltr,
            child: Scaffold(
              backgroundColor: AppColors.background,
              body: Stack(
                children: [
                  // ── Background ──
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.26,
                      child: Image.asset(
                        'assets/images/background_mosque.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  SafeArea(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Column(
                        children: [
                          // ── Top Bar ──
                          const TopBarWidget(),

                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ── Image Carousel ──
                                  ImageCarouselWidget(places: _places),

                                  SizedBox(height: 20.h),

                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // ── Badge ──
                                        const BadgeWidget(),

                                        SizedBox(height: 12.h),

                                        // ── Headline ──
                                        const HeadlineWidget(),

                                        SizedBox(height: 20.h),

                                        // ── Budget Card ──
                                        BudgetCardWidget(
                                          budgetController: _budgetController,
                                          personCountController:
                                              _personCountController,
                                          isLoading: isLoading,
                                          onDiscover: () =>
                                              _onDiscover(context),
                                        ),

                                        SizedBox(height: 24.h),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _onDiscover(BuildContext context) async {
    final token = await TokenManager.getToken();

    if (token == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              context.locale.languageCode == 'ar'
                  ? 'يجب تسجيل الدخول أولاً'
                  : 'You must login first',
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      return;
    }

    if (mounted) {
      context.read<PlacesCubit>().getBudgetPlaces(
        budget: _budgetController.text.trim(),
        personCount: _personCountController.text.trim(),
        token: token,
      );
    }
  }
}
