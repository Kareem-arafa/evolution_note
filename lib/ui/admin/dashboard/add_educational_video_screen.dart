import 'package:evalution_note/db/realtime_repository.dart';
import 'package:evalution_note/models/educational_video_data.dart';
import 'package:evalution_note/utils/toast_utils.dart';
import 'package:evalution_note/utils/variables.dart';
import 'package:evalution_note/widgets/deafult_elevated_botton.dart';
import 'package:evalution_note/widgets/deafult_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:evalution_note/app_theme.dart';

class AddEducationalVideoFormScreen extends StatefulWidget {
  static const String id = '/AddEducationalVideoFormScreen';
  const AddEducationalVideoFormScreen({super.key});

  @override
  AddEducationalVideoFormScreenState createState() => AddEducationalVideoFormScreenState();
}

class AddEducationalVideoFormScreenState extends State<AddEducationalVideoFormScreen> {
  final formKey = GlobalKey<FormState>();

  String title = '';
  String videoLink = '';

  final db = RealtimeRepository();
  bool _loading = false;

  void _submitForm() {
    if (formKey.currentState!.validate()) {
      EducationalVideoModel educationalVideoModel = EducationalVideoModel(
        title: title,
        videoLink: videoLink,
        role: "admin",
        userId: userModel!.id,
      );
      setState(() {
        _loading = true;
      });

      db.addEducationalVideo(educationalVideoModel).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إضافة الڤيديو التعليمي بنجاح')),
        );
        Navigator.pop(context);
      }).catchError((error) {
        showToast(error.toString());
        setState(() {
          _loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إضافة ڤيديو تعليمي'),
        centerTitle: true,
        backgroundColor: AppTheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DeafaultTextFormField(
                  label: 'عنوان الڤيديو',
                  hintText: 'أدخل عنوان الڤيديو',
                  validator: (value) => value!.isEmpty ? 'يرجى إدخال عنوان الڤيديو' : null,
                  onChanged: (value) => title = value,
                ),
                const SizedBox(height: 16),
                DeafaultTextFormField(
                  label: 'رابط الڤيديو',
                  hintText: 'أدخل رابط الڤيديو (رابط يوتيوب)',
                  validator: (value) => value!.isEmpty ? 'يرجى إدخال رابط الڤيديو' : null,
                  onChanged: (value) => videoLink = value,
                ),
                const SizedBox(height: 24),
                _loading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                        ),
                      )
                    : DeafaultElevetedBotton(
                        label: 'إضافة الڤيديو',
                        onPressed: _submitForm,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
