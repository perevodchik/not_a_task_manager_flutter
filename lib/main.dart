import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:not_a_task_manager/cubits/task/TaskBloc.dart';
import 'package:not_a_task_manager/repository/AppDatabase.dart';
import 'package:not_a_task_manager/screens/Home.dart';
import 'package:not_a_task_manager/utils/Utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppDatabase.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskBloc>(
          create: (BuildContext context) => TaskBloc()
        )
      ],
      child: MaterialApp(
          title: "Not a Task Manager",
          navigatorKey: appKey,
          theme: ThemeData(
              primarySwatch: Colors.amber,
              primaryColor: Colors.amber,
              primaryColorLight: Colors.amberAccent
          ),
          home: Home()
      )
    );
  }
}
