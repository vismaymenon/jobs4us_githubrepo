import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CreateResidentProfilePage extends StatefulWidget {
  @override
  _CreateResidentProfilePageState createState() => _CreateResidentProfilePageState();
}

class _CreateResidentProfilePageState extends State<CreateResidentProfilePage> {
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> createUserProfile() async {
    String name = nameController.text.trim();
    String username = usernameController.text.trim();
    String phone = phoneController.text.trim();
    String password = passwordController.text.trim();

    if (name.isEmpty || username.isEmpty || phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Prepend +65 to the phone number
    phone = '+65$phone';

    try {
      // Check if the username or phone number already exists
      QuerySnapshot usernameCheck = await _firestore
          .collection('residents')
          .where('username', isEqualTo: username)
          .get();

      if (usernameCheck.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Username already taken')),
        );
        return;
      }

      DocumentSnapshot phoneCheck =
          await _firestore.collection('residents').doc(phone).get();

      if (phoneCheck.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phone number already registered')),
        );
        return;
      }

      // Send OTP to the provided phone number
      await _sendOtp(phone, name, username, password);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _sendOtp(String phone, String name, String username, String password) async {
    try {
      ConfirmationResult confirmationResult = await _auth.signInWithPhoneNumber(phone);
      showOTPDialog(confirmationResult, name, username, phone, password);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending OTP: $e')),
      );
    }
  }

  void showOTPDialog(ConfirmationResult confirmationResult, String name, String username, String phone, String password) {
    TextEditingController otpController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter OTP sent to $phone'),
          content: TextField(
            controller: otpController,
            decoration: InputDecoration(hintText: 'Enter OTP'),
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                String otp = otpController.text.trim();
                await confirmOTP(confirmationResult, otp, name, username, phone, password);
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> confirmOTP(ConfirmationResult confirmationResult, String otp, String name, String username, String phone, String password) async {
    try {
      UserCredential userCredential = await confirmationResult.confirm(otp);
      print('Phone number verified: ${userCredential.user?.phoneNumber}');
      // Create a new user profile in Firestore with 'status' set to 'active'
      await _firestore.collection('residents').doc(phone).set({
        'name': name,
        'username': username,
        'phone': phone,
        'password': password, // Use hashing for security in a real app
        'status': 'active', // Set the status to 'active'
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile created successfully')),
      );

      // Navigate to the login page
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error confirming OTP: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Resident Profile'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: createUserProfile,
              child: Text('Create Profile'),
            ),
          ],
        ),
      ),
    );
  }
}