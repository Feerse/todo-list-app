import 'package:flutter/material.dart';
import 'package:todo_list/todo_list.dart';
import 'package:todo_list/settings.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.orange,
          accentColor: Colors.orangeAccent,
          brightness: Brightness.light,
          backgroundColor: const Color.fromARGB(255, 255, 245, 235),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 229, 194),
          title: const Row(
            children: [
              Icon(Icons.list_alt_sharp, size: 28),
              SizedBox(
                width: 4,
              ),
              Text(
                'To-Do List',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Bison',
                    fontSize: 28),
              ),
            ],
          ),
          actions: [
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const Settings();
                    }));
                  },
                );
              },
            ),
            const SizedBox(
              width: 16,
            )
          ],
        ),
        body: const ToDoList(),
      ),
    );
  }
}
