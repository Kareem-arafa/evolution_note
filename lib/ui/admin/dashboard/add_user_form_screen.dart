import 'package:evalution_note/db/auth_repository.dart';
import 'package:evalution_note/models/user_data.dart';
import 'package:evalution_note/utils/toast_utils.dart';
import 'package:evalution_note/widgets/deafult_elevated_botton.dart';
import 'package:evalution_note/widgets/deafult_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:evalution_note/app_theme.dart';

class AddUserFormScreen extends StatefulWidget {
  static const String id = '/AddUserFormScreen';
  const AddUserFormScreen({super.key});

  @override
  AddUserFormScreenState createState() => AddUserFormScreenState();
}

class AddUserFormScreenState extends State<AddUserFormScreen> {
  final formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';
  String selectedRole = 'مدرب';
  final db = AuthRepository();
  bool _loading = false;
  final List<String> roles = ['مدرب'];

  void _submitForm() {
    if (formKey.currentState!.validate()) {
      UserModel user = UserModel(
        userName: name,
        email: email,
        password: password,
        roleAr: selectedRole,
        role: 'trainer',
      );
      setState(() {
        _loading = true;
      });

      db.signup(email, password, user).then((value) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم إضافة المستخدم بنجاح')),
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
        title: const Text('إضافة مستخدم جديد'),
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
                  validator: (value) => value!.isEmpty ? 'يرجى إدخال اسم المستخدم' : null,
                  onChanged: (value) => name = value,
                ),
                const SizedBox(height: 16),
                DeafaultTextFormField(
                  label: 'البريد الإلكتروني',
                  hintText: 'أدخل بريد المستخدم',
                  validator: (value) => value!.isEmpty ? 'يرجى إدخال بريد إلكتروني' : null,
                  onChanged: (value) => email = value,
                ),
                const SizedBox(height: 16),
                DeafaultTextFormField(
                  label: 'كلمة المرور',
                  hintText: 'أدخل كلمة المرور',
                  isPassword: true,
                  validator: (value) => value!.isEmpty ? 'يرجى إدخال كلمة مرور' : null,
                  onChanged: (value) => password = value,
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
                        label: 'إضافة مستخدم',
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
