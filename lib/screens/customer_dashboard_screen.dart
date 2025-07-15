import 'package:flutter/material.dart';

class CustomerDashboardScreen extends StatelessWidget {
  const CustomerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Dashboard'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text(
          'Welcome to the Customer Dashboard!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
