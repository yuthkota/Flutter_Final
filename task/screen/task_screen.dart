import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task_model.dart';
import 'task_form.dart';

class TaskScreen extends StatefulWidget {
  final String day;

  const TaskScreen({super.key, required this.day});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  void loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? taskTitles = prefs.getStringList('${widget.day}_taskTitles');
    List<String>? taskCategories =
        prefs.getStringList('${widget.day}_taskCategories');
    List<String>? taskStatuses =
        prefs.getStringList('${widget.day}_taskStatuses');
    List<String>? taskPriorities =
        prefs.getStringList('${widget.day}_taskPriorities');

    if (taskTitles != null &&
        taskCategories != null &&
        taskStatuses != null &&
        taskPriorities != null) {
      setState(() {
        tasks = List.generate(
          taskTitles.length,
          (index) => Task(
            id: DateTime.now().toString(),
            title: taskTitles[index],
            category: taskCategories[index],
            isDone: taskStatuses[index] == 'true',
            priority: taskPriorities[index],
          ),
        );
      });
    }
  }

  void saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> taskTitles = tasks.map((task) => task.title).toList();
    List<String> taskCategories = tasks.map((task) => task.category).toList();
    List<String> taskStatuses =
        tasks.map((task) => task.isDone.toString()).toList();
    List<String> taskPriorities = tasks.map((task) => task.priority).toList();

    await prefs.setStringList('${widget.day}_taskTitles', taskTitles);
    await prefs.setStringList('${widget.day}_taskCategories', taskCategories);
    await prefs.setStringList('${widget.day}_taskStatuses', taskStatuses);
    await prefs.setStringList('${widget.day}_taskPriorities', taskPriorities);
  }

  void addTask(String title, String category, String priority, Task? task) {
    setState(() {
      if (task == null) {
        tasks.add(Task(
          id: DateTime.now().toString(),
          title: title,
          category: category,
          isDone: false,
          priority: priority,
        ));
      } else {
        task.title = title;
        task.category = category;
        task.priority = priority;
      }
    });
    saveTasks();
  }

  void toggleTask(Task task) {
    setState(() {
      task.isDone = !task.isDone;
    });
    saveTasks();
  }

  void deleteTask(Task task) {
    setState(() {
      tasks.remove(task);
    });
    saveTasks();
  }

  void showAddTaskDialog([Task? task]) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(task == null ? 'Add Task' : 'Edit Task'),
          content: TaskForm(onSave: addTask, task: task),
        );
      },
    );
  }

  double getTaskProgress() {
    if (tasks.isEmpty) return 0.0;
    int completedTasks = tasks.where((task) => task.isDone).length;
    return completedTasks / tasks.length;
  }

  @override
  Widget build(BuildContext context) {
    double progress = getTaskProgress();

    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks for ${widget.day}'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: [
                  Text(
                    'Task Progress: ${(progress * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: progress,
                    minHeight: 10,
                    backgroundColor: Colors.grey[300],
                    color: Colors.blueAccent,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          decoration:
                              task.isDone ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      subtitle: Text(
                          'Category: ${task.category}\nPriority: ${task.priority}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showAddTaskDialog(task);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              deleteTask(task);
                            },
                          ),
                          Checkbox(
                            value: task.isDone,
                            onChanged: (value) {
                              toggleTask(task);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddTaskDialog,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
      ),
    );
  }
}
