// lib/screens/phoneloginscreen.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendOTP() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || !phone.startsWith('07')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enter a valid Kenyan number starting with 07...')),
      );
      return;
    }

    setState(() => _isLoading = true);

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+254${phone.substring(1)}',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (credential) {
        // Optional: auto verification
      },
      verificationFailed: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Verification failed: ${error.message}')),
        );
        setState(() => _isLoading = false);
      },
      codeSent: (verificationId, resendToken) {
        Navigator.pushNamed(
          context,
          '/verify_otp',
          arguments: verificationId,
        );
        setState(() => _isLoading = false);
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Phone Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Text("Enter your phone number to continue",
                style: TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                hintText: 'e.g. 0712345678',
                prefixIcon: Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _sendOTP,
              icon: const Icon(Icons.send),
              label: Text(_isLoading ? 'Sending...' : 'Send OTP'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
