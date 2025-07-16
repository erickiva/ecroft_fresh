import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'customer_dashboard_screen.dart';

class SignUpScreen extends StatefulWidget {
  final String phoneNumber; // from verified OTP

  const SignUpScreen({super.key, required this.phoneNumber});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw FirebaseAuthException(code: 'no-user', message: 'No authenticated user found.');
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'location': _locationController.text.trim(),
        'address': _addressController.text.trim(),
        'phone': widget.phoneNumber,
        'createdAt': Timestamp.now(),
      });

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const CustomerDashboardScreen()),
        (route) => false,
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Something went wrong. Please try again.';
      });
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Profile'),
        backgroundColor: Colors.green[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "Just a few more details to get you started!",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  hintText: 'What should we call you? 😊',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (val) =>
                    val != null && val.trim().length >= 3 ? null : 'Enter your full name',
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'So we can send your receipts! 📧',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (val) =>
                    val != null && val.contains('@') ? null : 'Enter a valid email address',
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Location',
                  hintText: 'Eg. Roysambu, Zimmerman, Kahawa West 🌍',
                  prefixIcon: Icon(Icons.location_on),
                ),
                validator: (val) =>
                    val != null && val.trim().isNotEmpty ? null : 'Location required',
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Delivery Address',
                  hintText: 'Eg. Maji Court, House 6B 🏠',
                  prefixIcon: Icon(Icons.home),
                ),
                validator: (val) =>
                    val != null && val.trim().isNotEmpty ? null : 'Delivery address required',
              ),
              const SizedBox(height: 24),

              if (_errorMessage.isNotEmpty)
                Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 10),

              ElevatedButton.icon(
                onPressed: _isLoading ? null : _submitForm,
                icon: const Icon(Icons.check),
                label: Text(
                  _isLoading ? 'Saving...' : 'Finish Signup',
                  style: const TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
