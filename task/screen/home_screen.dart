import 'package:flutter/material.dart';
import 'task_screen.dart'; // Import the task screen

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void navigateToTaskScreen(BuildContext context, String day) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskScreen(day: day),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome to Task Tracker',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                const Text(
                  'Select a Day',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 30),

                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildDayButton(context, 'Mon'),
                    _buildDayButton(context, 'Tue'),
                    _buildDayButton(context, 'Wed'),
                    _buildDayButton(context, 'Thu'),
                    _buildDayButton(context, 'Fri'),
                    _buildDayButton(context, 'Sat'),
                    _buildDayButton(context, 'Sun'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ElevatedButton _buildDayButton(BuildContext context, String day) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.blueAccent,
        backgroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 10,
      ),
      onPressed: () {
        navigateToTaskScreen(context, day);
      },
      child: Text(
        day,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}
