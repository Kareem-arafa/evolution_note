import 'package:evalution_note/app_theme.dart';
import 'package:evalution_note/db/realtime_repository.dart';
import 'package:evalution_note/models/educational_video_data.dart';
import 'package:evalution_note/models/training_program_data.dart';
import 'package:evalution_note/models/user_data.dart';
import 'package:evalution_note/ui/trainee/home/workout_plan_details_screen.dart';
import 'package:evalution_note/ui/trainee/home/youtube_video_player_widget.dart';
import 'package:evalution_note/ui/trainer/home/trainee_operations_screen.dart';
import 'package:evalution_note/ui/trainer/reports/add_report_screen.dart';
import 'package:evalution_note/ui/trainer/reports/reports_screen.dart';
import 'package:evalution_note/widgets/workout_card.dart';
import 'package:flutter/material.dart';

class TraineeProfileScreen extends StatefulWidget {
  final UserModel? trainee;
  static const String id = '/TraineeProfileScreen';
  const TraineeProfileScreen({super.key, this.trainee});

  @override
  State<TraineeProfileScreen> createState() => _TraineeProfileScreenState();
}

class _TraineeProfileScreenState extends State<TraineeProfileScreen> {
  bool _loading = false;
  List<TrainingProgramModel> traininPrograms = [];
  List<EducationalVideoModel> educationalVideos = [];

  @override
  void didChangeDependencies() {
    setState(() {
      _loading = true;
    });

    RealtimeRepository().getTrainingPrograms().then((programs) {
      setState(() {
        traininPrograms = programs;
        _loading = false;
        getUserPrograms();
      });
    });

    RealtimeRepository().getEducationalVideos().then((videos) {
      setState(() {
        educationalVideos = videos;
        _loading = false;
        getUserEducationalVideos();
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المتدرب'),
        backgroundColor: AppTheme.primary,
        centerTitle: true,
      ),
      body: _loading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.primary,
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "خطط التمرين",
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontSize: 18,
                            ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (_) => AddTraineeOperationsScreen(
                                        showPrograms: true,
                                      )))
                              .then((_) {
                            setState(() {});
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('إضافة تمرين'),
                        style: ElevatedButton.styleFrom(
                          iconColor: AppTheme.black,
                          foregroundColor: AppTheme.black,
                          backgroundColor: AppTheme.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  getUserPrograms().length > 0
                      ? SizedBox(
                          height: getUserPrograms().toSet().length > 0 ? 150 : 0,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            children: getUserPrograms().toSet().map((e) {
                              return WorkoutCard(
                                title: '${e.programName}',
                                description: '${e.target}',
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => WorkoutPlanDetailScreen(
                                        trainingProgram: e,
                                        userId: widget.trainee!.id,
                                      ),
                                    ),
                                  );
                                },
                              );
                            }).toList(),
                          ),
                        )
                      : Center(
                          child: Text("لم يتم إضافة اي تمارين بعد"),
                        ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "الڤيديوهات التعليمية",
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontSize: 18,
                            ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(
                                  builder: (_) => AddTraineeOperationsScreen(
                                        showVideos: true,
                                      )))
                              .then((_) {
                            setState(() {});
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('إضافة ڤيديوهات'),
                        style: ElevatedButton.styleFrom(
                          iconColor: AppTheme.black,
                          foregroundColor: AppTheme.black,
                          backgroundColor: AppTheme.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _loading
                      ? Center(
                          child: CircularProgressIndicator(
                            color: AppTheme.primary,
                          ),
                        )
                      : getUserEducationalVideos().length > 0
                          ? SizedBox(
                              height: getUserEducationalVideos().toSet().length > 0 ? 130 : 0,
                              child: ListView(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                children: getUserEducationalVideos().toSet().map((e) {
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => YouTubeVideoPlayer(
                                                    educationalVideo: e,
                                                  )));
                                    },
                                    child: Card(
                                      margin: const EdgeInsets.only(right: 16.0),
                                      color: AppTheme.primary,
                                      child: Container(
                                        width: 120,
                                        padding: const EdgeInsets.all(16),
                                        child: Column(
                                          children: [
                                            Icon(
                                              Icons.video_library,
                                              size: 30,
                                            ),
                                            SizedBox(
                                              height: 16,
                                            ),
                                            Text(
                                              e.title!,
                                              style: Theme.of(context).textTheme.titleMedium!,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          : Center(
                              child: Text("لم يتم إضافة اي ڤيديوهات بعد"),
                            ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "التقارير",
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontSize: 18,
                            ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddReportScreen())).then((_) {
                            setState(() {});
                          });
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('إضافة تقرير'),
                        style: ElevatedButton.styleFrom(
                          iconColor: AppTheme.black,
                          foregroundColor: AppTheme.black,
                          backgroundColor: AppTheme.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ReportsView(
                    user: widget.trainee!,
                  ),
                ],
              ),
            ),
    );
  }

  List<TrainingProgramModel> getUserPrograms() {
    List<TrainingProgramModel> userTrainingProgram = [];

    for (TrainingProgramModel program in traininPrograms) {
      for (var id in widget.trainee?.trainingPrograms ?? []) {
        if (program.id == id) {
          userTrainingProgram.add(program);
        }
      }
    }
    return userTrainingProgram;
  }

  List<EducationalVideoModel> getUserEducationalVideos() {
    List<EducationalVideoModel> userEducationalVideos = [];

    for (EducationalVideoModel video in educationalVideos) {
      for (var id in widget.trainee?.educationalVideos ?? []) {
        if (video.id == id) {
          userEducationalVideos.add(video);
        }
      }
    }
    return userEducationalVideos;
  }
}
