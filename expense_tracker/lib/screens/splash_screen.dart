import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../utils/page_routes.dart';
import 'main_shell.dart';

/// First screen of the app: a short branded pause, then the tab shell.
/// Uses `pushReplacement` so the user cannot navigate back to it.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start the timer after the first frame is on screen. If it starts in
    // initState, the clock is already running during engine startup, so on a
    // slow launch the splash can be replaced before the user ever sees it.
    WidgetsBinding.instance.addPostFrameCallback((_) => _continueToApp());
  }

  Future<void> _continueToApp() async {
    await Future<void>.delayed(const Duration(milliseconds: 1600));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(fadeRoute(const MainShell()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.sage,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xxl),
          child: Column(
            children: [
              const Spacer(),
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 700),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, (1 - value) * 16),
                      child: child,
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: AppColors.purple,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: AppSpacing.cardShadow,
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 40,
                        color: AppColors.charcoal,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Text(
                      'Expense\nTracker',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.display,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'Small records, clearer money.',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text('Mobile Development · Final Project',
                  style: AppTextStyles.captionSmall),
              const SizedBox(height: AppSpacing.xs),
            ],
          ),
        ),
      ),
    );
  }
}
