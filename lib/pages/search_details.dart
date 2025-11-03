import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchDetailsPage extends StatelessWidget {
  const SearchDetailsPage({super.key});

  void _safePopOrGoSignup(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/signup');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _safePopOrGoSignup(context),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.push('/chat'),
              child: const Text('Enter Chatroom'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                if (context.canPop()) {
                  context.pop();
                } else {
                  context.go('/signup');
                }
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
