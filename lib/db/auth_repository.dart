import 'dart:convert';

import 'package:evalution_note/models/user_data.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthRepository {
  AuthRepository();
  final db = FirebaseDatabase.instance.ref();

  Future<UserModel?> login(String email, String password) async {
    UserModel? userData;
    return FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    )
        .then((d) async {
      var userReference = await db.child("users").child(d.user!.uid).once();
      if (userReference.snapshot.value != null) {
        userData = UserModel.fromJson((userReference.snapshot.value as Map<dynamic, dynamic>));
        userData!.id = userReference.snapshot.key;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        final JsonEncoder _encoder = new JsonEncoder();
        prefs.setString("user", _encoder.convert((userData!.toJson())));
        prefs.setBool("isLogined", true);
      }

      return userData;
    });
  }

  Future<UserModel> signup(String email, String password, UserModel user) async {
    UserModel newUser;
    return FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    )
        .then((d) async {
      DatabaseReference databaseReference = db.child("users").child(d.user!.uid);
      await databaseReference.set(user.toJson());
      var userSnapshot = await databaseReference.once();
      newUser = UserModel.fromJson((userSnapshot.snapshot.value as Map<dynamic, dynamic>));
      newUser.id = userSnapshot.snapshot.key;
      final JsonEncoder _encoder = new JsonEncoder();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("user", _encoder.convert((newUser.toJson())));
      prefs.setBool("isLogined", true);
      return newUser;
    });
  }
}
