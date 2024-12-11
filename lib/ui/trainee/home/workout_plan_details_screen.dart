import 'package:evalution_note/app_theme.dart';
import 'package:evalution_note/db/realtime_repository.dart';
import 'package:evalution_note/models/progress_data.dart';
import 'package:evalution_note/models/training_program_data.dart';
import 'package:evalution_note/utils/toast_utils.dart';
import 'package:evalution_note/utils/variables.dart';
import 'package:evalution_note/widgets/deafult_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class WorkoutPlanDetailScreen extends StatefulWidget {
  static const String id = '/WorkoutPlanDetailScreen';
  final TrainingProgramModel? trainingProgram;
  final String? userId;
  const WorkoutPlanDetailScreen({super.key, this.trainingProgram, this.userId});

  @override
  State<WorkoutPlanDetailScreen> createState() => _WorkoutPlanDetailScreenState();
}

class _WorkoutPlanDetailScreenState extends State<WorkoutPlanDetailScreen> {
  TextEditingController precentage = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final db = RealtimeRepository();
  bool _loading = false;

  TrainingProgramModel? trainingProgramModel;
  bool loadingProgress = false;
  ProgressModel? progressProgram;
  @override
  void initState() {
    trainingProgramModel = widget.trainingProgram!.copyWith();

    getProgress();
    super.initState();
  }

  getProgress() {
    setState(() {
      loadingProgress = true;
    });
    db.getProgress(widget.userId!, trainingProgramModel!.id!).then((progress) {
      setState(() {
        loadingProgress = false;
        if (progress.isNotEmpty) {
          progressProgram = progress[0];
          precentage = TextEditingController(text: progressProgram!.precentage.toString());
        }
      });
    });
  }

  void _submitForm() {
    if (formKey.currentState!.validate()) {
      ProgressModel progressModel = ProgressModel(
        id: progressProgram?.id ?? null,
        precentage: num.parse(precentage.text),
        userId: widget.userId,
        programId: trainingProgramModel!.id,
      );
      setState(() {
        _loading = true;
      });
      if (progressProgram == null) {
        db.addProgress(progressModel).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم إضافة نسبة التقدم بنجاح')),
          );
          Navigator.pop(context);
          Navigator.pop(context);
          db.getTraineesForTrainer();
          db.getProgress(widget.userId!, trainingProgramModel!.id!);
        }).catchError((error) {
          showToast(error.toString());
          setState(() {
            _loading = false;
          });
        });
      } else {
        db.editProgress(progressModel).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم تعديل نسبة التقدم بنجاح')),
          );
          Navigator.pop(context);
          Navigator.pop(context);
          db.getTraineesForTrainer();
          db.getProgress(widget.userId!, trainingProgramModel!.id!);
        }).catchError((error) {
          showToast(error.toString());
          setState(() {
            _loading = false;
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('خطة التمرين'),
        backgroundColor: AppTheme.primary,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Align(
          alignment: AlignmentDirectional.topStart,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (userModel!.role == "trainer")
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Form(
                          key: formKey,
                          child: DeafaultTextFormField(
                            label: 'نسبة التقدم',
                            hintText: 'أدخل نسبة التقدم',
                            controller: precentage,
                            textInputType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'نسبة التقدم';
                              else if (num.parse(value) <= 0 || num.parse(value) > 100)
                                return "يرجي إدخال نسبة تقدم مناسبة";
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      _loading
                          ? Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                              ),
                            )
                          : ElevatedButton.icon(
                              onPressed: () {
                                _submitForm();
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('إضافة'),
                              style: ElevatedButton.styleFrom(
                                iconColor: AppTheme.black,
                                foregroundColor: AppTheme.black,
                                backgroundColor: AppTheme.green,
                              ),
                            ),
                    ],
                  ),
                ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.grey.withOpacity(0.5),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      child: Text(
                        "اسم البرنامج: ",
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    " ${widget.trainingProgram!.programName}",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                color: Colors.grey.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    "الهدف: ",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${widget.trainingProgram!.target}",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 16),
              Container(
                color: Colors.grey.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    "التدريبات: ",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${widget.trainingProgram!.trainings}",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 16),
              Container(
                color: Colors.grey.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    "عدد التكرارات والمجموعات: ",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${widget.trainingProgram!.numberOfRepsAndSets}",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 16),
              Container(
                color: Colors.grey.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    "التردد الاسبوعي: ",
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "${widget.trainingProgram!.weeklyFrequency}",
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 30),
              loadingProgress
                  ? Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primary,
                      ),
                    )
                  : progressProgram != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              color: Colors.grey.withOpacity(0.5),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                child: Text(
                                  "نسبة التقدم: ",
                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: CircularPercentIndicator(
                                radius: 60.0,
                                lineWidth: 5.0,
                                percent: progressProgram!.precentage! / 100,
                                center: new Text("${progressProgram!.precentage}%"),
                                progressColor: AppTheme.primary,
                              ),
                            )
                          ],
                        )
                      : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
