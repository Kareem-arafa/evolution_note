import 'package:evalution_note/app_theme.dart';
import 'package:flutter/material.dart';

class DeafultListTile extends StatelessWidget {
  const DeafultListTile({super.key, this.onEditPressed, this.onRemovePressed, required this.label});
  final void Function()? onEditPressed;
  final void Function()? onRemovePressed;
  final String label;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title:  Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              Icons.edit,
              color: AppTheme.grey,
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(
              Icons.delete,
              color: AppTheme.red,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
