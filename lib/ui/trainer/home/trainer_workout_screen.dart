import 'package:evalution_note/app_theme.dart';
import 'package:evalution_note/db/realtime_repository.dart';
import 'package:evalution_note/models/training_program_data.dart';
import 'package:evalution_note/utils/toast_utils.dart';
import 'package:evalution_note/utils/variables.dart';
import 'package:evalution_note/widgets/deafult_elevated_botton.dart';
import 'package:flutter/material.dart';
import 'package:evalution_note/widgets/deafult_text_form_field.dart';

class WorkoutProgramDesignScreen extends StatefulWidget {
  static const String id = '/WorkoutProgramDesignScreen';

  const WorkoutProgramDesignScreen({super.key});

  @override
  State<WorkoutProgramDesignScreen> createState() => _WorkoutProgramDesignScreenState();
}

class _WorkoutProgramDesignScreenState extends State<WorkoutProgramDesignScreen> {
  String programName = '';
  String target = '';
  String trainings = '';
  String numberOfRepsAndSets = '';
  String weeklyFrequency = '';
  final formKey = GlobalKey<FormState>();

  final db = RealtimeRepository();
  bool _loading = false;

  void _submitForm() {
    if (formKey.currentState!.validate()) {
      TrainingProgramModel program = TrainingProgramModel(
        programName: programName,
        target: target,
        role: "trainer",
        trainings: trainings,
        numberOfRepsAndSets: numberOfRepsAndSets,
        weeklyFrequency: weeklyFrequency,
        userId: userModel!.id,
      );
      setState(() {
        _loading = true;
      });

      db.addTrainingProgram(program).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إضافة البرنامج بنجاح')),
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
        title: const Text('تصميم برنامج تدريبي'),
        backgroundColor: AppTheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              DeafaultTextFormField(
                onChanged: (value) => programName = value,
                label: 'اسم البرنامج',
                validator: (value) => value!.isEmpty ? 'يرجى إدخال اسم البرنامج' : null,
              ),
              const SizedBox(height: 16),
              DeafaultTextFormField(
                label: 'الهدف',
                hintText: 'أدخل الهدف',
                validator: (value) => value!.isEmpty ? 'يرجى إدخال الهدف' : null,
                onChanged: (value) => target = value,
              ),
              SizedBox(
                height: 16,
              ),
              DeafaultTextFormField(
                label: 'التدريبات',
                hintText: 'أدخل التدريبات',
                validator: (value) => value!.isEmpty ? 'يرجى إدخال التدريبات' : null,
                onChanged: (value) => trainings = value,
              ),
              SizedBox(
                height: 16,
              ),
              DeafaultTextFormField(
                label: 'عدد التكرارات والمجموعات',
                hintText: 'أدخل عدد التكرارات والمجموعات',
                validator: (value) => value!.isEmpty ? 'يرجى إدخال عدد التكرارات والمجموعات' : null,
                onChanged: (value) => numberOfRepsAndSets = value,
              ),
              SizedBox(
                height: 16,
              ),
              DeafaultTextFormField(
                label: 'التردد الاسبوعي',
                hintText: 'أدخل التردد الاسبوعي',
                validator: (value) => value!.isEmpty ? 'يرجى إدخال التردد الاسبوعي' : null,
                onChanged: (value) => weeklyFrequency = value,
              ),
              const SizedBox(height: 16),
              _loading
                  ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                      ),
                    )
                  : DeafaultElevetedBotton(
                      label: 'حفظ البرنامج',
                      onPressed: _submitForm,
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
