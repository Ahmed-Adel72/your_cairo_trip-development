// lib/features/home/presentation/widgets/headline_widget.dart

import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_translation_keys.dart';
import '../../../../core/constants/app_text_styles.dart';

class HeadlineWidget extends StatelessWidget {
  const HeadlineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final langCode = context.locale.languageCode;

    return RichText(
      // ── الاتجاه بيتغير حسب اللغة ──
      textDirection: langCode == 'ar'
          ? ui.TextDirection.rtl
          : ui.TextDirection.ltr,
      text: TextSpan(
        style: AppTextStyles.headlineBase,
        children: [
          TextSpan(text: AppTranslationKeys.homeHeadlineStart.tr()),
          TextSpan(
            text: AppTranslationKeys.homeHeadlineMiddle.tr(),
            style: AppTextStyles.headlineHighlight,
          ),
          TextSpan(text: AppTranslationKeys.homeHeadlineEnd.tr()),
        ],
      ),
    );
  }
}
