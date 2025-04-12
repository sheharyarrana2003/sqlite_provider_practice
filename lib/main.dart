import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqlite_practice_flutter/Screens/splash.dart';
import 'package:sqlite_practice_flutter/modules/db_helper.dart';
import 'package:sqlite_practice_flutter/modules/db_provider.dart';

void main() {
  runApp(ChangeNotifierProvider(create: (context)=>DBProvider(dbHelper: DBHelper.getInstance()),
  child: MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    DBHelper db=DBHelper.getInstance();
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Splash(),
    );
  }
}
