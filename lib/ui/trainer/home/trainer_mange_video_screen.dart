import 'package:evalution_note/app_theme.dart';
import 'package:evalution_note/db/realtime_repository.dart';
import 'package:evalution_note/models/educational_video_data.dart';
import 'package:evalution_note/utils/toast_utils.dart';
import 'package:evalution_note/utils/variables.dart';
import 'package:evalution_note/widgets/deafult_elevated_botton.dart';
import 'package:flutter/material.dart';
import 'package:evalution_note/widgets/deafult_text_form_field.dart';

class VideoManagementScreen extends StatefulWidget {
  static const String id = '/VideoManagementScreen';

  const VideoManagementScreen({super.key});

  @override
  State<VideoManagementScreen> createState() => _VideoManagementScreenState();
}

class _VideoManagementScreenState extends State<VideoManagementScreen> {
  final TextEditingController videoTitleController = TextEditingController();
  final TextEditingController videoLinkController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final db = RealtimeRepository();
  bool _loading = false;

  void _submitForm() {
    if (formKey.currentState!.validate()) {
      EducationalVideoModel educationalVideoModel = EducationalVideoModel(
        title: videoTitleController.text,
        videoLink: videoLinkController.text,
        role: "trainer",
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
        title: const Text('إدارة الفيديوهات'),
        backgroundColor: AppTheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              DeafaultTextFormField(
                controller: videoTitleController,
                label: 'عنوان الفيديو',
                validator: (value) => value!.isEmpty ? 'يرجى إدخال عنوان الڤيديو' : null,
              ),
              const SizedBox(height: 16),
              DeafaultTextFormField(
                controller: videoLinkController,
                label: 'رابط الفيديو',
                hintText: 'أدخل رابط الڤيديو (رابط يوتيوب)',
                validator: (value) => value!.isEmpty ? 'يرجى إدخال رابط الڤيديو' : null,
              ),
              const SizedBox(height: 16),
              _loading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                      ),
                    )
                  : DeafaultElevetedBotton(
                      label: 'رفع الڤيديو',
                      onPressed: _submitForm,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
