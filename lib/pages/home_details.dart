import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeDetailsPage extends StatelessWidget {
  const HomeDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/chat'),
              child: const Text('Enter Chatroom'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Remove'),
            ),
          ],
        ),
      ),
    );
  }
}
