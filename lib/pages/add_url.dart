import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddUrlPage extends StatelessWidget {
  const AddUrlPage({super.key});

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
        title: const Text('Add URL'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => _safePopOrGoSignup(context),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: TextField(
          decoration: InputDecoration(labelText: 'Enter URL'),
        ),
      ),
    );
  }
}
