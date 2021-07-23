import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:not_a_task_manager/cubits/task/TaskBloc.dart';
import 'package:not_a_task_manager/models/Task.dart';
import 'package:not_a_task_manager/repository/AppDatabase.dart';
import 'package:not_a_task_manager/utils/Utils.dart';
import 'package:not_a_task_manager/widgets/DayTaskListTile.dart';
import 'package:not_a_task_manager/widgets/dialogs/DialogConfirmDelete.dart';
import 'package:not_a_task_manager/widgets/dialogs/DialogCreateTask.dart';

class DayScreen extends StatefulWidget {
  final DateTime date;
  const DayScreen(this.date);

  @override
  State<StatefulWidget> createState() => _State();
}

class _State extends State<DayScreen> {
  DateFormat format = DateFormat("dd.MM.yyyy");
  late DateTime date;
  late Task task;

  @override
  void initState() {
    date = widget.date;
    task = Task(1, "task 1", date, date);
    AppDatabase.db?.getTasksByDay(date).then((tasks) {
      BlocProvider.of<TaskBloc>(appKey.currentContext!).add(EventTaskLoaded(date, tasks));
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          leading: null,
          title: Text(format.format(date))
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => showAppDialog(DialogCreateTask(date))
        ),
        body: BlocBuilder<TaskBloc, TaskState>(
          builder: (_, state) {
            if(state is StateTaskLoading) return Center(child: CircularProgressIndicator());
            return ListView.separated(
                itemCount: state.data[date]?.length ?? 0,
                itemBuilder: (_, i) {
                  var task = state.data[date]?[i];
                  return DayTaskListTile(task!, (DismissDirection direction) {
                    BlocProvider.of<TaskBloc>(context).add(EventTaskRemoved(date, [task]));
                  }, () async {
                    var r = await showAppDialog(DialogConfirmDelete());
                    var isDelete = (await AppDatabase.db?.deleteTask(task.id!) ?? 0) > 0;
                    return isDelete;
                  });
                },
                separatorBuilder: (_, i) => SizedBox(height: 8)
            );
          }
        )
    );
  }

}