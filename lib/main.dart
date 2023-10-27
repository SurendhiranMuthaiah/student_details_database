import 'package:flutter/material.dart';
import 'package:sudent_details_database/database_helper.dart';
import 'package:sudent_details_database/student_list_screen.dart';

final dbHelper=DataBaseHelper();

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await dbHelper.initialization();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:StudentListScreen(),
    );
  }
}
