import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do_list/models/task.dart';
import 'package:intl/intl.dart';

import '../../providers/tasks.dart';

class EditTask extends StatefulWidget {
  final Task task;
  const EditTask({super.key, required this.task});

  @override
  State<EditTask> createState() => _EditTaskState();
}

class _EditTaskState extends State<EditTask> {
  final nameController = TextEditingController();
  final detailsController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  late DateTime selectedDate;
  late String selectedTime;

  late int priority;
  late String priorityText;

  @override
  void initState() {
    // final tasksData = Provider.of<Tasks>(context, listen: false);
    // tasksData.readTask(widget.task.id);

    nameController.text = widget.task.name;
    detailsController.text = widget.task.note;

    priority = widget.task.priority;
    priorityText = priority == 0
        ? 'Low'
        : priority == 1
            ? 'Medium'
            : 'High';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final tasksData = Provider.of<Tasks>(context);

    return AlertDialog(
      title: const Text(
        'Edit task',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        TextButton(
          // CLOSE BUTTON
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
        FilledButton.tonal(
          // UPDATE BUTTON
          onPressed: () {
            if (formKey.currentState!.validate()) {
              tasksData.updateTask(
                task: Task(
                    id: widget.task.id,
                    name: nameController.text,
                    note: detailsController.text,
                    isCompleted: widget.task.isCompleted,
                    priority: priority),
              );
              Navigator.pop(context);
            }
          },
          child: const Text('Update'),
        )
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter some text'
                      : null,
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
                        // MEDIUM
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
