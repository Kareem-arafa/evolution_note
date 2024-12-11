import 'package:evalution_note/db/realtime_repository.dart';
import 'package:evalution_note/models/user_data.dart';
import 'package:evalution_note/app_theme.dart';
import 'package:evalution_note/ui/trainer/home/trainee_profile_screen.dart';
import 'package:evalution_note/utils/variables.dart';
import 'package:flutter/material.dart';

class TraineesScreen extends StatefulWidget {
  static const String id = '/TraineesScreen';
  const TraineesScreen({super.key});

  @override
  State<TraineesScreen> createState() => _TraineesScreenState();
}

class _TraineesScreenState extends State<TraineesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة المتدربين'),
        centerTitle: true,
        backgroundColor: AppTheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: RealtimeRepository().getTraineesForTrainer(),
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
                  Text('لا يوجد متدربين'.toUpperCase())
                ],
              ));
            List<UserModel> users = (snapshot.data as List<UserModel>);

            return ListView.separated(
              shrinkWrap: true,
              itemCount: users.length,
              itemBuilder: (_, int index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(' ${users[index].userName}'),
                      trailing: Icon(Icons.arrow_forward_rounded),
                      onTap: () {
                        setState(() {
                          selectedTrainee = users[index];
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TraineeProfileScreen(
                              trainee: users[index],
                            ),
                          ),
                        ).then((_) {
                          setState(() {
                            RealtimeRepository().getTraineesForTrainer();
                          });
                        });
                      },
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
    );
  }
}
