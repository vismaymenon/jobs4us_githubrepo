import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'create_profile_page.dart';

class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final phoneController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyAdminCredentials() async {
    String phone = phoneController.text.trim();
    String username = usernameController.text.trim();
    String password = passwordController.text.trim();

    if (phone.isEmpty || username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    // Prepend +65 to the phone number
    phone = '+65$phone';

    try {
      // Check if the admin phone number exists in Firestore
      DocumentSnapshot adminDoc = await _firestore.collection('admins').doc(phone).get();

      if (adminDoc.exists) {
        String storedUsername = adminDoc['username'];
        String storedPassword = adminDoc['password'];

        if (storedUsername == username && storedPassword == password) {
          // Send OTP to phone number for validation
          await _sendOtp(phone, username, password);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Incorrect username or password')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phone number not found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _sendOtp(String phone, String username, String password) async {
    try {
      ConfirmationResult confirmationResult = await _auth.signInWithPhoneNumber(phone);
      showOTPDialog(confirmationResult, username, phone, password);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending OTP: $e')),
      );
    }
  }

  void showOTPDialog(ConfirmationResult confirmationResult, String username, String phone, String password) {
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
                await confirmOTP(confirmationResult, otp, username, phone, password);
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> confirmOTP(ConfirmationResult confirmationResult, String otp, String username, String phone, String password) async {
    try {
      UserCredential userCredential = await confirmationResult.confirm(otp);
      print('Phone number verified: ${userCredential.user?.phoneNumber}');
      
      // Admin login successful, navigate to the admin dashboard
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful for ${userCredential.user?.phoneNumber}')),
      );
      
      Navigator.pushReplacementNamed(context, '/userManagement');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error confirming OTP: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Get the screen width

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: screenWidth, // Use the screen width
                child: TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: screenWidth, // Use the screen width
                child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                width: screenWidth, // Use the screen width
                child: TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: verifyAdminCredentials,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF002856), // Background color
                ),
                child: Text('Login', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateProfilePage(isAdmin: true),
                    ),
                  );
                },
                child: Text(
                  'Don\'t have an account? Create Profile',
                  style: TextStyle(color: Color(0xFF002856)), // Text color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}