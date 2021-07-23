import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:not_a_task_manager/cubits/task/TaskBloc.dart';
import 'package:not_a_task_manager/models/Task.dart';
import 'package:not_a_task_manager/repository/AppDatabase.dart';
import 'package:not_a_task_manager/utils/Utils.dart';
import 'package:not_a_task_manager/widgets/CustomTimePicker.dart';

class DialogCreateTask extends StatefulWidget {
  final DateTime date;
  const DialogCreateTask(this.date);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<DialogCreateTask> {
  late TextEditingController description;
  late DateTime selectedTime;
  late AppDatabase? appDatabase;
  DateFormat timeFormat = DateFormat("HH:mm");
  List<DateTime> availableTime = [];

  @override
  void initState() {
    selectedTime = widget.date.normalize();
    for(var c = 0; c < 48; c++) {
      availableTime.add(selectedTime.add(Duration(minutes: 30 * c)));
    }
    description = TextEditingController();
    appDatabase = AppDatabase.db;
    super.initState();
  }

  @override
  void dispose() {
    description.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      width: MediaQuery.of(context).size.width * .8,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
          children: [
            Text("Новая задача", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            SizedBox(height: 10),
            TextField(
              controller: description,
              maxLines: 5,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Описание задачи"
              )
            ),
            Material(
              color: Colors.white,
              child: InkWell(
                splashColor: Colors.white,
                highlightColor: Colors.white,
                child: ListTile(
                  title: Text("Время задачи"),
                  subtitle: Text(timeFormat.format(selectedTime)),
                  trailing: Icon(Icons.access_time),
                  contentPadding: EdgeInsets.zero
                ),
                onTap: () async {
                  var time = await DatePicker.showPicker(context, pickerModel: CustomTimePicker(currentTime: selectedTime));
                  print("select $time");
                  if(time != null)
                    setState(() => selectedTime = time);
                }
              )
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 48,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: TextButton(
                          child: Text("Назад", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                          onPressed: () => Navigator.pop(context)
                      )
                    ),
                    Expanded(
                      child: TextButton(
                          child: Text("Сохранить", style: TextStyle(color: Colors.amber, fontSize: 14, fontWeight: FontWeight.bold)),
                          onPressed: () async {
                            try {
                              progressDialog();
                              var _task = Task(-1, description.text, selectedTime, widget.date);
                              var task = await appDatabase?.addTask(_task);
                              Navigator.pop(context);
                              if(task == null) return;
                              BlocProvider.of<TaskBloc>(context).add(EventTaskAdded(widget.date, [task]));
                            } catch(e) {
                              print("$e");
                            } finally {
                              Navigator.pop(context);
                            }
                          }
                      )
                    )
                  ]
              )
            )
          ]
      )
    );
  }

}