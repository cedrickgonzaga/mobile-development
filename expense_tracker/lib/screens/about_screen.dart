import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';
import '../widgets/app_card.dart';

/// About tab: app information, quick guide, privacy note and the team.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  static const _version = '1.0.0';

  static const _team = <(String, String)>[
    ('Gonzaga, Cedrick', 'Project Leader'),
    ('Dungo, Mitch', 'Frontend Developer'),
    ('De Chavez, Gerard Cyr', 'UI/UX Designer'),
    ('Ramirez, Jay Darrius', 'Navigation Developer'),
    ('Bernales, Remier Marc', 'Backend/Data Developer'),
    ('Melia, Juleto Jaycee', 'Functionality & Testing · Documentation & QA'),
  ];

  static const _steps = <String>[
    'Tap "Add expense" and fill in the title, amount, category and date.',
    'Check Home for this month\'s total, budget progress and category totals.',
    'Open any expense to view its details, edit it, or delete it.',
    'Tap the budget card to change your monthly limit.',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          children: [
            Text('THE PROJECT', style: AppTextStyles.eyebrow),
            const SizedBox(height: 6),
            Text('About', style: AppTextStyles.h1),
            const SizedBox(height: 6),
            Text(
              'A local-first expense tracker for everyday spending.',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: AppSpacing.xl),

            AppCard(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.purple,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.account_balance_wallet_rounded,
                      size: 30,
                      color: AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text('Spendly', style: AppTextStyles.h2),
                  const SizedBox(height: 4),
                  Text('Version $_version', style: AppTextStyles.caption),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.sage,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      'Flutter · Dart · SQLite',
                      style: AppTextStyles.captionSmall.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('HOW TO USE', style: AppTextStyles.eyebrow),
                  const SizedBox(height: AppSpacing.md),
                  for (var i = 0; i < _steps.length; i++) ...[
                    if (i > 0) const SizedBox(height: AppSpacing.md),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: AppColors.purple16,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${i + 1}',
                            style: AppTextStyles.captionSmall.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.charcoal,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Text(_steps[i], style: AppTextStyles.body),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            AppCard(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: AppColors.teal16,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.lock_outline_rounded,
                      size: 18,
                      color: AppColors.charcoal,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your data stays on your device',
                            style: AppTextStyles.h3),
                        const SizedBox(height: 4),
                        Text(
                          'Expenses are saved in a local SQLite database and '
                          'the budget in device preferences. Nothing is sent '
                          'online and the app works without internet.',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            AppCard(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 4),
                    child: Text('THE TEAM', style: AppTextStyles.eyebrow),
                  ),
                  for (var i = 0; i < _team.length; i++) ...[
                    if (i > 0) const Divider(height: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _team[i].$1,
                                  style: AppTextStyles.bodyStrong,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _team[i].$2,
                                  style: AppTextStyles.captionSmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            Center(
              child: Text(
                'Mobile Development · Final Project',
                style: AppTextStyles.captionSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
