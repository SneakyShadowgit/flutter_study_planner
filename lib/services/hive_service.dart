import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  final Box box;

  HiveService(this.box);

  List<Map<String, dynamic>> loadTasks() {
    final savedTasks = box.get('tasks');
    if (savedTasks != null) {
      // tasks = List<Map<String, dynamic>>.from(
      //   (savedTasks as List).map((item) => Map<String, dynamic>.from(item)),
      // );
      return List<Map<String, dynamic>>.from(
        (savedTasks as List).map((item) {
          final task = Map<String, dynamic>.from(item);

          task.putIfAbsent('subject', () => 'General');

          return task;
        }),
      );
    }
    return [];
  }

  void savedTasks(List<Map<String, dynamic>> tasks) {
    box.put('tasks', tasks);
  }
}
