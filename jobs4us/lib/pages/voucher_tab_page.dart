import 'package:flutter/material.dart';

class VoucherTabPage extends StatefulWidget {
  @override
  _VoucherTabPageState createState() => _VoucherTabPageState();
}

class _VoucherTabPageState extends State<VoucherTabPage> {
  // Sample data for tasks
  List<Map<String, dynamic>> tasks = [
    {"taskNumber": 101, "description": "Task 1 description"},
    {"taskNumber": 102, "description": "Task 2 description"},
    {"taskNumber": 103, "description": "Task 3 description"},
    {"taskNumber": 104, "description": "Task 4 description"},
  ];

  @override
  Widget build(BuildContext context) {
    return tasks.isEmpty
        ? Center(
            child: Text(
              'No tasks available.',
              style: TextStyle(fontSize: 18),
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(
                      task["description"][0].toUpperCase(),
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Color(0xFF002856),
                  ),
                  title: Text('Task Number: ${task["taskNumber"]}'),
                  subtitle: Text('Description: ${task["description"]}'),
                ),
              );
            },
          );
  }
}