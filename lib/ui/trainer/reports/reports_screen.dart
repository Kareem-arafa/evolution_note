import 'package:evalution_note/app_theme.dart';
import 'package:evalution_note/db/realtime_repository.dart';
import 'package:evalution_note/models/report_data.dart';
import 'package:evalution_note/models/user_data.dart';
import 'package:evalution_note/ui/trainer/reports/report_details_screen.dart';
import 'package:evalution_note/widgets/workout_card.dart';
import 'package:flutter/material.dart';

class ReportsView extends StatelessWidget {
  final UserModel user;
  const ReportsView({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: RealtimeRepository().getTraineeReports(user),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return Center(
              child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
          ));
        if (!snapshot.hasData)
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/hourglass.png',
                height: 150,
              ),
              SizedBox(
                height: 10,
              ),
              Text('لا يوجد تقارير'.toUpperCase())
            ],
          ));
        List<ReportModel> reports = (snapshot.data as List<ReportModel>);

        return SizedBox(
          height: reports.length > 0 ? 150 : 0,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: reports.map((e) {
              return WorkoutCard(
                title: '${e.title}',
                description: '${e.description}',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ReportDetailScreen(
                        report: e,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
