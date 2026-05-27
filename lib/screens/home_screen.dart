import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/app_data.dart';
import '../services/hive_service.dart';
import '../widgets/progress_card.dart';
import '../widgets/task_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box box;
  late HiveService hiveService;
  String selectedsubject = 'C Programming';
  List<Map<String, dynamic>> tasks = [
    {'title': 'Study C programming', 'subject': 'General', 'completed': false},
    {'title': 'Practice flutter', 'subject': 'General', 'completed': false},
  ];
  final TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    box = Hive.box('tasksBox');
    hiveService = HiveService(box);
    loadTasks();
  }

  void loadTasks() {
    final loadedTasks = hiveService.loadTasks();
    if (loadedTasks.isNotEmpty) {
      tasks = loadedTasks;
    }
  }

  void savedTasks() {
    hiveService.savedTasks(tasks);
  }

  @override
  Widget build(BuildContext context) {
    int completedTasks = tasks.where((task) {
      return task['completed'] == true;
    }).length;
    int totalTasks = tasks.length;
    double progress = totalTasks == 0 ? 0 : completedTasks / totalTasks;
    int progressPercent = (progress * 100).round();

    return Scaffold(
      appBar: AppBar(title: const Text('Study Planner')),
      body: Column(
        children: [
          ProgressCard(
            completedTasks: completedTasks,
            totalTasks: totalTasks,
            progress: progress,
            progressPercent: progressPercent,
          ),

          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskTile(
                  task: tasks[index],
                  onChanged: (value) {
                    setState(() {
                      tasks[index]['completed'] = value;
                    });

                    savedTasks();
                  },
                  onDismissed: () {
                    setState(() {
                      tasks.removeAt(index);
                    });

                    savedTasks();
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add Task'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: controller,
                      decoration: const InputDecoration(hintText: "enter task"),
                    ),
                    const SizedBox(height: 12),
                    StatefulBuilder(
                      builder: (context, setDialogState) {
                        return DropdownButton<String>(
                          value: selectedsubject,
                          isExpanded: true,
                          items: subjects.map((subject) {
                            return DropdownMenuItem(
                              value: subject,
                              child: Text(subject),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setDialogState(() {
                              selectedsubject = value!;
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),

                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (controller.text.isNotEmpty) {
                        setState(() {
                          tasks.add({
                            'title': controller.text,
                            'subject': selectedsubject,
                            'completed': false,
                          });
                        });
                        savedTasks();

                        controller.clear();

                        Navigator.pop(context);
                      }
                    },
                    child: const Text("add"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
