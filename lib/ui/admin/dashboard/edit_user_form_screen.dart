import 'package:evalution_note/db/realtime_repository.dart';
import 'package:evalution_note/models/user_data.dart';
import 'package:evalution_note/utils/toast_utils.dart';
import 'package:evalution_note/utils/variables.dart';
import 'package:evalution_note/widgets/deafult_elevated_botton.dart';
import 'package:evalution_note/widgets/deafult_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:evalution_note/app_theme.dart';

class EditUserFormScreen extends StatefulWidget {
  final UserModel? user;
  static const String id = '/EditUserFormScreen';
  const EditUserFormScreen({super.key, this.user});

  @override
  EditUserFormScreenState createState() => EditUserFormScreenState();
}

class EditUserFormScreenState extends State<EditUserFormScreen> {
  final formKey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();

  String selectedRole = '';
  final db = RealtimeRepository();
  bool _loading = false;
  final List<String> roles = ['مدرب', 'متدرب'];

  @override
  void initState() {
    email = TextEditingController(text: widget.user!.email);
    name = TextEditingController(text: widget.user!.userName);
    selectedRole = widget.user!.roleAr ?? "";
    super.initState();
  }

  void _submitForm() {
    if (formKey.currentState!.validate()) {
      UserModel user = UserModel(
        id: widget.user!.id,
        email: email.text,
        userName: name.text,
        roleAr: selectedRole,
        role: selectedRole == roles[0]
            ? "manager"
            : selectedRole == roles[1]
                ? "trainer"
                : "trainee",
      );
      setState(() {
        _loading = true;
      });

      db.editUserProfile(user).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم تعديل المستخدم بنجاح')),
        );
        setState(() {
          userModel = value;
        });
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
        title: const Text('تعديل المستخدم'),
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
                  label: 'الاسم',
                  hintText: 'أدخل اسم المستخدم',
                  validator: (value) => value!.isEmpty ? 'يرجى إدخال اسم' : null,
                  controller: name,
                ),
                const SizedBox(height: 16),
                Opacity(
                  opacity: 0.2,
                  child: IgnorePointer(
                    child: DeafaultTextFormField(
                      label: 'البريد الإلكتروني',
                      hintText: 'أدخل بريد المستخدم',
                      validator: (value) => value!.isEmpty ? 'يرجى إدخال بريد إلكتروني' : null,
                      controller: email,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedRole,
                  decoration: InputDecoration(
                    labelText: 'الدور',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide(
                        color: AppTheme.black,
                        width: 1.5,
                      ),
                    ),
                  ),
                  items: roles
                      .map((role) => DropdownMenuItem(
                            value: role,
                            child: Text(role),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() {
                    selectedRole = value!;
                  }),
                ),
                const SizedBox(height: 24),
                _loading
                    ? Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                        ),
                      )
                    : DeafaultElevetedBotton(
                        label: 'تعديل المستخدم',
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
