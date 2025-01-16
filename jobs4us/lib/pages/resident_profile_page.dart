import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobs4us/data/sample_transactions.dart';
import 'package:jobs4us/pages/edit_password_page.dart';
import 'package:jobs4us/pages/transaction_history_page.dart';

class ResidentProfilePage extends StatefulWidget {
  @override
  _ResidentProfilePageState createState() => _ResidentProfilePageState();
}

class _ResidentProfilePageState extends State<ResidentProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeProfile();
  }

  Future<void> _initializeProfile() async {
    User? user = _auth.currentUser;

    if (user != null) {
      try {
        DocumentSnapshot userDoc = await _firestore.collection('residents').doc(user.phoneNumber).get();

        if (userDoc.exists) {
          _usernameController.text = userDoc['username'];
          _nameController.text = userDoc['name'];
          _phoneController.text = userDoc['phone'];

          String censoredPassword = '****';
          _passwordController.text = censoredPassword;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User profile not found')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading profile: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No user signed in')),
      );
    }
  }

  void _navigateToEditPasswordPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditPasswordPage(phone: _phoneController.text.trim()),
      ),
    );
  }

  void _logOut() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Resident Profile"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/minimart');
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Username:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(border: InputBorder.none),
              readOnly: true,
            ),
            SizedBox(height: 8),
            Text(
              "Name:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(border: InputBorder.none),
            ),
            SizedBox(height: 8),
            Text(
              "Phone Number:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(border: InputBorder.none),
              readOnly: true,
            ),
            SizedBox(height: 8),
            Text(
              "Password:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(border: InputBorder.none),
                    obscureText: true,
                    readOnly: true,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: _navigateToEditPasswordPage,
                ),
              ],
            ),
            SizedBox(height: 16), // Added space between buttons
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TransactionHistoryPage(transactions: sampleTransactions)));
              },
              child: Text("Go to Transaction History"),
            ),
            SizedBox(height: 20), // Added space before Log Out button
            ElevatedButton(
              onPressed: _logOut,
              child: Text("Log Out"),
            ),
          ],
        ),
      ),
    );
  }
}