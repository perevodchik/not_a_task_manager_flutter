import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:not_a_task_manager/screens/DayScreen.dart';
import 'package:not_a_task_manager/utils/Utils.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<Home> {
  DateTime selectedDate = DateTime.now().normalize();
  DateFormat format = DateFormat("dd-MM-yyyy");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: null
        ),
        body: ListView.separated(
            itemCount: 10,
            itemBuilder: (_, i) {
              var date = selectedDate.add(Duration(days: i));
              return GestureDetector(
                  onTap: () => Navigator.push(context, CupertinoPageRoute(builder: (_) => DayScreen(date))),
                  child: ListTile(
                      leading: Text("${i + 1}"),
                      title: Text(format.format(date))
                  )
              );
            },
            separatorBuilder: (_, i) => Container(height: 10)
        )
    );
  }
}