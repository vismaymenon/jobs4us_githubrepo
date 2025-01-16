import 'package:flutter/material.dart';
import 'resident_login_page.dart';
import 'admin_login_page.dart';

class LoginPage extends StatefulWidget {
  final bool isAdmin; // Add a parameter to determine if it's for Admin or Resident

  // Constructor with the isAdmin parameter
  LoginPage({required this.isAdmin});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize the TabController with 2 tabs, but set the initial tab based on isAdmin
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.isAdmin ? 1 : 0, // Set the initial tab based on isAdmin
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login', // "Login" styled in white
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Set text to white
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF002856), // Set the background color to match MinimartPage
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Color(0xFFD31B22), // Set the indicator color to match MinimartPage
          tabs: [
            Tab(
              icon: Icon(Icons.person, color: Colors.white), // Set icon color to white
              child: Text(
                'Resident',
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
            ),
            Tab(
              icon: Icon(Icons.admin_panel_settings, color: Colors.white), // Set icon color to white
              child: Text(
                'Admin',
                style: TextStyle(color: Colors.white), // Set text color to white
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          ResidentLoginPage(), // Reference the resident login widget
          AdminLoginPage(), // Reference the admin login widget
        ],
      ),
    );
  }
}