import 'package:evalution_note/app_theme.dart';
import 'package:evalution_note/models/report_data.dart';
import 'package:flutter/material.dart';

class ReportDetailScreen extends StatelessWidget {
  static const String id = '/ReportDetailScreen';
  final ReportModel? report;
  const ReportDetailScreen({super.key, this.report});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل التقرير'),
        backgroundColor: AppTheme.primary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text("${report!.title}",
                  style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.w600,
                      )),
            ),
            const SizedBox(height: 24),
            Container(
              color: Colors.grey.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Text(
                  "الوصف: ",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${report!.description}",
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
