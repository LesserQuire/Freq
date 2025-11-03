import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final Map<int, bool> _added = {};

  @override
  Widget build(BuildContext context) {
    final results = List.generate(15, (i) => 'Search Result ${i + 1}');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => context.push('/add-url'),
              child: const Text('Add URL'),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                final isAdded = _added[index] ?? false;
                return ListTile(
                  title: Text(results[index]),
                  trailing: IconButton(
                    icon: Icon(
                      isAdded ? Icons.check_circle : Icons.add_circle_outline,
                      color: isAdded ? Colors.green : null,
                    ),
                    onPressed: () {
                      setState(() {
                        _added[index] = !isAdded;
                      });
                    },
                  ),
                  onTap: () => context.push('/details', extra: {'from': 'search'}),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
