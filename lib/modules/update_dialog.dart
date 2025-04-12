import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cutom_text_field.dart';
import 'db_provider.dart';

class UpdateNoteDialog extends StatelessWidget {
  final int id;
  final String category;
  final TextEditingController noteController;
  final TextEditingController desController;
  final GlobalKey<FormState> formKey;
  final String Function() getCurrentTime;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color textColor;
  final Color color;

  const UpdateNoteDialog({
    required this.id,
    required this.category,
    required this.noteController,
    required this.desController,
    required this.formKey,
    required this.getCurrentTime,
    required this.width,
    required this.height,
    required this.backgroundColor,
    required this.textColor,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: backgroundColor,
      title:  Text("Update Note", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color:textColor)),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              label: "Note",
              hint: "Enter note",
              controller: noteController,
              isPass: false,
              color: color,
              validator: (value) => value?.isEmpty ?? true ? "Please enter note" : null,
            ),
            SizedBox(height: 10),
            CustomTextField(
              label: "Description",
              hint: "Enter description",
              controller: desController,
              color: color,
              isPass: false,
              validator: (value) => value?.isEmpty ?? true ? "Please enter description" : null,
            ),
          ],
        ),
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade600,
              padding: EdgeInsets.symmetric(vertical: height * 0.01, horizontal: width * 0.04),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4
          ),
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              print("Update");
              await context.read<DBProvider>().updateNote(
                id,
                category,
                noteController.text.trim(),
                desController.text.trim(),
                getCurrentTime(),
              );
              Navigator.pop(context);
            }
          },
          child: const Text("Update", style: TextStyle(color: Colors.white, fontSize: 15)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              padding: EdgeInsets.symmetric(vertical: height * 0.01, horizontal: width * 0.04),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 4
          ),
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 15)),
        ),
      ],
    );
  }
}
