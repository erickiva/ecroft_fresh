import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  final String phoneNumber;

  const SignUpScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Complete your sign up", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            TextFormField(
              initialValue: phoneNumber,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: "Phone Number",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Full Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Save to Firestore or navigate
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text("Finish Sign Up", style: TextStyle(color: Colors.white)),
            )
          ],
        ),
      ),
    );
  }
}
