import 'package:flutter/material.dart';

class VoucherTasksPage extends StatefulWidget {
  @override
  _VoucherTasksPageState createState() => _VoucherTasksPageState();
}

class _VoucherTasksPageState extends State<VoucherTasksPage> {
  // Sample data for tasks
  List<Map<String, dynamic>> tasks = [
    {"username": "user1", "taskNumber": 101},
    {"username": "user2", "taskNumber": 102},
    {"username": "user3", "taskNumber": 103},
    {"username": "user4", "taskNumber": 104},
  ];

  // Function to approve a task
  void approveTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Task approved successfully!")),
    );
  }

  // Function to decline a task
  void declineTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Task declined!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voucher Tasks'),
        backgroundColor: Color(0xFF002856), // Dark Blue
        foregroundColor: Colors.white, // White text color
        automaticallyImplyLeading: false,
      ),
      body: tasks.isEmpty
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
                        task["username"][0].toUpperCase(),
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Color(0xFF002856),
                    ),
                    title: Text('Username: ${task["username"]}'),
                    subtitle: Text('Task Number: ${task["taskNumber"]}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => approveTask(index),
                          icon: Icon(Icons.check, color: Colors.green),
                          tooltip: "Approve Task",
                        ),
                        IconButton(
                          onPressed: () => declineTask(index),
                          icon: Icon(Icons.close, color: Colors.red),
                          tooltip: "Decline Task",
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

