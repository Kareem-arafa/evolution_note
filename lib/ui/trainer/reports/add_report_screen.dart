import 'package:evalution_note/app_theme.dart';
import 'package:evalution_note/db/realtime_repository.dart';
import 'package:evalution_note/models/report_data.dart';
import 'package:evalution_note/utils/toast_utils.dart';
import 'package:evalution_note/utils/variables.dart';
import 'package:evalution_note/widgets/deafult_elevated_botton.dart';
import 'package:flutter/material.dart';
import 'package:evalution_note/widgets/deafult_text_form_field.dart';

class AddReportScreen extends StatefulWidget {
  static const String id = '/AddReportScreen';

  const AddReportScreen({super.key});

  @override
  State<AddReportScreen> createState() => _AddReportScreenState();
}

class _AddReportScreenState extends State<AddReportScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final db = RealtimeRepository();
  bool _loading = false;

  void _submitForm() {
    if (formKey.currentState!.validate()) {
      ReportModel report = ReportModel(
        title: titleController.text,
        description: descriptionController.text,
        traineeId: selectedTrainee!.id,
      );
      setState(() {
        _loading = true;
      });

      db.addReport(report).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إضافة التقرير بنجاح')),
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
        title: const Text('إدارة التقارير'),
        backgroundColor: AppTheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              DeafaultTextFormField(
                controller: titleController,
                label: 'عنوان التقرير',
                validator: (value) => value!.isEmpty ? 'يرجى إدخال عنوان التقرير' : null,
              ),
              const SizedBox(height: 16),
              DeafaultTextFormField(
                controller: descriptionController,
                label: 'الوصف',
                hintText: 'أدخل الوصف',
                maxLines: 3,
                validator: (value) => value!.isEmpty ? 'يرجى إدخال الوصف' : null,
              ),
              const SizedBox(height: 16),
              _loading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                      ),
                    )
                  : DeafaultElevetedBotton(
                      label: 'حفظ التقرير',
                      onPressed: _submitForm,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
