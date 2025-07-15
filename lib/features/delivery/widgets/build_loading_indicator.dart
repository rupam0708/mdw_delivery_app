import 'package:flutter/material.dart';

import '../../../core/themes/styles.dart';

SliverToBoxAdapter buildLoadingIndicator() {
  return const SliverToBoxAdapter(
    child: Center(
      child: CircularProgressIndicator(color: AppColors.green),
    ),
  );
}
