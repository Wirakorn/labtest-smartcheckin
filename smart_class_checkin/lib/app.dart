import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/constants/app_routes.dart';
import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/check_in/presentation/pages/check_in_page.dart';
import 'features/check_out/presentation/pages/check_out_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.checkIn,
      builder: (context, state) => const CheckInPage(),
    ),
    GoRoute(
      path: AppRoutes.checkOut,
      builder: (context, state) => const CheckOutPage(),
    ),
  ],
);
