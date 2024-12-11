import 'package:evalution_note/app_theme.dart';
import 'package:evalution_note/db/auth_repository.dart';
import 'package:evalution_note/db/realtime_repository.dart';
import 'package:evalution_note/models/user_data.dart';
import 'package:evalution_note/ui/admin/dashboard/admin_dashboard_screen.dart';
import 'package:evalution_note/ui/trainee/home/trainee_home_screen.dart';
import 'package:evalution_note/ui/trainer/home/trainer_home_screen.dart';
import 'package:evalution_note/utils/toast_utils.dart';
import 'package:evalution_note/utils/variables.dart';
import 'package:evalution_note/widgets/deafult_elevated_botton.dart';
import 'package:evalution_note/widgets/deafult_text_form_field.dart';
import 'package:flutter/material.dart';

class TraineeAuthScreen extends StatefulWidget {
  static const String id = '/TraineeAuthScreen';
  const TraineeAuthScreen({super.key});

  @override
  TraineeAuthScreenState createState() => TraineeAuthScreenState();
}

class TraineeAuthScreenState extends State<TraineeAuthScreen> with SingleTickerProviderStateMixin {
  late TabController tabController;
  final TextEditingController loginEmailController = TextEditingController();
  final TextEditingController loginPasswordController = TextEditingController();
  final TextEditingController signupEmailController = TextEditingController();
  final TextEditingController signupPasswordController = TextEditingController();
  final TextEditingController signupConfirmPasswordController = TextEditingController();
  final TextEditingController signupNameController = TextEditingController();
  final db = AuthRepository();
  bool _loading = false;
  final formKeyLogin = GlobalKey<FormState>();
  final formKeySignup = GlobalKey<FormState>();
  late final Future<List<UserModel>> trainersFuture;
  String selectedTitle = 'تسجيل دخول';
  UserModel? selectedTrainer;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    trainersFuture = RealtimeRepository().getTrainers(); // Cache the future
  }

  @override
  void dispose() {
    tabController.dispose();
    loginEmailController.dispose();
    loginPasswordController.dispose();
    signupEmailController.dispose();
    signupPasswordController.dispose();
    signupNameController.dispose();
    signupConfirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(selectedTitle),
        centerTitle: true,
        backgroundColor: AppTheme.primary,
        bottom: TabBar(
          onTap: (index) {
            setState(() {
              formKeyLogin.currentState?.reset();
              formKeySignup.currentState?.reset();
              selectedTrainer = null;
              if (index == 0) {
                selectedTitle = 'تسجيل دخول';
              } else {
                selectedTitle = 'إنشاء حساب كمتدرب';
              }
            });
          },
          controller: tabController,
          tabs: const [
            Tab(text: 'تسجيل دخول'),
            Tab(text: 'إنشاء حساب'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: formKeyLogin,
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    Image.asset(
                      'assets/images/logo.png',
                      height: MediaQuery.of(context).size.height * .25,
                    ),
                    const SizedBox(height: 64),
                    DeafaultTextFormField(
                      controller: loginEmailController,
                      label: 'البريد الإلكتروني',
                      validator: (value) => value!.isEmpty ? 'يرجى إدخال البريد الإلكتروني' : null,
                    ),
                    const SizedBox(height: 16),
                    DeafaultTextFormField(
                      label: 'كلمة المرور',
                      controller: loginPasswordController,
                      isPassword: true,
                      validator: (value) => value!.isEmpty ? 'يرجى إدخال كلمة المرور' : null,
                    ),
                    const SizedBox(height: 16),
                    _loading
                        ? Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                            ),
                          )
                        : DeafaultElevetedBotton(
                            label: 'تسجيل دخول',
                            onPressed: () {
                              if (formKeyLogin.currentState!.validate()) {
                                setState(() {
                                  _loading = true;
                                });

                                db.login(loginEmailController.text, loginPasswordController.text).then((value) {
                                  if (value == null) {
                                    showToast("هذا المستخدم غير موجود");
                                    setState(() {
                                      _loading = false;
                                      loginEmailController.clear();
                                      loginPasswordController.clear();
                                    });
                                  } else {
                                    setState(() {
                                      userModel = value;
                                    });
                                    if (value.role == 'admin') {
                                      Navigator.pushNamedAndRemoveUntil(context, AdminDashboardScreen.id, (_) => false);
                                    } else if (value.role == "trainer") {
                                      Navigator.pushAndRemoveUntil(context,
                                          MaterialPageRoute(builder: (_) => TrainerHomeScreen()), (_) => false);
                                    } else if (value.role == "trainee") {
                                      Navigator.of(context).pushNamedAndRemoveUntil(TraineeHomeScreen.id, (_) => false);
                                    }
                                  }
                                }).catchError((error) {
                                  showToast(error.toString());
                                  setState(() {
                                    _loading = false;
                                    loginEmailController.clear();
                                    loginPasswordController.clear();
                                  });
                                });
                              }
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
          // Signup Form
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: formKeySignup,
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    Image.asset(
                      'assets/images/logo.png',
                      height: MediaQuery.of(context).size.height * .25,
                    ),
                    const SizedBox(height: 64),
                    DeafaultTextFormField(
                      controller: signupNameController,
                      label: 'الاسم',
                      validator: (value) => value!.isEmpty ? 'يرجى إدخال الاسم' : null,
                    ),
                    const SizedBox(height: 16),
                    DeafaultTextFormField(
                      controller: signupEmailController,
                      label: 'البريد الإلكتروني',
                      validator: (value) => value!.isEmpty ? 'يرجى إدخال البريد الإلكتروني' : null,
                    ),
                    const SizedBox(height: 16),
                    DeafaultTextFormField(
                      label: 'كلمة المرور',
                      controller: signupPasswordController,
                      isPassword: true,
                      validator: (value) => value!.isEmpty ? 'يرجى إدخال كلمة المرور' : null,
                    ),
                    const SizedBox(height: 16),
                    DeafaultTextFormField(
                        label: 'تأكيد كلمة المرور',
                        controller: signupConfirmPasswordController,
                        isPassword: true,
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'يرجى إدخال تأكيد كلمة المرور';
                          else if (signupConfirmPasswordController.text != signupPasswordController.text)
                            return "تأكيد كلمة المرور غير متطابقة مع كلمة المرور";
                          return null;
                        }),
                    const SizedBox(height: 16),
                    FutureBuilder<List<UserModel>>(
                      future: trainersFuture, // Use cached future
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done)
                          return Center(
                              child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primary),
                          ));
                        if (!snapshot.hasData) return SizedBox.shrink();
                        List<UserModel> users = snapshot.data!;
                        return DropdownButtonFormField<UserModel>(
                          value: selectedTrainer,
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          },
                          decoration: InputDecoration(
                            labelText: 'اختر المدرب المناسب لك',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                color: AppTheme.black,
                                width: 1.5,
                              ),
                            ),
                          ),
                          items: users
                              .map((user) => DropdownMenuItem(
                                    value: user,
                                    child: Text(user.userName!),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedTrainer = value;
                            });
                          },
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
                            label: 'إنشاء حساب',
                            onPressed: () {
                              if (formKeySignup.currentState!.validate()) {
                                UserModel user = UserModel(
                                  userName: signupNameController.text,
                                  email: signupEmailController.text,
                                  role: "trainee",
                                  trainerId: selectedTrainer != null ? selectedTrainer!.id : null,
                                  roleAr: "متدرب",
                                );
                                setState(() {
                                  _loading = true;
                                  selectedTrainer = null;
                                });
                                db
                                    .signup(signupEmailController.text, signupPasswordController.text, user)
                                    .then((value) {
                                  setState(() {
                                    userModel = value;
                                  });
                                  if (value.role == "trainee") {
                                    Navigator.of(context).pushNamedAndRemoveUntil(TraineeHomeScreen.id, (_) => false);
                                  }
                                }).catchError((error) {
                                  showToast(error.toString());
                                  setState(() {
                                    _loading = false;
                                    loginEmailController.clear();
                                    loginPasswordController.clear();
                                  });
                                });
                              }
                            },
                          ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
