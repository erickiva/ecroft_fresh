import 'package:flutter/material.dart';

class CustomerDashboardScreen extends StatelessWidget {
  const CustomerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("eCroft Fresh"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // Future: Implement logout logic
              Navigator.pushReplacementNamed(context, '/phoneLogin');
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Welcome to your Dashboard!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _DashboardCard(
                    icon: Icons.shopping_cart,
                    title: 'My Orders',
                    onTap: () {
                      // Navigate to orders screen (future)
                    },
                  ),
                  _DashboardCard(
                    icon: Icons.store,
                    title: 'Vendors',
                    onTap: () {
                      // Navigate to vendors screen (future)
                    },
                  ),
                  _DashboardCard(
                    icon: Icons.favorite,
                    title: 'Saved Items',
                    onTap: () {
                      // Navigate to saved items screen
                    },
                  ),
                  _DashboardCard(
                    icon: Icons.person,
                    title: 'My Profile',
                    onTap: () {
                      // Navigate to profile screen
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.green.shade50,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 36, color: Colors.green),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
