import 'package:evalution_note/app_theme.dart';
import 'package:flutter/material.dart';

class DeafaultElevetedBotton extends StatelessWidget {
  const DeafaultElevetedBotton(
      {super.key, required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        fixedSize: Size(MediaQuery.of(context).size.width, 60),
        backgroundColor: AppTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: AppTheme.black,
          fontSize: 20,
        ),
      ),
    );
  }
}
