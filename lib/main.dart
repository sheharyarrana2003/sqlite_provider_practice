import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_practice_flutter/Screens/splash.dart';
import 'package:sqlite_practice_flutter/modules/db_helper.dart';
import 'package:sqlite_practice_flutter/modules/db_provider.dart';
import 'package:sqlite_practice_flutter/modules/theme_provider.dart';

void main() {
  runApp(
    MultiProvider(providers: [
        ChangeNotifierProvider(create: (context)=>DBProvider(dbHelper: DBHelper.getInstance())),
      ChangeNotifierProvider(create: (context)=>ThemeProvider()),
    ],child: MyApp(),)
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (ctx, themeProvider, __) {
        return MaterialApp(
          title: 'SQL & Provider',
          themeMode: themeProvider.themeMode,
          debugShowCheckedModeBanner: false,
          home: const Splash(),
        );
      },
    );
  }
}
