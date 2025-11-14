import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  User? _user;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _user = context.read<AuthService>().currentUser;
    context.read<AuthService>().authStateChanges.listen((user) {
      if (mounted) {
        setState(() {
          _user = user;
        });
      }
    });
  }

  Future<void> _onSignOut() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await context.read<AuthService>().signOut();
      if (mounted) {
        context.go('/login');
      }
    } catch (e) {
      // Handle error, e.g., show a SnackBar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error signing out: \$e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
        actions: [
          IconButton(
            icon: const Icon(Icons.upgrade),
            onPressed: () {
              context.push('/home?premium=true'); // Navigate to premium page
            },
            color: theme.colorScheme.onPrimaryContainer,
            tooltip: 'Upgrade to Freq+',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Account Details', style: theme.textTheme.headlineSmall),
            const SizedBox(height: 16),
            ListTile(
              title: Text('Email Address', style: theme.textTheme.titleMedium),
              subtitle: Text(_user?.email ?? 'N/A', style: theme.textTheme.bodyLarge),
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: _isLoading ? null : _onSignOut,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error, // Use error color for logout
                  foregroundColor: theme.colorScheme.onError,
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Logout'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
