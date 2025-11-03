import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

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
        title: const Text('Account'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _safePopOrGoSignup(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const ListTile(
              title: Text('Username'),
              subtitle: Text('MusicListener'),
            ),
            const ListTile(
              title: Text('Email Address'),
              subtitle: Text('example@gmail.com'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                context.push('/home?premium=true');
              },
              child: const Text('Subscribe to Freq+'),
            ),
          ],
        ),
      ),
    );
  }
}
