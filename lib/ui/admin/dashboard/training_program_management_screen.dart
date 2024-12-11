import 'package:evalution_note/app_theme.dart';
import 'package:evalution_note/db/realtime_repository.dart';
import 'package:evalution_note/models/training_program_data.dart';
import 'package:evalution_note/ui/admin/dashboard/edit_training_program_screen.dart';
import 'package:flutter/material.dart';

class TrainingProgramManagementScreen extends StatefulWidget {
  static const id = '/TrainingProgramManagementScreen';
  const TrainingProgramManagementScreen({super.key});

  @override
  State<TrainingProgramManagementScreen> createState() => _TrainingProgramManagementScreenState();
}

class _TrainingProgramManagementScreenState extends State<TrainingProgramManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة برامج التمرين'),
        centerTitle: true,
        backgroundColor: AppTheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ElevatedButton.icon(
            //   onPressed: () {
            //     Navigator.of(context).push(MaterialPageRoute(builder: (_) => AddProgramFormScreen())).then((_) {
            //       setState(() {});
            //     });
            //   },
            //   icon: const Icon(Icons.add),
            //   label: const Text('إضافة برنامج تمرين'),
            //   style: ElevatedButton.styleFrom(
            //     iconColor: AppTheme.black,
            //     foregroundColor: AppTheme.black,
            //     backgroundColor: AppTheme.green,
            //   ),
            // ),
            Expanded(
              child: FutureBuilder(
                future: RealtimeRepository().getTrainingPrograms(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done)
                    return Center(
                        child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                    ));
                  if (!snapshot.hasData)
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/hourglass.png',
                          height: 150,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('لا يوجد تمارين تدريبية'.toUpperCase())
                      ],
                    ));
                  List<TrainingProgramModel> trainingPrograms = (snapshot.data as List<TrainingProgramModel>);

                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: trainingPrograms.length,
                    itemBuilder: (_, int index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(' ${trainingPrograms[index].programName}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.edit,
                                    color: AppTheme.grey,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => EditProgramFormScreen(
                                          trainingProgram: trainingPrograms[index],
                                        ),
                                      ),
                                    ).then((_) {
                                      setState(() {});
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: AppTheme.red,
                                  ),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            elevation: 0.0,
                                            backgroundColor: Colors.white,
                                            content: Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Text(
                                                "هل انت متأكد انك تريد حذف هذا البرنامج؟",
                                                style: TextStyle(
                                                    fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.all(0),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    RealtimeRepository().removeTrainingProgram(trainingPrograms[index]);
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('تم حذف البرنامج بنجاح')),
                                                    );
                                                  });
                                                },
                                                child: Text(
                                                  "نعم",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                child: Text(
                                                  "لا",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              )
                                            ],
                                          );
                                        });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 4,
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
