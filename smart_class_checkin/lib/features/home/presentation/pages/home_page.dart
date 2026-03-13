import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.appName)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Greeting card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('สวัสดี', style: textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text(
                      'พร้อมเริ่มเรียนแล้วหรือยัง?',
                      style: textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Check-in button
            ElevatedButton.icon(
              onPressed: () => context.push(AppRoutes.checkIn),
              icon: const Icon(Icons.login_rounded),
              label: const Text(AppStrings.checkInButton),
            ),
            const SizedBox(height: 16),

            // Finish class button
            OutlinedButton.icon(
              onPressed: () => context.push(AppRoutes.checkOut),
              icon: const Icon(
                Icons.logout_rounded,
                color: AppColors.primary,
              ),
              label: const Text(AppStrings.finishClassButton),
            ),
          ],
        ),
      ),
    );
  }
}
