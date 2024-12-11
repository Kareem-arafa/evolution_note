import 'package:evalution_note/app_theme.dart';
import 'package:flutter/material.dart';

class StartWorkoutScreen extends StatelessWidget {
  static const String id = '/StartWorkoutScreen';
  const StartWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ابدأ التمرين"),
        backgroundColor: AppTheme.primary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "تمرين اليوم",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            // Add workout instructions, timer, etc.
          ],
        ),
      ),
    );
  }
}
