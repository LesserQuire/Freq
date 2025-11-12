import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/playbar_bloc.dart';
import '../models/station.dart';

class Playbar extends StatelessWidget {
  const Playbar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<PlaybarBloc, PlaybarState>(
      builder: (context, state) {
        if (state is PlaybarPlaying || state is PlaybarPaused) {
          final station = (state is PlaybarPlaying)
              ? state.station
              : (state as PlaybarPaused).station;
          final isPlaying = state is PlaybarPlaying;

          return GestureDetector(
            onTap: () => context.push('/player'),
            child: Container(
              height: 60,
              color: theme.colorScheme.primaryContainer.withOpacity(0.95),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: station.favicon.isNotEmpty
                      ? NetworkImage(station.favicon)
                      : null, // Using null will show the default background color
                  child: station.favicon.isEmpty ? const Icon(Icons.radio) : null,
                ),
                title: Text(
                  station.name, // Use the name property
                  style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: IconButton(
                  icon: Icon(
                    isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  iconSize: 40,
                  onPressed: () {
                    if (isPlaying) {
                      context.read<PlaybarBloc>().add(Pause());
                    } else {
                      context.read<PlaybarBloc>().add(Play(station));
                    }
                  },
                ),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
