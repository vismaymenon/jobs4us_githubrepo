import 'package:flutter/material.dart';
import 'dart:async';

class ReportGenerationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Report Generation'),
        backgroundColor: Color(0xFF002856), // Dark Blue
        foregroundColor: Colors.white, // White text color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Generate Reports',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildReportCard(
                    context,
                    title: 'Weekly Requests Summary',
                    description: 'View the number of product requests submitted over the past week.',
                    onView: () => _showRequestsReport(context),
                  ),
                  _buildReportCard(
                    context,
                    title: 'Inventory Summary',
                    description: 'View the current inventory levels and trends.',
                    onView: () => _showInventoryReport(context),
                  ),
                  _buildReportCard(
                    context,
                    title: 'View Report',
                    description: 'View the detailed summary report with an option to download as PDF.',
                    onView: () => _viewFullReport(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context, {
    required String title,
    required String description,
    required VoidCallback onView,
  }) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
        trailing: ElevatedButton(
          onPressed: onView,
          child: Text('View'),
        ),
      ),
    );
  }

  void _showRequestsReport(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Weekly Requests Summary'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Monday: 20 requests'),
                Text('Tuesday: 15 requests'),
                Text('Wednesday: 30 requests'),
                Text('Thursday: 25 requests'),
                Text('Friday: 10 requests'),
                Text('Saturday: 18 requests'),
                Text('Sunday: 22 requests'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showInventoryReport(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Inventory Summary'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Notebooks: 50 units'),
                Text('Bodywash: 20 units'),
                Text('Orange Juice: 30 units'),
                Text('Skittles: 10 units'),
                Text('Toy Cars: 25 units'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _viewFullReport(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Detailed Report Summary'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Report Summary',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                Text('Date: ${DateTime.now().toLocal().toString().split(' ')[0]}'),
                SizedBox(height: 10),
                Divider(),
                Text('Weekly Requests Summary:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text('Monday: 20 requests'),
                Text('Tuesday: 15 requests'),
                Text('Wednesday: 30 requests'),
                Text('Thursday: 25 requests'),
                Text('Friday: 10 requests'),
                Text('Saturday: 18 requests'),
                Text('Sunday: 22 requests'),
                SizedBox(height: 10),
                Divider(),
                Text('Inventory Summary:', style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 5),
                Text('Notebooks: 50 units'),
                Text('Bodywash: 20 units'),
                Text('Orange Juice: 30 units'),
                Text('Skittles: 10 units'),
                Text('Toy Cars: 25 units'),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                // Simulate a delay
                await Future.delayed(Duration(seconds: 2));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Downloaded!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text('Download PDF'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
