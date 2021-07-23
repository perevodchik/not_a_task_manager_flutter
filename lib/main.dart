import 'package:flutter/material.dart';
import 'package:not_a_task_manager/screens/Home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Not a Task Manager",
      theme: ThemeData(
        primarySwatch: Colors.amber,
        primaryColor: Colors.amber,
        primaryColorLight: Colors.amberAccent
      ),
      home: Home()
    );
  }
}
