import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqlite_practice_flutter/modules/category_color.dart';

import '../modules/db_helper.dart';

class NoteItem extends StatelessWidget {
  final Map<String, dynamic> note;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onLongPress;
  final VoidCallback onDelete;

  const NoteItem({
    required this.note,
    required this.width,
    required this.height,
    required this.backgroundColor,
    required this.textColor,
    required this.onLongPress,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final category = note[DBHelper.NOTE_COLUMN_CATERGORY] ?? "Other";

    return GestureDetector(
      onLongPress: onLongPress,
      child: Card(
        color: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 2,
        margin: EdgeInsets.symmetric(vertical: height * 0.01),
        child: Padding(
          padding: EdgeInsets.all(width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                note[DBHelper.NOTE_COLUMN_TITLE],
                style: TextStyle(
                  fontSize: width * 0.05,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              SizedBox(height: height * 0.01),
              Text(
                note[DBHelper.NOTE_COLUMN_DESC],
                style: TextStyle(
                  color: textColor.withOpacity(0.8),
                  fontSize: width * 0.04,
                ),
              ),
              SizedBox(height: height * 0.015),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.03, vertical: height * 0.008),
                    decoration: BoxDecoration(
                      color: getCategoryColor(category),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.04,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        note[DBHelper.NOTE_COLUMN_TIME],
                        style: TextStyle(
                          color: textColor.withOpacity(0.6),
                          fontSize: width * 0.035,
                        ),
                      ),
                      IconButton(
                        onPressed: onDelete,
                        icon: Icon(Icons.delete, color: Colors.red.shade400),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}