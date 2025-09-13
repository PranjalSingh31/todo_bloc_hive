part of 'task_cubit.dart';

@immutable
class TaskState {
  final List<Task> tasks;

  const TaskState({required this.tasks});

  factory TaskState.initial() => const TaskState(tasks: []);

  TaskState copyWith({List<Task>? tasks}) {
    return TaskState(tasks: tasks ?? this.tasks);
  }
}
