import 'package:evalution_note/db/realtime_repository.dart';
import 'package:evalution_note/models/educational_video_data.dart';
import 'package:evalution_note/utils/toast_utils.dart';
import 'package:evalution_note/widgets/deafult_elevated_botton.dart';
import 'package:evalution_note/widgets/deafult_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:evalution_note/app_theme.dart';

class EditEducationalVideoFormScreen extends StatefulWidget {
  static const String id = '/EditEducationalVideoFormScreen';
  final EducationalVideoModel? educationalVideo;
  const EditEducationalVideoFormScreen({super.key, this.educationalVideo});

  @override
  EditEducationalVideoFormScreenState createState() => EditEducationalVideoFormScreenState();
}

class EditEducationalVideoFormScreenState extends State<EditEducationalVideoFormScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();
  TextEditingController videoLink = TextEditingController();

  final db = RealtimeRepository();
  bool _loading = false;

  @override
  void initState() {
    title = TextEditingController(text: widget.educationalVideo!.title);
    videoLink = TextEditingController(text: widget.educationalVideo!.videoLink);
    super.initState();
  }

  void _submitForm() {
    if (formKey.currentState!.validate()) {
      EducationalVideoModel educationalVideoModel = EducationalVideoModel(
        id: widget.educationalVideo!.id,
        title: title.text,
        videoLink: videoLink.text,
        role: widget.educationalVideo!.role,
        userId: widget.educationalVideo!.userId,
      );
      setState(() {
        _loading = true;
      });

      db.editEducationalVideo(educationalVideoModel).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تعديل الڤيديو التعليمي بنجاح')),
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
        title: const Text('تعديل ڤيديو تعليمي'),
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
                  controller: title,
                ),
                const SizedBox(height: 16),
                DeafaultTextFormField(
                  label: 'رابط الڤيديو',
                  hintText: 'أدخل رابط الڤيديو (رابط يوتيوب)',
                  validator: (value) => value!.isEmpty ? 'يرجى إدخال رابط الڤيديو' : null,
                  controller: videoLink,
                ),
                const SizedBox(height: 24),
                _loading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                        ),
                      )
                    : DeafaultElevetedBotton(
                        label: 'تعديل الڤيديو',
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
