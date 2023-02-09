import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/db/tasks_database.dart';
import 'package:to_do_list/models/task.dart';
import 'package:to_do_list/providers/tasks.dart';
import 'package:to_do_list/screens/homescreen/add_new_task.dart';
import 'package:to_do_list/screens/homescreen/confirm_delete.dart';
import 'package:to_do_list/screens/homescreen/edit_task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  //const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> sortList = ['Default', 'Name', 'Priority'];
  bool isVisible = true;

  @override
  void initState() {
    super.initState();
    final tasksData = Provider.of<Tasks>(context, listen: false);
    tasksData.isCompleted = 0;
    tasksData.refreshTasks();
  }

  @override
  Widget build(BuildContext context) {
    final tasksData = Provider.of<Tasks>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          tasksData.isCompleted == 0 ? 'TO-DO LIST' : 'COMPLETED TASKS',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Tooltip(
            message:
                tasksData.isCompleted == 0 ? 'Completed Tasks' : 'To-do List',
            child: IconButton(
              icon: Icon(tasksData.isCompleted == 0
                  ? Icons.checklist_rounded
                  : Icons.list_rounded),
              iconSize: 30,
              onPressed: () {
                tasksData.isCompleted = tasksData.isCompleted == 0 ? 1 : 0;

                if (tasksData.sort == 0) {
                  tasksData.refreshTasks();
                } else if (tasksData.sort == 1) {
                  tasksData.sortByName();
                } else if (tasksData.sort == 2) {
                  tasksData.sortByPriority();
                }

                setState(() {
                  isVisible = !isVisible;
                });
              },
            ),
          ),
          Tooltip(
            message: 'Sort Tasks',
            child: PopupMenuButton(
              icon: const Icon(Icons.sort_rounded),
              iconSize: 30,
              itemBuilder: (context) {
                return sortList
                    .map((e) => PopupMenuItem(
                          value: e,
                          child: Text(e),
                        ))
                    .toList();
              },
              onSelected: (value) {
                if (value == 'Default') {
                  tasksData.refreshTasks();
                  tasksData.sort = 0;
                } else if (value == 'Name') {
                  tasksData.sortByName();
                  tasksData.sort = 1;
                } else if (value == 'Priority') {
                  tasksData.sortByPriority();
                  tasksData.sort = 2;
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: isVisible,
        child: FloatingActionButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const AddNewTask(),
            );
          },
          child: const Icon(Icons.add),
        ),
      ),
      body: ListView.builder(
        itemCount: tasksData.tasks.length,
        itemBuilder: (context, index) {
          final task = tasksData.tasks.elementAt(index);
          return Card(
            color: task.priority == 0
                ? Colors.blue[600]
                : task.priority == 1
                    ? Colors.amber[600]
                    : Colors.red[600],
            child: ListTile(
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (value) {
                  tasksData.completeTask(task: task.copy(isCompleted: value));
                },
              ),
              title: Text(task.name),
              subtitle: Text(task.note != '' ? task.note : 'Add note...'),
              trailing: Wrap(
                children: [
                  Tooltip(
                    message: 'Edit Task',
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => EditTask(
                            task: Task(
                                id: task.id,
                                name: task.name,
                                note: task.note,
                                isCompleted: task.isCompleted,
                                priority: task.priority),
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit_rounded),
                    ),
                  ),
                  Tooltip(
                    message: 'Delete Task',
                    child: IconButton(
                      onPressed: () {
                        // DELETE TASK
                        showDialog(
                          context: context,
                          builder: (context) =>
                              ConfirmDeleteTask(id: task.id ?? 0),
                        );
                      },
                      icon: const Icon(Icons.delete_rounded),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
