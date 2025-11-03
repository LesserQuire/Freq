import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PremiumHomePage extends StatelessWidget {
  const PremiumHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Premium Home'),
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => context.go('/search'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => context.go('/account'),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) => ListTile(
          title: Text('Premium Radio ${index + 1}'),
          trailing: IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {},
          ),
          onTap: () => context.go('/home-details'),
        ),
      ),
    );
  }
}
