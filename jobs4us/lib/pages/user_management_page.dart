import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserManagementPage extends StatefulWidget {
  @override
  _UserManagementPageState createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Ensure phone starts with +65
  String _formatPhoneNumber(String phone) {
    if (phone.isNotEmpty && !phone.startsWith('+65')) {
      return '+65' + phone.replaceAll(RegExp(r'[^0-9]'), ''); // Remove non-numeric characters and add +65
    }
    return phone;
  }

  // Function to add a user to Firestore
  Future<void> _addUser(String phone, String password, String name, String username) async {
    try {
      final formattedPhone = _formatPhoneNumber(phone);
      await _firestore.collection('residents').doc(formattedPhone).set({
         'name': name,
          'username': username,
          'phone': formattedPhone,
          'password': password, // Use hashing for security in a real app
          'status': 'active', // Set the status to 'active'
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User added successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding user: $e')));
    }
  }

  // Function to show the dialog for entering name and username
  void _showAddUserDialog() {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _usernameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter User Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String phone = _phoneController.text;
                String password = _passwordController.text;
                String name = _nameController.text;
                String username = _usernameController.text;
                if (phone.isNotEmpty && password.isNotEmpty && name.isNotEmpty && username.isNotEmpty) {
                  _addUser(phone, password, name, username);
                  Navigator.of(context).pop(); // Close the dialog after adding the user
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all fields')));
                }
              },
              child: Text('Add User'),
            ),
          ],
        );
      },
    );
  }

  // Function to suspend a user
  Future<void> _suspendUser(String phone) async {
    try {
      final formattedPhone = _formatPhoneNumber(phone);
      await _firestore.collection('residents').doc(formattedPhone).update({
        'status': 'suspended',
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User suspended successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error suspending user: $e')));
    }
  }

  // Function to cancel a user's suspension
  Future<void> _cancelSuspension(String phone) async {
    try {
      final formattedPhone = _formatPhoneNumber(phone);
      await _firestore.collection('residents').doc(formattedPhone).update({
        'status': 'active', // Revert status back to 'active'
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Suspension canceled, user is now active')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error canceling suspension: $e')));
    }
  }

  // Function to reset a user's password
  Future<void> _resetPassword(String phone, String newPassword) async {
    try {
      final formattedPhone = _formatPhoneNumber(phone);
      
      // Fetch the current document to retain other fields
      final docSnapshot = await _firestore.collection('residents').doc(formattedPhone).get();
      
      if (docSnapshot.exists) {
        // Update only the password field
        await _firestore.collection('residents').doc(formattedPhone).update({
          'password': newPassword,
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password reset successfully')));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User not found')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error resetting password: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Phone and password input fields
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            
            // Add User Button (opens dialog for name and username)
            ElevatedButton(
              onPressed: _showAddUserDialog, // Show the dialog when the button is pressed
              child: Text('Add User'),
            ),
            SizedBox(height: 20),

            // Suspend User Button
            ElevatedButton(
              onPressed: () {
                _suspendUser(_phoneController.text);
              },
              child: Text('Suspend User'),
            ),
            SizedBox(height: 20),

            // Cancel Suspension Button
            ElevatedButton(
              onPressed: () {
                _cancelSuspension(_phoneController.text);
              },
              child: Text('Cancel Suspension'),
            ),
            SizedBox(height: 20),

            // Reset Password Button
            ElevatedButton(
              onPressed: () {
                _resetPassword(_phoneController.text, _passwordController.text);
              },
              child: Text('Reset Password'),
            ),
          ],
        ),
      ),
    );
  }
}