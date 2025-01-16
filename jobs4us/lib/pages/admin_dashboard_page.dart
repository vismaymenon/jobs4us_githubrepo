import 'package:flutter/material.dart';
import 'user_management_page.dart';
import 'voucher_tasks_page.dart';
import 'product_requests_page.dart';
import 'inventory_page.dart';
import 'report_generation_page.dart';
import '../models/product.dart';

class AdminDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Color(0xFF002856), // Dark Blue
        foregroundColor: Colors.white
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            leading: Icon(Icons.people, color: Colors.blue),
            title: Text('Manage Users'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserManagementPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.task, color: Colors.green),
            title: Text('Voucher Tasks'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VoucherTasksPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.request_page, color: Colors.orange),
            title: Text('Product Requests'),
            onTap: () {
              final outOfStockProducts = InventoryPage().products
                .where((product) => (product as Product).stock == 0)
                .toList();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      ProductRequestsPage(outOfStockProducts: outOfStockProducts),
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.inventory, color: Colors.red),
            title: Text('Inventory'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InventoryPage()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.analytics, color: Colors.purple),
            title: Text('Report Generation'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReportGenerationPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
