import 'package:evalution_note/firebase_options.dart';
import 'package:evalution_note/ui/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:evalution_note/ui/admin/dashboard/add_user_form_screen.dart';
import 'package:evalution_note/ui/admin/dashboard/admin_app_settings_screen.dart';
import 'package:evalution_note/ui/admin/dashboard/admin_dashboard_screen.dart';
import 'package:evalution_note/ui/admin/dashboard/mange_user_screen.dart';
import 'package:evalution_note/ui/admin/dashboard/educational_videos_mangement_screen.dart';
import 'package:evalution_note/ui/auth/auth_screen.dart';
import 'package:evalution_note/ui/trainee/home/start_workout_screen.dart';
import 'package:evalution_note/ui/trainee/home/track_progress_screen.dart';
import 'package:evalution_note/ui/trainee/home/trainee_home_screen.dart';
import 'package:evalution_note/ui/trainee/home/view_videos_screen.dart';
import 'package:evalution_note/ui/trainee/home/workout_plan_details_screen.dart';
import 'package:evalution_note/ui/trainer/home/trainer_home_screen.dart';
import 'package:evalution_note/ui/trainer/home/trainer_mange_video_screen.dart';
import 'package:evalution_note/ui/trainer/home/trainer_profile_screen.dart';
import 'package:evalution_note/ui/trainer/home/trainer_workout_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const EvalutioNote());
}

class EvalutioNote extends StatefulWidget {
  const EvalutioNote({super.key});

  @override
  State<EvalutioNote> createState() => _EvalutioNoteState();
}

class _EvalutioNoteState extends State<EvalutioNote> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      supportedLocales: const [
        Locale('ar', ''), // Arabic
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('ar'), // Set Arabic as the default language
      routes: {
        AdminDashboardScreen.id: (context) => const AdminDashboardScreen(),
        MangeUser.id: (context) => const MangeUser(),
        AddUserFormScreen.id: (context) => const AddUserFormScreen(),
        EducationalVideosManagementScreen.id: (context) => const EducationalVideosManagementScreen(),
        AdminAppSettingsScreen.id: (context) => const AdminAppSettingsScreen(),
        TraineeAuthScreen.id: (context) => const TraineeAuthScreen(),
        TraineeHomeScreen.id: (context) => const TraineeHomeScreen(),
        WorkoutPlanDetailScreen.id: (context) => const WorkoutPlanDetailScreen(),
        StartWorkoutScreen.id: (context) => const StartWorkoutScreen(),
        TrackProgressScreen.id: (context) => const TrackProgressScreen(),
        ViewVideosScreen.id: (context) => const ViewVideosScreen(),
        TrainerHomeScreen.id: (context) => const TrainerHomeScreen(),
        TrainerProfileScreen.id: (context) => const TrainerProfileScreen(),
        WorkoutProgramDesignScreen.id: (context) => const WorkoutProgramDesignScreen(),
        VideoManagementScreen.id: (context) => const VideoManagementScreen(),
        SplashScreen.id: (context) => const SplashScreen(),
      },
      initialRoute: SplashScreen.id,
    );
  }
}
