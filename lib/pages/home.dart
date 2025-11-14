import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/playbar_bloc.dart';
import '../bloc/saved_radios_bloc.dart';

class HomePage extends StatefulWidget {
  final bool isPremium;
  const HomePage({super.key, required this.isPremium});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final sponsored = List.generate(3, (i) => 'Sponsored ${i + 1}');
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Radios', style: TextStyle(color: theme.colorScheme.onPrimaryContainer)),
        backgroundColor: theme.colorScheme.primaryContainer,
        leading: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () => context.push('/search'),
          color: theme.colorScheme.onPrimaryContainer,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () => context.push('/account'),
            color: theme.colorScheme.onPrimaryContainer,
          ),
        ],
      ),
      body: BlocBuilder<PlaybarBloc, PlaybarState>(
        builder: (context, playbarState) {
          return BlocBuilder<SavedRadiosBloc, SavedRadiosState>(
            builder: (context, savedRadiosState) {
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (!widget.isPremium) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Text('Sponsored', style: theme.textTheme.titleLarge),
                    ),
                    ...List.generate(sponsored.length, (i) {
                      final stationName = sponsored[i];
                      final isPlaying = playbarState is PlaybarPlaying && playbarState.station.name == stationName;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage('https://picsum.photos/seed/${stationName.hashCode}/100'),
                        ),
                        title: Text(stationName, style: theme.textTheme.titleMedium),
                        selected: isPlaying,
                        selectedTileColor: theme.colorScheme.primaryContainer.withOpacity(0.5),
                        onTap: () {
                          if (isPlaying) {
                            context.read<PlaybarBloc>().add(Pause());
                          }
                        },
                      );
                    }),
                    const SizedBox(height: 20),
                  ],
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text('My Radios', style: theme.textTheme.titleLarge),
                  ),
                  if (savedRadiosState.stations.isEmpty)
                    const Center(child: Text('No saved radios yet.'))
                  else
                    ...savedRadiosState.stations.map((station) {
                      final isPlaying = playbarState is PlaybarPlaying && playbarState.station == station;
                      return ListTile(
                        key: Key(station.stationuuid),
                        leading: CircleAvatar(
                          backgroundImage: station.favicon.isNotEmpty
                              ? NetworkImage(station.favicon)
                              : null,
                          child: station.favicon.isEmpty ? const Icon(Icons.radio) : null,
                        ),
                        title: Text(station.name, style: theme.textTheme.titleMedium),
                        selected: isPlaying,
                        selectedTileColor: theme.colorScheme.primaryContainer.withOpacity(0.5),
                        trailing: IconButton(
                          icon: const Icon(Icons.info_outline),
                          onPressed: () => context.push('/station-details', extra: station),
                        ),
                        onTap: () {
                          if (isPlaying) {
                            context.read<PlaybarBloc>().add(Pause());
                          } else {
                            context.read<PlaybarBloc>().add(Play(station));
                          }
                        },
                      );
                    }),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
