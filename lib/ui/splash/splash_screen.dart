import 'dart:async';
import 'dart:convert';

import 'package:evalution_note/models/user_data.dart';
import 'package:evalution_note/ui/admin/dashboard/admin_dashboard_screen.dart';
import 'package:evalution_note/ui/auth/auth_screen.dart';
import 'package:evalution_note/ui/splash/onboarding_screen.dart';
import 'package:evalution_note/ui/trainee/home/trainee_home_screen.dart';
import 'package:evalution_note/ui/trainer/home/trainer_home_screen.dart';
import 'package:evalution_note/utils/variables.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static const String id = '/SplashScreen';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 1), onDoneLoading);
  }

  onDoneLoading() async {
    var userJson, user;
    SharedPreferences.getInstance().then((prefs) {
      bool isLogined = prefs.getBool("isLogined") ?? false;
      if (!isLogined) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (BuildContext context) => OnboardingScreen()), (route) => false);
      } else {
        final JsonDecoder _decoder = new JsonDecoder();
        userJson = _decoder.convert(prefs.getString("user")!);
        setState(() {
          user = UserModel.fromJson(userJson);
        });
        setState(() {
          userModel = user;
        });
        if (userModel!.role == 'admin') {
          Navigator.pushNamedAndRemoveUntil(context, AdminDashboardScreen.id, (_) => false);
        } else if (userModel!.role == "trainer") {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => TrainerHomeScreen()), (_) => false);
        } else if (userModel!.role == "trainee") {
          Navigator.of(context).pushNamedAndRemoveUntil(TraineeHomeScreen.id, (_) => false);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Image.asset(
            "assets/images/logo.png",
          ),
        ),
      ),
    );
  }
}
