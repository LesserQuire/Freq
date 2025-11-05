import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/playbar_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
   bool gpsEnabled = true;
  @override
  Widget build(BuildContext context) {
    final results = List.generate(15, (i) => 'Search Result ${i + 1}');
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Search', style: TextStyle(color: theme.colorScheme.onPrimaryContainer)),
        backgroundColor: theme.colorScheme.primaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
          color: theme.colorScheme.onPrimaryContainer,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search for a station...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(gpsEnabled ? Icons.gps_fixed : Icons.gps_off),
                  onPressed: () {
                    setState(() {
                      gpsEnabled = !gpsEnabled;
                    });
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: theme.colorScheme.secondaryContainer,
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<PlaybarBloc, PlaybarState>(
              builder: (context, state) {
                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final station = results[index];
                    final isPlaying = state is PlaybarPlaying && state.station == station;
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage('https://picsum.photos/seed/${station.hashCode}/100'),
                      ),
                      title: Text(station, style: theme.textTheme.titleMedium),
                      selected: isPlaying,
                      selectedTileColor: theme.colorScheme.primaryContainer.withOpacity(0.5),
                      trailing: IconButton(
                        icon: const Icon(Icons.info_outline),
                        onPressed: () => context.push('/details', extra: {'from': 'search'}),
                      ),
                      onTap: () {
                        if (isPlaying) {
                          context.read<PlaybarBloc>().add(Pause());
                        } else {
                          context.read<PlaybarBloc>().add(Play(station));
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
