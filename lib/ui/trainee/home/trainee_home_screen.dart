import 'package:evalution_note/app_theme.dart';
import 'package:evalution_note/db/realtime_repository.dart';
import 'package:evalution_note/models/training_program_data.dart';
import 'package:evalution_note/ui/auth/profile_screen.dart';
import 'package:evalution_note/ui/trainee/home/view_videos_screen.dart';
import 'package:evalution_note/ui/trainee/home/workout_plan_details_screen.dart';
import 'package:evalution_note/ui/trainer/reports/reports_screen.dart';
import 'package:evalution_note/utils/variables.dart';
import 'package:evalution_note/widgets/workout_card.dart';
import 'package:flutter/material.dart';

class TraineeHomeScreen extends StatefulWidget {
  static const String id = '/TraineeHomeScreen';

  const TraineeHomeScreen({super.key});

  @override
  State<TraineeHomeScreen> createState() => _TraineeHomeScreenState();
}

class _TraineeHomeScreenState extends State<TraineeHomeScreen> {
  bool _loading = false;
  List<TrainingProgramModel> traininPrograms = [];
  int _selectedIndex = 0;
  @override
  void didChangeDependencies() {
    setState(() {
      _loading = true;
    });
    try {
      RealtimeRepository().getTrainingPrograms().then((programs) {
        setState(() {
          traininPrograms = programs;
          _loading = false;
          getUserPrograms();
        });
      });
    } catch (e) {
      print(e.toString());
    }

    super.didChangeDependencies();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedIndex == 0 ? 'الرئيسية' : 'الملف الشخصي'),
        backgroundColor: AppTheme.primary,
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'الملف الشخصي',
          ),
        ],
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
      ),
      body: _selectedIndex == 0 ? buildHomeScreen(context) : ProfileScreen(),
    );
  }

  buildHomeScreen(BuildContext context) {
    return _loading
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
                Text(
                  "مرحبًا بعودتك!" + " ${userModel?.userName}",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 24,
                      ),
                ),
                const SizedBox(height: 24),
                Text(
                  "خطط التمرين الخاصة بك",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 18,
                      ),
                ),
                const SizedBox(height: 16),
                getUserPrograms().length > 0
                    ? SizedBox(
                        height: getUserPrograms().length > 0 ? 150 : 0,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          children: getUserPrograms().map((e) {
                            return WorkoutCard(
                              title: '${e.programName}',
                              description: '${e.target}',
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => WorkoutPlanDetailScreen(
                                      trainingProgram: e,
                                      userId: userModel!.id,
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
                Text(
                  "الڤيديوهات التعليمية الخاصة بك",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 18,
                      ),
                ),
                const SizedBox(height: 16),
                ViewVideosScreen(),
                const SizedBox(height: 24),
                Text(
                  "التقارير الخاصة بك",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 18,
                      ),
                ),
                const SizedBox(height: 16),
                ReportsView(
                  user: userModel!,
                ),
              ],
            ),
          );
  }

  List<TrainingProgramModel> getUserPrograms() {
    List<TrainingProgramModel> userTrainingProgram = [];

    for (TrainingProgramModel program in traininPrograms) {
      for (var id in userModel?.trainingPrograms ?? []) {
        if (program.id == id) {
          userTrainingProgram.add(program);
        }
      }
    }
    return userTrainingProgram;
  }
}
