import 'package:evalution_note/app_theme.dart';
import 'package:flutter/material.dart';

class AchievementBadge extends StatelessWidget {
  final String title;

  const AchievementBadge({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall!,
      ),
    );
  }
}
