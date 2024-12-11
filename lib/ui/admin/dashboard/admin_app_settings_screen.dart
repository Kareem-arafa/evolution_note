import 'package:evalution_note/app_theme.dart';
import 'package:flutter/material.dart';

class AdminAppSettingsScreen extends StatefulWidget {
  static const String id = '/AdminAppSettingsScreen';
  const AdminAppSettingsScreen({super.key});

  @override
  AdminAppSettingsScreenState createState() => AdminAppSettingsScreenState();
}

class AdminAppSettingsScreenState extends State<AdminAppSettingsScreen> {
  bool notificationsEnabled = true;
  String selectedLanguage = 'العربية';
  String selectedTheme = 'خافت';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات التطبيق'),
        centerTitle: true,
        backgroundColor: AppTheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: const Text('تنبيهات'),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  notificationsEnabled = value;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedLanguage,
              decoration: InputDecoration(
                labelText: 'اللغة',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: AppTheme.black,
                    width: 1.5,
                  ),
                ),
              ),
              items: ['العربية', 'الإنجليزية']
                  .map((language) => DropdownMenuItem(
                        value: language,
                        child: Text(language),
                      ))
                  .toList(),
              onChanged: (value) => setState(() {
                selectedLanguage = value!;
              }),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedTheme,
              decoration: InputDecoration(
                labelText: 'ثيم',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: AppTheme.black,
                    width: 1.5,
                  ),
                ),
              ),
              items: ['خافت', 'داكن', 'فاتح']
                  .map((theme) => DropdownMenuItem(
                        value: theme,
                        child: Text(theme),
                      ))
                  .toList(),
              onChanged: (value) => setState(() {
                selectedTheme = value!;
              }),
            ),
          ],
        ),
      ),
    );
  }
}
