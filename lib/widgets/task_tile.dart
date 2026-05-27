import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final Map<String, dynamic> task;
  final ValueChanged<bool?> onChanged;
  final VoidCallback onDismissed;

  const TaskTile({
    super.key,
    required this.task,
    required this.onChanged,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),

      direction: DismissDirection.endToStart,

      onDismissed: (direction) {
        onDismissed();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task deleted')),
        );
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
            value: task['completed'],
            onChanged: onChanged,
          ),

          title: Text(
            task['title'],
            style: TextStyle(
              decoration: task['completed']
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
            ),
          ),

          subtitle: Text(task['subject']),
        ),
      ),
    );
  }
}
