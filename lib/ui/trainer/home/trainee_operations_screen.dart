import 'package:evalution_note/app_theme.dart';
import 'package:evalution_note/db/realtime_repository.dart';
import 'package:evalution_note/models/educational_video_data.dart';
import 'package:evalution_note/models/training_program_data.dart';
import 'package:evalution_note/models/user_data.dart';
import 'package:evalution_note/utils/toast_utils.dart';
import 'package:evalution_note/utils/variables.dart';
import 'package:evalution_note/widgets/deafult_elevated_botton.dart';
import 'package:flutter/material.dart';

class AddTraineeOperationsScreen extends StatefulWidget {
  final bool? showPrograms;
  final bool? showVideos;

  const AddTraineeOperationsScreen({super.key, this.showPrograms, this.showVideos});

  @override
  State<AddTraineeOperationsScreen> createState() => _AddTraineeOperationsScreenState();
}

class _AddTraineeOperationsScreenState extends State<AddTraineeOperationsScreen> {
  TrainingProgramModel? selectedProgram;
  EducationalVideoModel? selectedEducationalVideo;
  final db = RealtimeRepository();
  bool _loading = false;
  List<String> selectedPrograms = [];
  List<String> selectedVideos = [];

  @override
  void initState() {
    selectedPrograms = selectedTrainee!.trainingPrograms?.toList() ?? [];
    selectedVideos = selectedTrainee!.educationalVideos?.toList() ?? [];

    super.initState();
  }

  void _submitForm() {
    UserModel trainee = selectedTrainee!.copyWith();
    if (widget.showPrograms ?? false) {
      selectedPrograms.add(selectedProgram!.id!);
      trainee.trainingPrograms = selectedPrograms;
    }
    if (widget.showVideos ?? false) {
      selectedVideos.add(selectedEducationalVideo!.id!);
      trainee.educationalVideos = selectedVideos;
    }

    setState(() {
      _loading = true;
      selectedProgram = null;
      selectedEducationalVideo = null;
    });

    db.editUserProfile(trainee).then((value) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم الإضافة بنجاح')),
      );
      Navigator.pop(context);
      Navigator.pop(context);
      RealtimeRepository().getTraineesForTrainer();
    }).catchError((error) {
      showToast(error.toString());
      setState(() {
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppTheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.showPrograms ?? false)
              FutureBuilder(
                future: RealtimeRepository().getTrainersPrograms(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done)
                    return Center(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                    ));
                  if (!snapshot.hasData) return SizedBox.shrink();
                  List<TrainingProgramModel> trainingPrograms = (snapshot.data as List<TrainingProgramModel>);

                  return DropdownButtonFormField<TrainingProgramModel>(
                      value: selectedProgram,
                      onTap: () {
                        FocusScope.of(context).unfocus();
                      },
                      decoration: InputDecoration(
                        labelText: 'اختر البرنامج التدريب',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide(
                            color: AppTheme.black,
                            width: 1.5,
                          ),
                        ),
                      ),
                      items: trainingPrograms
                          .map((training) => DropdownMenuItem(
                                value: training,
                                child: Text(training.programName!),
                              ))
                          .toList(),
                      onChanged: (value) => selectedProgram = value!);
                },
              ),
            SizedBox(
              height: 16,
            ),
            if (widget.showVideos ?? false)
              FutureBuilder(
                future: RealtimeRepository().getTrainerEducationalVideos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done)
                    return Center(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                    ));
                  if (!snapshot.hasData) return SizedBox.shrink();
                  List<EducationalVideoModel> educationalVideos = (snapshot.data as List<EducationalVideoModel>);

                  return DropdownButtonFormField<EducationalVideoModel>(
                    value: selectedEducationalVideo,
                    onTap: () {
                      FocusScope.of(context).unfocus();
                    },
                    decoration: InputDecoration(
                      labelText: 'اختر الڤيديو التعليمي',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(
                          color: AppTheme.black,
                          width: 1.5,
                        ),
                      ),
                    ),
                    items: educationalVideos
                        .map((video) => DropdownMenuItem(
                              value: video,
                              child: Text(video.title!),
                            ))
                        .toList(),
                    onChanged: (value) => selectedEducationalVideo = value!,
                  );
                },
              ),
            const SizedBox(height: 16),
            _loading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                    ),
                  )
                : DeafaultElevetedBotton(
                    label: 'حفظ',
                    onPressed: _submitForm,
                  ),
          ],
        ),
      ),
    );
  }
}
