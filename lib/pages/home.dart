import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/playbar_bloc.dart';

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
    final regular = List.generate(15, (i) => 'Station ${i + 1}');
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
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (!widget.isPremium) ...[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text('Sponsored', style: theme.textTheme.titleLarge),
                ),
                ...List.generate(sponsored.length, (i) {
                  final station = sponsored[i];
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
                      onPressed: () => context.push('/details', extra: {'from': 'home', 'sponsored': true}),
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
                const SizedBox(height: 20),
              ],
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text('My Radios', style: theme.textTheme.titleLarge),
              ),
              ...List.generate(regular.length, (i) {
                final station = regular[i];
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
                    onPressed: () => context.push('/details', extra: {'from': 'home'}),
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
      ),
    );
  }
}
