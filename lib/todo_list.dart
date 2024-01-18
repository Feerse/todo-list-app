import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({super.key});

  @override
  createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  List<TaskModel> tasks = [];
  TextEditingController taskController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  // Load tasks dari local storage
  Future<void> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      tasks = (prefs.getStringList('tasks') ?? []).map((taskString) {
        final taskData = taskString.split('|');
        return TaskModel(taskData[0], taskData[1] == 'true');
      }).toList();
    });
  }

  // Save tasks ke local storage
  Future<void> saveTasks() async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setStringList(
        'tasks', tasks.map((task) => '${task.text}|${task.isDone}').toList());
  }

  // Fungsi menekan tombol 'Add'
  void addTask() {
    String newTask = taskController.text;

    if (newTask.isNotEmpty) {
      setState(() {
        tasks.add(TaskModel(newTask, false));
        taskController.clear();
        saveTasks();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tugas berhasil ditambahkan: "$newTask"'),
        ),
      );
    }
  }

  // Fungsi toggle checkbox
  void toggleTask(int index) {
    setState(() {
      tasks[index].isDone = !tasks[index].isDone;
      saveTasks();
    });
  }

  // Hapus task
  void deleteTask(int index) {
    final deletedTask = tasks[index];

    setState(() {
      tasks.removeAt(index);
      saveTasks();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Tugas dihapus'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              tasks.insert(index, deletedTask);
              saveTasks();
            });
          },
          textColor: Theme.of(context).brightness == Brightness.dark
              ? const Color.fromARGB(255, 125, 75, 0)
              : Colors.orangeAccent,
        ),
      ),
    );
  }

  void clearCache() {
    setState(() {
      tasks.clear();
      saveTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Checkbox(
                  value: tasks[index].isDone,
                  onChanged: (bool? value) {
                    toggleTask(index);
                  },
                ),
                title: Text(
                  tasks[index].text,
                  style: tasks[index].isDone
                      ? const TextStyle(decoration: TextDecoration.lineThrough)
                      : null,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    deleteTask(index);
                  },
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: taskController,
                  decoration: const InputDecoration(
                    hintText: 'Tambahkan Tugas...',
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: addTask,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TaskModel {
  final String text;
  bool isDone;

  TaskModel(this.text, this.isDone);
}
