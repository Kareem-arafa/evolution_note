import 'package:evalution_note/app_theme.dart';
import 'package:evalution_note/db/realtime_repository.dart';
import 'package:evalution_note/models/educational_video_data.dart';
import 'package:evalution_note/ui/admin/dashboard/edit_educational_video_screen.dart';
import 'package:evalution_note/ui/trainer/home/trainer_mange_video_screen.dart';
import 'package:flutter/material.dart';

class TrainerEducationalVideosScreen extends StatefulWidget {
  static const id = '/TrainerEducationalVideosScreen';
  const TrainerEducationalVideosScreen({super.key});

  @override
  State<TrainerEducationalVideosScreen> createState() => _EducationalVideosManagementScreenState();
}

class _EducationalVideosManagementScreenState extends State<TrainerEducationalVideosScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الفيديوهات التعليمية'),
        centerTitle: true,
        backgroundColor: AppTheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VideoManagementScreen(),
                  ),
                ).then((_) {
                  setState(() {});
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('إدارة الفيديوهات'),
              style: ElevatedButton.styleFrom(
                iconColor: AppTheme.black,
                foregroundColor: AppTheme.black,
                backgroundColor: AppTheme.green,
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: RealtimeRepository().getTrainerEducationalVideos(),
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
                        Text('لا يوجد ڤيديوهات'.toUpperCase())
                      ],
                    ));
                  List<EducationalVideoModel> educationalVideos = (snapshot.data as List<EducationalVideoModel>);

                  return ListView.separated(
                    shrinkWrap: true,
                    itemCount: educationalVideos.length,
                    itemBuilder: (_, int index) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(' ${educationalVideos[index].title}'),
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
                                        builder: (_) => EditEducationalVideoFormScreen(
                                          educationalVideo: educationalVideos[index],
                                        ),
                                      ),
                                    ).then((_) {
                                      setState(() {});
                                    });
                                  },
                                ),
                                // IconButton(
                                //   icon: Icon(
                                //     Icons.delete,
                                //     color: AppTheme.red,
                                //   ),
                                //   onPressed: () {
                                //     showDialog(
                                //         context: context,
                                //         builder: (BuildContext context) {
                                //           return AlertDialog(
                                //             shape: RoundedRectangleBorder(
                                //               borderRadius: BorderRadius.circular(5),
                                //             ),
                                //             elevation: 0.0,
                                //             backgroundColor: Colors.white,
                                //             content: Padding(
                                //               padding: const EdgeInsets.all(10),
                                //               child: Text(
                                //                 "هل انت متأكد انك تريد حذف هذا الڤيديو؟",
                                //                 style: TextStyle(
                                //                     fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                                //               ),
                                //             ),
                                //             contentPadding: EdgeInsets.all(0),
                                //             actions: [
                                //               TextButton(
                                //                 onPressed: () {
                                //                   setState(() {
                                //                     RealtimeRepository().removeEducationalVideo(educationalVideos[index]);
                                //                     Navigator.pop(context);
                                //                     ScaffoldMessenger.of(context).showSnackBar(
                                //                       const SnackBar(content: Text('تم حذف الڤيديو بنجاح')),
                                //                     );
                                //                   });
                                //                 },
                                //                 child: Text(
                                //                   "نعم",
                                //                   style: TextStyle(
                                //                     fontSize: 14,
                                //                     color: Colors.red,
                                //                     fontWeight: FontWeight.bold,
                                //                   ),
                                //                 ),
                                //               ),
                                //               TextButton(
                                //                 onPressed: () {
                                //                   setState(() {
                                //                     Navigator.pop(context);
                                //                   });
                                //                 },
                                //                 child: Text(
                                //                   "لا",
                                //                   style: TextStyle(
                                //                     fontSize: 14,
                                //                     color: Colors.black,
                                //                     fontWeight: FontWeight.bold,
                                //                   ),
                                //                 ),
                                //               )
                                //             ],
                                //           );
                                //         });
                                //   },
                                // ),
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
