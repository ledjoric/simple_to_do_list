import 'package:flutter/material.dart';
import 'package:to_do_list/db/tasks_database.dart';

import '../models/task.dart';

class Tasks extends ChangeNotifier {
  List<Task> _tasks = [];
  Task _task = Task(name: '', note: '', isCompleted: false, priority: 0);

  int sort = 0;
  int isCompleted = 0;

  Future<void> addTask({required Task task}) async {
    await TasksDatabase.instance.create(task);

    refreshBySort();
    notifyListeners();
  }

  Future<void> updateTask({required Task task}) async {
    await TasksDatabase.instance.update(task);

    refreshBySort();
    notifyListeners();
  }

  Future<void> deleteTask({required int id}) async {
    await TasksDatabase.instance.delete(id);

    refreshBySort();
    notifyListeners();
  }

  void completeTask({required Task task}) async {
    await TasksDatabase.instance.update(task);

    refreshBySort();
    notifyListeners();
  }

  // READ TASKS

  Future<void> readTask(int id) async {
    final data = await TasksDatabase.instance.readTask(id);
    _task = data;
    notifyListeners();
  }

  void refreshTasks() async { // SORT BY DEFAULT
    final data = await TasksDatabase.instance.readAllTasks(isCompleted);
    _tasks = data;
    notifyListeners();
  }

  void sortByName() async { // SORT BY NAME
    final data = await TasksDatabase.instance.sortByName(isCompleted);
    _tasks = data;
    notifyListeners();
  }

  void sortByPriority() async { // SORT BY PRIORITY
    final data = await TasksDatabase.instance.sortByPriority(isCompleted);
    _tasks = data;
    notifyListeners();
  }

  void refreshBySort() {
    if (sort == 0) {
      refreshTasks();
    } else if (sort == 1) {
      sortByName();
    } else if (sort == 2) {
      sortByPriority();
    }
  }

  List<Task> get tasks => _tasks;
  Task get task => _task;
}
