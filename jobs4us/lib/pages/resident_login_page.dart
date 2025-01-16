import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResidentLoginPage extends StatefulWidget {
  @override
  _ResidentLoginPageState createState() => _ResidentLoginPageState();
}

class _ResidentLoginPageState extends State<ResidentLoginPage> {
  final phoneController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyCredentials() async {
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
      DocumentSnapshot userDoc = await _firestore.collection('residents').doc(phone).get();

      if (userDoc.exists) {
        String storedUsername = userDoc['username'];
        String storedPassword = userDoc['password'];
        String status = userDoc['status']; // Check the status of the resident

        if (status == 'suspended') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Your account is suspended')),
          );
          return;
        }

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
      
      // Login successful, move to resident profile page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful for ${userCredential.user?.phoneNumber}')),
      );
      
      Navigator.pushReplacementNamed(context, '/minimart');
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
                onPressed: verifyCredentials,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF002856), // Background color
                ),
                child: Text('Login', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/createProfile');
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