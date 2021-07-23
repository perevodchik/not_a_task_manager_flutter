import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:not_a_task_manager/models/Task.dart';

part 'TaskState.dart';
part 'TaskEvent.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  TaskBloc(): super(StateTaskLoading());

  @override
  Stream<TaskState> mapEventToState(TaskEvent event) async* {
    if(event is EventTaskLoading) {
      yield StateTaskLoading();
    }
    else if(event is EventTaskLoaded){
      var newState = Map.of(state.data);
      newState[event.date] = event.data;
      yield StateTaskLoaded(newState);
    }
    else if(event is EventTaskAdded) {
      var newState = Map.of(state.data);
      List<Task> tasks = [...state.data[event.date] ?? [], ...event.data];
      newState[event.date] = tasks;
      tasks.sort((t0, t1) => t0.time.millisecondsSinceEpoch.compareTo(t1.time.millisecondsSinceEpoch));
      yield StateTaskLoaded(newState);
    }
    else if(event is EventTaskRemoved) {
      var newState = Map.of(state.data);
      List<Task> tasks = [...state.data[event.date] ?? []];
      var idsToRemove = event.data.map<int>((t) => t.id!).toList();
      tasks.removeWhere((t) => idsToRemove.contains(t.id));
      newState[event.date] = tasks;
      tasks.sort((t0, t1) => t0.time.millisecondsSinceEpoch.compareTo(t1.time.millisecondsSinceEpoch));
      yield StateTaskLoaded(newState);
    }
  }

}