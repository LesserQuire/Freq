import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Account', style: TextStyle(color: theme.colorScheme.onPrimaryContainer)),
        backgroundColor: theme.colorScheme.primaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Account Details', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 16),
            ListTile(
              title: Text('Username', style: theme.textTheme.titleMedium),
              subtitle: Text('MusicListener', style: theme.textTheme.bodyLarge),
            ),
            ListTile(
              title: Text('Email Address', style: theme.textTheme.titleMedium),
              subtitle: Text('example@gmail.com', style: theme.textTheme.bodyLarge),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  context.push('/home?premium=true');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                ),
                child: const Text('Subscribe to Freq+'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
