// lib/features/explore/presentation/screens/explore_screen.dart

import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../../../../core/di/service_locator.dart';
import '../cubit/explore_cubit.dart';
import '../cubit/explore_state.dart';
import '../widgets/explore_search_bar_widget.dart';
import '../widgets/explore_filter_widget.dart';
import '../widgets/explore_place_card_widget.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExploreCubit>()..getPlaces(),
      child: const _ExploreView(),
    );
  }
}

class _ExploreView extends StatefulWidget {
  const _ExploreView();

  @override
  State<_ExploreView> createState() => _ExploreViewState();
}

class _ExploreViewState extends State<_ExploreView> {
  // ── debounce timer للسيرش ──
  String _activeFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;
    final isAr = langCode == 'ar';

    return Directionality(
      textDirection: isAr ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F8F8),
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Text(
            AppTranslationKeys.exploreTitle.tr(),
            style: TextStyle(
              color: AppColors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
          ),
        ),
        body: Column(
          children: [
            // ── Search + Filter ──
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 12.h),
              child: Column(
                children: [
                  // ── Search Bar ──
                  ExploreSearchBarWidget(
                    onSearch: (query) {
                      context.read<ExploreCubit>().searchPlaces(query);
                    },
                    onClear: () {
                      context.read<ExploreCubit>().getPlaces();
                    },
                  ),

                  SizedBox(height: 12.h),

                  // ── Filter Chips ──
                  BlocBuilder<ExploreCubit, ExploreState>(
                    buildWhen: (prev, curr) =>
                        curr is ExploreSuccess || curr is ExploreLoading,
                    builder: (context, state) {
                      final activeFilter = state is ExploreSuccess
                          ? state.activeFilter
                          : _activeFilter;

                      return Align(
                        alignment: isAr
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: ExploreFilterWidget(
                          activeFilter: activeFilter,
                          onFilterChanged: (filter) {
                            _activeFilter = filter;
                            context.read<ExploreCubit>().filterPlaces(filter);
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // ── Places List ──
            Expanded(
              child: BlocConsumer<ExploreCubit, ExploreState>(
                listener: (context, state) {
                  if (state is ExploreFavouriteUpdated) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          state.isFavourite
                              ? AppTranslationKeys.exploreFavouriteAdded.tr()
                              : AppTranslationKeys.exploreFavouriteRemoved.tr(),
                        ),
                        backgroundColor: state.isFavourite
                            ? Colors.green.shade600
                            : Colors.red.shade400,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                  if (state is ExploreFailure) {
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
                  // ── Loading ──
                  if (state is ExploreLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }

                  // ── Success ──
                  if (state is ExploreSuccess) {
                    if (state.places.isEmpty) {
                      return _EmptyState();
                    }

                    return RefreshIndicator(
                      onRefresh: () => context.read<ExploreCubit>().getPlaces(),
                      color: AppColors.primary,
                      child: ListView.builder(
                        padding: EdgeInsets.all(16.r),
                        itemCount: state.places.length,
                        itemBuilder: (context, index) {
                          return ExplorePlaceCardWidget(
                            place: state.places[index],
                          );
                        },
                      ),
                    );
                  }

                  // ── Favourite Updated ──
                  if (state is ExploreFavouriteUpdated) {
                    return const SizedBox.shrink();
                  }

                  // ── Initial/Error ──
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64.sp,
            color: AppColors.textLight,
          ),
          SizedBox(height: 16.h),
          Text(
            AppTranslationKeys.exploreNoResults.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
