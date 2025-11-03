import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatefulWidget {
  final bool isPremium;
  const HomePage({super.key, required this.isPremium});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<int, bool> _playing = {};

  @override
  Widget build(BuildContext context) {
    final sponsored = List.generate(3, (i) => 'Sponsored ${i + 1}');
    final regular = List.generate(15, (i) => 'Station ${i + 1}');

    return Scaffold(
      appBar: AppBar(
        title: Text('My Radios'),
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => context.push('/search'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => context.push('/account'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!widget.isPremium) ...[
            const Text(
              'Sponsored',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...List.generate(sponsored.length, (i) {
              final id = i;
              final isPlaying = _playing[id] ?? false;
              return ListTile(
                title: Text(sponsored[i]),
                trailing: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause_circle : Icons.play_circle,
                  ),
                  onPressed: () {
                    setState(() {
                      _playing[id] = !isPlaying;
                    });
                  },
                ),
                onTap: () =>
                    context.push('/details', extra: {'from': 'home', 'sponsored': true}),
                    
              );
            }),
            const SizedBox(height: 20),
          ],
          const Text(
            'My Radios',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ...List.generate(regular.length, (i) {
            final id = i + 100;
            final isPlaying = _playing[id] ?? false;
            return ListTile(
              title: Text(regular[i]),
              trailing: IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause_circle : Icons.play_circle,
                ),
                onPressed: () {
                  setState(() {
                    _playing[id] = !isPlaying;
                  });
                },
              ),
              onTap: () =>
                  context.push('/details', extra: {'from': 'home'}),
            );
          }),
        ],
      ),
    );
  }
}
