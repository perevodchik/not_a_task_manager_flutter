part of 'TaskBloc.dart';

@immutable
abstract class TaskEvent {
  final DateTime date;
  final List<Task> data;
  const TaskEvent(this.date, this.data);
}

@immutable
class EventTaskLoading extends TaskEvent {
  EventTaskLoading(): super(DateTime.now(), []);
}

@immutable
class EventTaskLoaded extends TaskEvent {
  final DateTime date;
  final List<Task> data;
  const EventTaskLoaded(this.date, this.data): super(date, data);
}

@immutable
class EventTaskLoadedMultipleDate extends TaskEvent {
  final DateTime date;
  final Map<DateTime, List<Task>> mapData;
  const EventTaskLoadedMultipleDate(this.date, this.mapData): super(date, const []);
}

@immutable
class EventTaskAdded extends TaskEvent {
  final DateTime date;
  final List<Task> data;
  const EventTaskAdded(this.date, this.data): super(date,  data);
}

@immutable
class EventTaskRemoved extends TaskEvent {
  final DateTime date;
  final List<Task> data;
  const EventTaskRemoved(this.date, this.data): super(date, data);
}