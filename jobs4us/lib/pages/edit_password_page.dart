import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditPasswordPage extends StatefulWidget {
  final String phone;

  EditPasswordPage({required this.phone});

  @override
  _EditPasswordPageState createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  ConfirmationResult? confirmationResult;

  Future<void> sendOTP() async {
    String newPassword = newPasswordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    if (newPassword != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    try {
      confirmationResult = await _auth.signInWithPhoneNumber(widget.phone);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP sent to ${widget.phone}')),
      );
      // Show OTP dialog
      _showOtpDialog();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending OTP: $e')),
      );
    }
  }

  Future<void> verifyOTP(String otp) async {
    if (confirmationResult != null) {
      try {
        await confirmationResult!.confirm(otp);
        updatePassword();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid OTP: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please request an OTP first')),
      );
    }
  }

  Future<void> updatePassword() async {
    String newPassword = newPasswordController.text.trim();
    if (newPassword.isNotEmpty) {
      await FirebaseFirestore.instance.doc('residents/${widget.phone}').update({
        'password': newPassword, // Password should ideally be hashed in production
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password updated successfully')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a new password')),
      );
    }
  }

  // Show OTP dialog
  void _showOtpDialog() {
    TextEditingController otpController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Enter OTP sent to ${widget.phone}"),
          content: TextField(
            controller: otpController,
            decoration: InputDecoration(labelText: "Enter OTP"),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                String otp = otpController.text.trim();
                if (otp.isNotEmpty) {
                  verifyOTP(otp);
                  Navigator.pop(context); // Close the dialog
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter the OTP')),
                  );
                }
              },
              child: Text("Verify"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog without verifying
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: newPasswordController,
              decoration: InputDecoration(labelText: "Enter New Password"),
              obscureText: true,
            ),
            SizedBox(height: 10),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(labelText: "Confirm New Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sendOTP,
              child: Text("Confirm"),
            ),
          ],
        ),
      ),
    );
  }
}