import 'package:evalution_note/app_theme.dart';
import 'package:flutter/material.dart';

class DeafaultTextFormField extends StatefulWidget {
  const DeafaultTextFormField({
    super.key,
    this.controller,
    this.hintText,
    this.maxLines = 1,
    this.validator,
    this.intialValue,
    this.onChanged,
    this.label,
    this.isPassword = false,
    this.textInputType,
  });
  final TextEditingController? controller;
  final String? hintText;
  final int? maxLines;
  final String? Function(String?)? validator;
  final String? intialValue;
  final Function(String)? onChanged;
  final bool isPassword;
  final String? label;
  final TextInputType? textInputType;

  @override
  State<DeafaultTextFormField> createState() => _DeafaultTextFormFieldState();
}

class _DeafaultTextFormFieldState extends State<DeafaultTextFormField> {
  bool isObscure = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: AppTheme.black, // Grey border color
            width: 1.5, // Border width
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: AppTheme.black, // Grey border when enabled
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: AppTheme.black, // Primary color border when focused
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(
            color: AppTheme.red, // Red border on error
            width: 1.5,
          ),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
                onPressed: () {
                  isObscure = !isObscure;
                  setState(() {});
                },
                icon: isObscure ? const Icon(Icons.visibility_off_outlined) : const Icon(Icons.visibility_outlined),
              )
            : null,
      ),
      keyboardType: widget.textInputType,
      onChanged: widget.onChanged,
      maxLines: widget.maxLines,
      validator: widget.validator,
      initialValue: widget.intialValue,
      style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: AppTheme.black,
            fontWeight: FontWeight.w400,
          ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: isObscure,
    );
  }
}
