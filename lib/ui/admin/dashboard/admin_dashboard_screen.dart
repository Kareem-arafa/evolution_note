import 'package:evalution_note/ui/admin/dashboard/mange_user_screen.dart';
import 'package:evalution_note/ui/admin/dashboard/training_program_management_screen.dart';
import 'package:evalution_note/ui/admin/dashboard/educational_videos_mangement_screen.dart';
import 'package:evalution_note/app_theme.dart';
import 'package:evalution_note/ui/auth/auth_screen.dart';
import 'package:evalution_note/utils/variables.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminDashboardScreen extends StatelessWidget {
  static const String id = '/AdminDashboardScreen';
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة المستخدمين'),
        centerTitle: true,
        backgroundColor: AppTheme.primary,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppTheme.primary,
              ),
              child: Text(
                'قائمة المشرف',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontSize: 24,
                    ),
              ),
            ),
            ListTile(
              title: Text(
                'إدارة المستخدمين',
                style: Theme.of(context).textTheme.titleMedium!,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MangeUser(
                      hasAppbar: true,
                    ),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'إدارة برامج التمرين',
                style: Theme.of(context).textTheme.titleMedium!,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => TrainingProgramManagementScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: Text(
                'إدارة الفيديوهات التعليمية',
                style: Theme.of(context).textTheme.titleMedium!,
              ),
              onTap: () {
                Navigator.pushNamed(context, EducationalVideosManagementScreen.id);
              },
            ),
            ListTile(
              title: Text(
                'تسجيل خروج',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Colors.red,
                    ),
              ),
              leading: Icon(
                Icons.logout,
                color: Colors.red,
              ),
              onTap: () async {
                SharedPreferences preferences = await SharedPreferences.getInstance();
                preferences.remove('isLogined');
                preferences.remove('user');
                preferences.clear();
                userModel = null;
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => TraineeAuthScreen()), (route) => false);
                });
              },
            ),
          ],
        ),
      ),
      body: MangeUser(
        hasAppbar: false,
      ),
    );
  }
}
