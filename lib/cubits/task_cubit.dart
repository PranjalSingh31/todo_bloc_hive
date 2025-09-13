import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';

import '../models/task.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  final Box<Task> _taskBox = Hive.box<Task>('tasks');
  final _uuid = const Uuid();

  TaskCubit() : super(TaskState.initial());

  void loadTasks() {
    final tasks = _taskBox.values.toList();
    tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    emit(state.copyWith(tasks: tasks));
  }

  Future<void> addTask(String title) async {
    final task = Task(id: _uuid.v4(), title: title.trim());
    await _taskBox.put(task.id, task);
    final updated = [task, ...state.tasks];
    emit(state.copyWith(tasks: updated));
  }

  Future<void> toggleComplete(Task task) async {
    task.isCompleted = !task.isCompleted;
    await task.save();
    final updated = state.tasks.map((t) => t.id == task.id ? task : t).toList();
    emit(state.copyWith(tasks: updated));
  }

  Future<void> deleteTask(Task task) async {
    await _taskBox.delete(task.id);
    final updated = state.tasks.where((t) => t.id != task.id).toList();
    emit(state.copyWith(tasks: updated));
  }
}
