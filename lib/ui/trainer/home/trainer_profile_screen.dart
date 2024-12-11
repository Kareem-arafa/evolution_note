import 'package:evalution_note/db/realtime_repository.dart';
import 'package:evalution_note/models/user_data.dart';
import 'package:evalution_note/utils/toast_utils.dart';
import 'package:evalution_note/utils/variables.dart';
import 'package:evalution_note/widgets/deafult_elevated_botton.dart';
import 'package:flutter/material.dart';
import 'package:evalution_note/app_theme.dart';
import 'package:evalution_note/widgets/deafult_text_form_field.dart';

class TrainerProfileScreen extends StatefulWidget {
  static const String id = '/TrainerProfileScreen';
  const TrainerProfileScreen({super.key});

  @override
  State<TrainerProfileScreen> createState() => _TrainerProfileScreenState();
}

class _TrainerProfileScreenState extends State<TrainerProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController bioController = TextEditingController();
  final db = RealtimeRepository();
  bool _loading = false;

  void _submitForm() {
    UserModel user = UserModel(
      id: userModel!.id,
      email: userModel!.email,
      userName: nameController.text,
      roleAr: userModel!.roleAr,
      role: userModel!.role,
      bio: bioController.text,
    );
    setState(() {
      _loading = true;
    });

    db.editUserProfile(user).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تعديل الملف الشخصي بنجاح')),
      );
      setState(() {
        userModel = value;
      });
      Navigator.pop(context);
    }).catchError((error) {
      showToast(error.toString());
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  void initState() {
    nameController = TextEditingController(text: userModel!.userName);
    bioController = TextEditingController(text: userModel!.bio);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        backgroundColor: AppTheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DeafaultTextFormField(
              controller: nameController,
              label: 'الاسم',
            ),
            const SizedBox(height: 16),
            DeafaultTextFormField(
              controller: bioController,
              label: 'نبذة',
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            _loading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                    ),
                  )
                : DeafaultElevetedBotton(
                    label: 'حفظ الملف الشخصي',
                    onPressed: _submitForm,
                  ),
          ],
        ),
      ),
    );
  }
}
