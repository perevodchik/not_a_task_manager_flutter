import 'package:logger/logger.dart';
import 'package:not_a_task_manager/models/Task.dart';
import 'package:sqflite/sqflite.dart';
import 'package:not_a_task_manager/utils/Utils.dart';

class AppDatabase {
  static const int _version = 1;
  static Database? _database;
  static AppDatabase? _db;
  static Logger? _logger;
  static const String databaseName = "task.db";
  final String _descriptionField = "description";
  final String _idField = "id";
  final String _dateField = "date";
  final String _timeField = "time";
  final String _taskTable = "tasks";

  AppDatabase._() {
    _logger = Logger();
  }

  static Future<void> init() async {
    _db = AppDatabase._();
    await db?._initDb();
  }

  Future<void> _initDb() async {
    _database = await openDatabase(databaseName, version: _version, onCreate: (Database db, int version) async {
      _logger?.i("${DateTime.now().toUtc()}: onCreate begin");
      await db.execute(
          "CREATE TABLE $_taskTable ($_idField INTEGER PRIMARY KEY, $_descriptionField TEXT, $_dateField INTEGER, $_timeField INTEGER);");
      _logger?.i("${DateTime.now().toUtc()}: onCreate finish");
    });
  }

  Database? get database => _database;
  static AppDatabase? get db => _db;

  Future<void> removeTask(Task task) async {}

  Future<Task?> addTask(Task task) async {
    var r = await _database?.insert(_taskTable, {
      _descriptionField: task.description,
      _dateField: task.date.toDatabase(),
      _timeField: task.time.toDatabaseWithoutNormalize()
    });
    if(r == 0) return null;
    task.id = r;
    return task;
  }

  Future<List<Task>> getTasksByDay(DateTime date) async {
    var  tasks = <Task> [];
    var r  = await database?.query(_taskTable, where: "$_dateField = ?", whereArgs: [date.toDatabase()]);
    if(r != null) {
      for(var result in r) {
        var task = Task(
            int.tryParse("${result[_idField]}") ?? -1,
            "${result[_descriptionField]}",
            DateTime.fromMillisecondsSinceEpoch(int.tryParse("${result[_timeField]}") ?? 0),
            DateTime.fromMillisecondsSinceEpoch(int.tryParse("${result[_dateField]}") ?? 0)
        );
        print(task);
        tasks.add(task);
      }
    }
    return tasks;
  }

  Future<Map<DateTime, List<Task>>> getTasksByRange(DateTime from, DateTime to) async {
    var  tasks = <DateTime, List<Task>> {};
    var r = await database?.query(_taskTable, where: "$_dateField BETWEEN ? AND ?", whereArgs: [from.toDatabase() - 10000, to.toDatabase() + 10000]);
    if(r != null) {
      for(var result in r) {
        var task = Task(
            int.tryParse("${result[_idField]}") ?? -1,
            "${result[_descriptionField]}",
            DateTime.fromMillisecondsSinceEpoch(int.tryParse("${result[_timeField]}") ?? 0),
            DateTime.fromMillisecondsSinceEpoch(int.tryParse("${result[_dateField]}") ?? 0)
        );
        print(task);
        if(tasks[task.date] == null)
          tasks[task.date] = [];
        tasks[task.date]?.add(task);
      }
    }
    return tasks;
  }

  Future<int> getTasksCountByDay(DateTime date) async {
    var count = 0;
    var r = await database?.rawQuery("SELECT COUNT ($_idField) FROM $_taskTable WHERE $_dateField = ${date.toDatabase()}");
    for(var item in r ?? []) {
      for(var i in item.entries) {
        print("${i.key} => ${i.value}");
      }
    }
    if(r?.isNotEmpty ?? false)
      count = int.tryParse("${r!.first["count"]}") ?? 0;
    return count;
  }

  Future<int> deleteTask(int taskId) async {
    var r = await database?.delete(_taskTable, where: "$_idField = ?", whereArgs: [taskId]);
    print(r);
    return r ?? 0;
  }

}