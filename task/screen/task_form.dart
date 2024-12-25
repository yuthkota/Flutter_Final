import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TaskForm extends StatefulWidget {
  final Function(String, String, String, Task?) onSave;
  final Task? task;

  const TaskForm({super.key, required this.onSave, this.task});

  @override
  _TaskFormState createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String category = 'Work';
  String priority = 'Must Do';

  final List<String> categories = ['Work', 'Personal', 'Study', 'Health', 'Other'];
  final List<String> priorities = ['Must Do', 'Can Do Later'];

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      title = widget.task!.title;
      category = widget.task!.category;
      priority = widget.task!.priority;
    }
  }

  void submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(title, category, priority, widget.task);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            initialValue: title,
            decoration: const InputDecoration(hintText: 'Task Title'),
            onChanged: (value) => title = value,
            validator: (value) => value!.isEmpty ? 'Please enter a task title' : null,
          ),
          DropdownButtonFormField<String>(
            value: category,
            decoration: const InputDecoration(hintText: 'Select Category'),
            items: categories.map((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Text(category),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                category = newValue!;
              });
            },
            validator: (value) => value == null ? 'Please select a category' : null,
          ),
          DropdownButtonFormField<String>(
            value: priority,
            decoration: const InputDecoration(hintText: 'Select Task Priority'),
            items: priorities.map((String priority) {
              return DropdownMenuItem<String>(
                value: priority,
                child: Text(priority),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                priority = newValue!;
              });
            },
            validator: (value) => value == null ? 'Please select a priority' : null,
          ),
          ElevatedButton(
            onPressed: submit,
            child: const Text('Save Task'),
          ),
        ],
      ),
    );
  }
}
