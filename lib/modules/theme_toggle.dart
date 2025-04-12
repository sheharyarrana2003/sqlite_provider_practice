import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_practice_flutter/modules/theme_provider.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        print("Theme Build");
        return Switch(
          value: themeProvider.isDarkMode,
          onChanged: themeProvider.toggleTheme,
          activeColor: Colors.black,
          inactiveThumbColor: Colors.blue.shade700,
        );
      },
    );
  }
}