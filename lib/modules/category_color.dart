import 'dart:ui';

import 'package:flutter/material.dart';

Color getCategoryColor(String category,{bool isSelected=false}) {
  if (isSelected) {
       return Colors.grey.shade400;
       }
  switch (category) {
    case "Work": return Colors.blue.shade400;
    case "Personal": return Colors.green.shade400;
    case "Health": return Colors.red.shade400;
    case "Family": return Colors.orange.shade400;
    case "Finance": return Colors.purple.shade400;
    case "Shopping": return Colors.teal.shade400;
    case "Education": return Colors.amber.shade400;
    case "Travel": return Colors.cyan.shade400;
    case "Goals": return Colors.pink.shade400;
    default: return Colors.grey.shade400;
  }
}
