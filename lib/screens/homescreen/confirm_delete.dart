import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

import '../../providers/tasks.dart';

class ConfirmDeleteTask extends StatefulWidget {
  final int id;
  const ConfirmDeleteTask({super.key, required this.id});

  @override
  State<ConfirmDeleteTask> createState() => ConfirmDeleteTaskState();
}

class ConfirmDeleteTaskState extends State<ConfirmDeleteTask> {
  @override
  Widget build(BuildContext context) {
    final tasksData = Provider.of<Tasks>(context);

    return AlertDialog(
      title: const Text(
        'Delete this task?',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      actions: [
        TextButton(
          // CLOSE BUTTON
          onPressed: () => Navigator.pop(context),
          child: const Text('No'),
        ),
        FilledButton.tonal(
          // ADD BUTTON
          onPressed: () {
            tasksData.deleteTask(id: widget.id);
            Navigator.pop(context);
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
