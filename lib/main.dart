import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('tasksBox');
  runApp(const StudyPlannerApp());
}

class StudyPlannerApp extends StatelessWidget {
  const StudyPlannerApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Study Planner',
      theme: ThemeData(colorSchemeSeed: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Box box;
  final List<String> subjects = [
    'C Programming',
    'flutter',
    'Mathematics',
    'Network',
    'General',
  ];
  String selectedsubject = 'C Programming';
  List<Map<String, dynamic>> tasks = [
    {'title': 'Study C programming', 'completed': false},
    {'title': 'Practice flutter', 'completed': false},
  ];
  final TextEditingController controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    box = Hive.box('tasksBox');
    loadTasks();
  }

  void loadTasks() {
    final savedTasks = box.get('tasks');
    if (savedTasks != null) {
      tasks = List<Map<String, dynamic>>.from(
        (savedTasks as List).map((item) => Map<String, dynamic>.from(item)),
      );
    }
  }

  void savedTasks() {
    box.put('tasks', tasks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Study Planner')),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              setState(() {
                tasks.removeAt(index);
              });
              savedTasks();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Task Deleted')));
            },
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 20),
              color: Colors.red,
              child: const Icon(Icons.delete, color: Colors.white),
            ),

            child: Card(
              margin: const EdgeInsets.all(8),
              child: ListTile(
                leading: Checkbox(
                  value: tasks[index]['completed'],
                  onChanged: (value) {
                    setState(() {
                      tasks[index]['completed'] = value;
                    });
                    savedTasks();
                  },
                ),
                title: Text(
                  tasks[index]['title'],
                  style: TextStyle(
                    decoration: tasks[index]['completed']
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
                subtitle: Text(tasks[index]['subject'] ?? 'General'),
              ),
            ),
          );
        },
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
                    const SizedBox(height: 12,),
                    StatefulBuilder(builder: (context, setDialogState){
                      return DropdownButton<String>(
                        value: selectedsubject,
                        isExpanded: true,
                        items: subjects.map((subject){
                          return DropdownMenuItem(value: subject,
                          child: Text(subject)
                          );
                        }).toList(),
                        onChanged: (value){
                          setDialogState((){
                            selectedsubject = value!;
                          });
                        },
                      );
                    })
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
