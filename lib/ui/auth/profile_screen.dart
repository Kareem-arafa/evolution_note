import 'package:evalution_note/models/user_data.dart';
import 'package:evalution_note/ui/auth/auth_screen.dart';
import 'package:evalution_note/utils/variables.dart';
import 'package:evalution_note/widgets/deafult_elevated_botton.dart';
import 'package:evalution_note/widgets/deafult_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupNameController = TextEditingController();
  TextEditingController roleController = TextEditingController();

  UserModel? user;
  @override
  void initState() {
    user = userModel!.copyWith();
    signupEmailController = TextEditingController(text: user!.email);
    signupNameController = TextEditingController(text: user!.userName);
    roleController = TextEditingController(text: user!.roleAr);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          IgnorePointer(
            child: Column(
              children: [
                DeafaultTextFormField(
                  controller: signupNameController,
                  label: 'الاسم',
                ),
                const SizedBox(height: 16),
                DeafaultTextFormField(
                  controller: signupEmailController,
                  label: 'البريد الإلكتروني',
                ),
                const SizedBox(height: 16),
                DeafaultTextFormField(
                  controller: roleController,
                  label: 'الدور',
                ),
              ],
            ),
          ),
          SizedBox(
            height: 60,
          ),
          DeafaultElevetedBotton(
            label: 'تسجيل خروج',
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
          ),
        ],
      ),
    );
  }
}
