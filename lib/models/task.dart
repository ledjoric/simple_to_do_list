// PRIORITIES
// 0 for low priority
// 1 for medium priority
// 2 for high priority

const String tableTasks = 'tasks';

class TaskFields {
  static final List<String> values = [id, name, note, isCompleted, priority];

  static const String id = '_id';
  static const String name = 'name';
  static const String note = 'note';
  static const String isCompleted = 'isCompleted';
  static const String priority = 'priority';
}

class Task {
  final int? id;
  final String name;
  final String note;
  final bool isCompleted;
  final int priority;

  Task({
    this.id,
    required this.name,
    required this.note,
    required this.isCompleted,
    required this.priority,
  });

  Task copy({
    int? id,
    String? name,
    String? note,
    bool? isCompleted,
    int? priority,
  }) =>
      Task(
        id: id ?? this.id,
        name: name ?? this.name,
        note: note ?? this.note,
        isCompleted: isCompleted ?? this.isCompleted,
        priority: priority ?? this.priority,
      );

  static Task fromJson(Map<String, Object?> json) => Task(
        id: json[TaskFields.id] as int?,
        name: json[TaskFields.name] as String,
        note: json[TaskFields.note] as String,
        isCompleted: json[TaskFields.isCompleted] == 1,
        priority: json[TaskFields.priority] as int,
      );

  // FOR ADD OR UPDATE
  Map<String, Object?> toJson() => {
        TaskFields.id: id,
        TaskFields.name: name,
        TaskFields.note: note,
        TaskFields.isCompleted: isCompleted ? 1 : 0,
        TaskFields.priority: priority,
      };
}
