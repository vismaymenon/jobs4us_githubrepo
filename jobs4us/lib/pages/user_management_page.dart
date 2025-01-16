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

  Future<void> _addUser(String phone, String password) async {
    try {
      await _firestore.collection('residents').doc(phone).set({
        'password': password,
        'status': 'active', // New account is active by default
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User added successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error adding user: $e')));
    }
  }

  Future<void> _suspendUser(String phone) async {
    try {
      await _firestore.collection('residents').doc(phone).update({
        'status': 'suspended',
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('User suspended successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error suspending user: $e')));
    }
  }

  Future<void> _cancelSuspension(String phone) async {
    try {
      await _firestore.collection('residents').doc(phone).update({
        'status': 'active', // Revert status back to 'active'
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Suspension canceled, user is now active')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error canceling suspension: $e')));
    }
  }

  Future<void> _resetPassword(String phone, String newPassword) async {
    try {
      await _firestore.collection('residents').doc(phone).set({
        'password': newPassword, // New account is active by default
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password resetted successfully')));
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
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addUser(_phoneController.text, _passwordController.text);
              },
              child: Text('Add User'),
            ),
            SizedBox(height: 20), // Adds a box (space) between the buttons
            ElevatedButton(
              onPressed: () {
                _suspendUser(_phoneController.text);
              },
              child: Text('Suspend User'),
            ),
            SizedBox(height: 20), // Adds a box (space) between the buttons
            ElevatedButton(
              onPressed: () {
                _cancelSuspension(_phoneController.text);
              },
              child: Text('Cancel Suspension'),
            ),
            SizedBox(height: 20), // Adds a box (space) between the buttons
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