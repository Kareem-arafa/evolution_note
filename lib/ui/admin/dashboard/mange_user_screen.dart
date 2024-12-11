import 'package:evalution_note/db/realtime_repository.dart';
import 'package:evalution_note/models/user_data.dart';
import 'package:evalution_note/app_theme.dart';
import 'package:evalution_note/ui/admin/dashboard/add_user_form_screen.dart';
import 'package:evalution_note/ui/admin/dashboard/edit_user_form_screen.dart';
import 'package:flutter/material.dart';

class MangeUser extends StatefulWidget {
  final bool? hasAppbar;
  static const String id = '/MangeUser';
  const MangeUser({super.key, this.hasAppbar});

  @override
  State<MangeUser> createState() => _MangeUserState();
}

class _MangeUserState extends State<MangeUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.hasAppbar ?? false
          ? AppBar(
              title: const Text('إدارة المستخدمين'),
              centerTitle: true,
              backgroundColor: AppTheme.primary,
            )
          : PreferredSize(
              preferredSize: Size.fromHeight(0),
              child: SizedBox.shrink(),
            ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pushNamed(AddUserFormScreen.id).then((_) {
                  setState(() {});
                });
              },
              style: ElevatedButton.styleFrom(
                iconColor: AppTheme.black,
                foregroundColor: AppTheme.black,
                backgroundColor: AppTheme.green,
              ),
              icon: const Icon(Icons.add),
              label: const Text('إضافة مستخدم'),
            ),
            Expanded(
              child: FutureBuilder(
                future: RealtimeRepository().getUsers(),
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
                        Text('لا يوجد مستخدمين'.toUpperCase())
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
                                        builder: (_) => EditUserFormScreen(
                                          user: users[index],
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
                                                "هل انت متأكد انك تريد حذف هذا المستخدم؟",
                                                style: TextStyle(
                                                    fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            contentPadding: EdgeInsets.all(0),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  setState(() {
                                                    RealtimeRepository().removeUser(users[index]);
                                                    Navigator.pop(context);
                                                    ScaffoldMessenger.of(context).showSnackBar(
                                                      const SnackBar(content: Text('تم حذف المستخدم بنجاح')),
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
