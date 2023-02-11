import 'package:flutter/material.dart';
import 'package:to_do_list/db/tasks_database.dart';

import '../models/task.dart';

class Tasks extends ChangeNotifier {
  List<Task> _tasks = [];
  Task _task = Task(name: '', note: '', isCompleted: false, priority: 0);

  int sort = 0;
  int isCompleted = 0;

  static const orderByDefault = '${TaskFields.id} ASC';
  static const orderByname = '${TaskFields.name} ASC';
  static const orderByPriority = '${TaskFields.priority} DESC';
  static const orderByNamePriority =
      '${TaskFields.name} ASC, ${TaskFields.priority} DESC';
  String orderBy = '';

  Future<void> addTask({required Task task}) async {
    await TasksDatabase.instance.create(task);

    refreshTasks();
    notifyListeners();
  }

  Future<void> updateTask({required Task task}) async {
    await TasksDatabase.instance.update(task);

    refreshTasks();
    notifyListeners();
  }

  Future<void> deleteTask({required int id}) async {
    await TasksDatabase.instance.delete(id);

    refreshTasks();
    notifyListeners();
  }

  void completeTask({required Task task}) async {
    await TasksDatabase.instance.update(task);

    refreshTasks();
    notifyListeners();
  }

  // READ TASKS

  Future<void> readTask(int id) async {
    final data = await TasksDatabase.instance.readTask(id);
    _task = data;
    notifyListeners();
  }

  void refreshTasks() async {
    setOrderBy();
    final data =
        await TasksDatabase.instance.readAllTasks(orderBy, isCompleted);
    _tasks = data;
    notifyListeners();
  }

  void setOrderBy() {
    if (sort == 0) {
      orderBy = orderByDefault;
    } else if (sort == 1) {
      orderBy = orderByname;
    } else if (sort == 2) {
      orderBy = orderByPriority;
    } else if (sort == 3) {
      orderBy = orderByNamePriority;
    }
  }

  List<Task> get tasks => _tasks;
  Task get task => _task;
}
