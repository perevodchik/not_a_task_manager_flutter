part of 'TaskBloc.dart';

@immutable
abstract class TaskState {
  final Map<DateTime, List<Task>> data;
  const TaskState(this.data);
}

@immutable
class StateTaskLoading extends TaskState {
  const StateTaskLoading(): super(const {});
}

@immutable
class StateTaskLoaded extends TaskState {
  final Map<DateTime, List<Task>> data;
  const StateTaskLoaded(this.data): super(data);
}