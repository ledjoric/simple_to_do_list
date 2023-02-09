import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/models/task.dart';
import 'package:intl/intl.dart';

import '../../providers/tasks.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final nameController = TextEditingController();
  final detailsController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  late int priority;
  late String priorityText;

  @override
  void initState() {
    priority = 0;
    priorityText = 'Low';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tasksData = Provider.of<Tasks>(context);

    return AlertDialog(
      title: const Text(
        'Add new task',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        TextButton(
          // CLOSE BUTTON
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        FilledButton.tonal(
          // ADD BUTTON
          onPressed: () {
            if (formKey.currentState!.validate()) {
              tasksData.addTask(
                task: Task(
                    name: nameController.text,
                    note: detailsController.text,
                    isCompleted: false,
                    priority: priority),
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
      content: Container(
        constraints: const BoxConstraints(minWidth: 2000),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Task Name',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                TextFormField(
                  controller: nameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter some text'
                      : null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter task name',
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Note',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                TextFormField(
                  controller: detailsController,
                  // autovalidateMode: AutovalidateMode.onUserInteraction,
                  // validator: (value) => value == null || value.isEmpty
                  //     ? 'Please enter some text'
                  //     : null,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Enter task details',
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    const Text(
                      'Priority',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 25,
                      height: 25,
                      child: FilledButton(
                        // LOW
                        onPressed: () {
                          setState(() {
                            priority = 0;
                            priorityText = 'Low';
                          });
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          side: BorderSide(
                              color: priority == 0
                                  ? Colors.blue[800]!
                                  : Colors.blue[600]!,
                              width: 5),
                        ),
                        child: null,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 25,
                      height: 25,
                      child: FilledButton(
                        // MEDIUMM
                        onPressed: () {
                          setState(() {
                            priority = 1;
                            priorityText = 'Medium';
                          });
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.amber[600],
                          side: BorderSide(
                              color: priority == 1
                                  ? Colors.amber[800]!
                                  : Colors.amber[600]!,
                              width: 5),
                        ),
                        child: null,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 25,
                      height: 25,
                      child: FilledButton(
                        // HIGH
                        onPressed: () {
                          setState(() {
                            priority = 2;
                            priorityText = 'High';
                          });
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red[600],
                          side: BorderSide(
                              color: priority == 2
                                  ? Colors.red[800]!
                                  : Colors.red[600]!,
                              width: 5),
                        ),
                        child: null,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(priorityText),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
