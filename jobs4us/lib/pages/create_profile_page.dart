import 'package:flutter/material.dart';
import 'package:jobs4us/pages/login_page.dart';
import 'create_resident_profile_page.dart';
import 'create_admin_profile_page.dart';

class CreateProfilePage extends StatefulWidget {
  final bool isAdmin;  // Add a parameter to determine if it's for Admin or Resident

  // Constructor with the isAdmin parameter
  CreateProfilePage({required this.isAdmin});

  @override
  _CreateProfilePageState createState() => _CreateProfilePageState();
}

class _CreateProfilePageState extends State<CreateProfilePage> with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    // Initialize the TabController with 2 tabs, but set the initial tab based on isAdmin
    _tabController = TabController(
      length: 2, 
      vsync: this, 
      initialIndex: widget.isAdmin ? 1 : 0,  // Set the initial tab based on isAdmin
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Check if the current tab is for Admin or Resident
            bool isAdmin = widget.isAdmin;  // Based on whether you're in the Admin tab or Resident tab

            // Navigate back to the LoginPage with the correct isAdmin value
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LoginPage(isAdmin: isAdmin),  // Pass the isAdmin flag
              ),
            );
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Resident'),
            Tab(text: 'Admin'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          CreateResidentProfilePage(), // Resident tab
          CreateAdminProfilePage(),    // Admin tab
        ],
      ),
    );
  }
}