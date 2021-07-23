import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:not_a_task_manager/models/Task.dart';

class DayTaskListTile extends StatefulWidget {
  final Task task;
  final Function onDismiss;
  final Function onDeleteRequest;

  const DayTaskListTile(this.task, this.onDismiss, this.onDeleteRequest);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<DayTaskListTile> {
  DateFormat format = DateFormat("HH:mm");
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key("${widget.task.id}"),
      onDismissed: (d) => widget.onDismiss.call(d),
      confirmDismiss: (d) async => await widget.onDeleteRequest.call(),
      child: ListTile(
        title: Text(widget.task.description,
            style: TextStyle(
                fontFamily: "Arial",
                fontSize: 14
            )
        ),
        subtitle: Text(format.format(widget.task.time))
      )
    );
  }
}