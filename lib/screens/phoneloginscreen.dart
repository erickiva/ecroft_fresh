import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PhoneLoginScreen extends StatefulWidget {
  const PhoneLoginScreen({super.key});

  @override
  State<PhoneLoginScreen> createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  bool _isResendEnabled = false;
  int _resendCountdown = 30;
  Timer? _timer;

  void _startResendCountdown() {
    setState(() {
      _resendCountdown = 30;
      _isResendEnabled = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        if (_resendCountdown <= 1) {
          _isResendEnabled = true;
          timer.cancel();
        } else {
          _resendCountdown--;
        }
      });
    });
  }

  void _sendOTP() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty || phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid phone number")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('phoneNumber', isEqualTo: phone)
          .get();

      final isRegistered = snapshot.docs.isNotEmpty;
      print("📱 Is $phone registered? $isRegistered");

      if (!isRegistered) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Phone not registered. Redirecting to sign up...")),
        );
        Future.delayed(const Duration(milliseconds: 800), () {
          if (mounted) {
            Navigator.pushNamed(context, '/signup', arguments: phone);
          }
        });
        return;
      }

      // If registered → proceed to OTP
      await _auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Optional auto-sign in
          try {
            await _auth.signInWithCredential(credential);
            if (mounted) {
              Navigator.pushReplacementNamed(context, '/dashboard');
            }
          } catch (_) {}
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() => _isLoading = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Verification failed: ${e.message}")),
          );
        },
        codeSent: (verificationId, resendToken) {
          setState(() => _isLoading = false);
          _startResendCountdown();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("✅ OTP sent.")),
          );

          Navigator.pushNamed(context, '/otp', arguments: {
            'verificationId': verificationId,
            'phoneNumber': phone,
            'isRegistered': true, // pass this to OTP screen
          });
        },
        codeAutoRetrievalTimeout: (verificationId) {},
      );
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Firestore check error: $e")),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(title: const Text("Login with Phone"), backgroundColor: Colors.green),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Enter your phone number", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '+254712345678',
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _sendOTP,
                    child: const Text("Send OTP", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
            const SizedBox(height: 12),
            if (!_isResendEnabled)
              Text("Resend OTP in $_resendCountdown sec", style: const TextStyle(color: Colors.grey)),
            if (_isResendEnabled)
              TextButton(
                onPressed: _sendOTP,
                child: const Text("Resend OTP"),
              ),
          ],
        ),
      ),
    );
  }
}
