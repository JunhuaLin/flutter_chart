import 'package:example/pages/home_page.dart';
import 'package:example/resources/app_colors.dart';
import 'package:example/util/app_helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// FileName app_router
///
/// @Author junhua
/// @Date 2024/3/18
/// app路由
final appRouterConfig = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => Container(
        color: AppColors.pageBackground,
      ),
      redirect: (context, state) {
        return '/${ChartType.values.first.name}';
      },
    ),
    ...ChartType.values
        .map(
          (ChartType chartType) => GoRoute(
            path: '/${chartType.name}',
            pageBuilder: (BuildContext context, GoRouterState state) => MaterialPage(
              key: const ValueKey('home_page'),
              child: HomePage(showingChartType: chartType),
            ),
          ),
        )
        .toList(),
    GoRoute(
      path: '/:any',
      builder: (context, state) => Container(color: AppColors.pageBackground),
      redirect: (context, state) {
        // Unsupported path, we redirect it to /, which redirects it to /line
        return '/';
      },
    )
  ],
);
