import 'package:not_a_task_manager/models/Task.dart';

class TaskRepository {

  Future<void> removeTask(Task task) async {}
  Future<Task> addTask(Task task) async { return task; }
  Future<List<Task>> getTasksByDay(DateTime date) async { return [];}
  Future<int> getTasksCountByDay(DateTime date) async { return 0; }

}