import 'package:evalution_note/db/realtime_repository.dart';
import 'package:evalution_note/models/training_program_data.dart';
import 'package:evalution_note/utils/toast_utils.dart';
import 'package:evalution_note/widgets/deafult_elevated_botton.dart';
import 'package:evalution_note/widgets/deafult_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:evalution_note/app_theme.dart';

class EditProgramFormScreen extends StatefulWidget {
  final TrainingProgramModel? trainingProgram;
  static const String id = '/EditProgramFormScreen';
  const EditProgramFormScreen({super.key, this.trainingProgram});

  @override
  EditProgramFormScreenState createState() => EditProgramFormScreenState();
}

class EditProgramFormScreenState extends State<EditProgramFormScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController programName = TextEditingController();
  TextEditingController target = TextEditingController();
  TextEditingController trainings = TextEditingController();
  TextEditingController numberOfRepsAndSets = TextEditingController();
  TextEditingController weeklyFrequency = TextEditingController();
  final db = RealtimeRepository();
  bool _loading = false;

  @override
  void initState() {
    programName = TextEditingController(text: widget.trainingProgram!.programName);
    target = TextEditingController(text: widget.trainingProgram!.target);
    trainings = TextEditingController(text: widget.trainingProgram!.trainings);
    numberOfRepsAndSets = TextEditingController(text: widget.trainingProgram!.numberOfRepsAndSets);
    weeklyFrequency = TextEditingController(text: widget.trainingProgram!.weeklyFrequency);

    super.initState();
  }

  void _submitForm() {
    if (formKey.currentState!.validate()) {
      TrainingProgramModel program = TrainingProgramModel(
        id: widget.trainingProgram!.id,
        programName: programName.text,
        target: target.text,
        role: widget.trainingProgram!.role,
        trainings: trainings.text,
        numberOfRepsAndSets: numberOfRepsAndSets.text,
        weeklyFrequency: weeklyFrequency.text,
      );
      setState(() {
        _loading = true;
      });

      db.editTrainingProgram(program).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تعديل البرنامج بنجاح')),
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
        title: const Text('تعديل برنامج تدريبي'),
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
                  label: 'اسم البرنامج',
                  hintText: 'أدخل اسم البرنامج',
                  validator: (value) => value!.isEmpty ? 'يرجى إدخال اسم البرنامج' : null,
                  controller: programName,
                ),
                const SizedBox(height: 16),
                DeafaultTextFormField(
                  label: 'الهدف',
                  hintText: 'أدخل الهدف',
                  validator: (value) => value!.isEmpty ? 'يرجى إدخال الهدف' : null,
                  controller: target,
                ),
                SizedBox(
                  height: 16,
                ),
                DeafaultTextFormField(
                  label: 'التدريبات',
                  hintText: 'أدخل التدريبات',
                  validator: (value) => value!.isEmpty ? 'يرجى إدخال التدريبات' : null,
                  controller: trainings,
                ),
                SizedBox(
                  height: 16,
                ),
                DeafaultTextFormField(
                  label: 'عدد التكرارات والمجموعات',
                  hintText: 'أدخل عدد التكرارات والمجموعات',
                  validator: (value) => value!.isEmpty ? 'يرجى إدخال عدد التكرارات والمجموعات' : null,
                  controller: numberOfRepsAndSets,
                ),
                SizedBox(
                  height: 16,
                ),
                DeafaultTextFormField(
                  label: 'التردد الاسبوعي',
                  hintText: 'أدخل التردد الاسبوعي',
                  validator: (value) => value!.isEmpty ? 'يرجى إدخال التردد الاسبوعي' : null,
                  controller: weeklyFrequency,
                ),
                const SizedBox(height: 24),
                _loading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                        ),
                      )
                    : DeafaultElevetedBotton(
                        label: 'تعديل البرنامج',
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
