import 'package:evalution_note/ui/auth/auth_screen.dart';
import 'package:evalution_note/ui/trainer/home/trainees_screen.dart';
import 'package:evalution_note/ui/trainer/home/trainer_educational_videos_screen.dart';
import 'package:evalution_note/ui/trainer/home/trainer_profile_screen.dart';
import 'package:evalution_note/ui/trainer/home/trainer_training_programs_screen.dart';
import 'package:evalution_note/utils/variables.dart';
import 'package:evalution_note/widgets/deafult_elevated_botton.dart';
import 'package:flutter/material.dart';
import 'package:evalution_note/app_theme.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TrainerHomeScreen extends StatelessWidget {
  static const String id = '/TrainerHomeScreen';

  const TrainerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الصفحة الرئيسية للمدرب'),
        centerTitle: true,
        backgroundColor: AppTheme.primary,
        actions: [
          IconButton(
            onPressed: () async {
              SharedPreferences preferences = await SharedPreferences.getInstance();
              preferences.remove('isLogined');
              preferences.remove('user');
              preferences.clear();
              userModel = null;
              FirebaseAuth.instance.signOut().then((value) {
                Navigator.of(context)
                    .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => TraineeAuthScreen()), (route) => false);
              });
            },
            icon: Icon(
              Icons.logout,
              color: Colors.red,
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: AppTheme.primary.withOpacity(0.05),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DeafaultElevetedBotton(
              label: 'تحديث الملف الشخصي',
              onPressed: () {
                Navigator.pushNamed(context, TrainerProfileScreen.id);
              },
            ),
            const SizedBox(height: 16),
            DeafaultElevetedBotton(
              label: 'تصميم برنامج تدريبي',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => TrainerTrainingProgramScreen()));
              },
            ),
            const SizedBox(height: 16),
            DeafaultElevetedBotton(
              label: 'إدارة الفيديوهات',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => TrainerEducationalVideosScreen()));
              },
            ),
            const SizedBox(height: 16),
            DeafaultElevetedBotton(
              label: 'قائمة المتدربين',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => TraineesScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
