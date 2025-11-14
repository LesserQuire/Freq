import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/playbar_bloc.dart';
import '../bloc/saved_radios_bloc.dart';

class PlayerPage extends StatelessWidget {
  const PlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<PlaybarBloc, PlaybarState>(
      builder: (context, state) {
        if (state is! PlaybarPlaying && state is! PlaybarPaused) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.canPop()) {
              context.pop();
            }
          });
          return const Scaffold();
        }

        final station = state is PlaybarPlaying
            ? state.station
            : (state as PlaybarPaused).station;
        final isPlaying = state is PlaybarPlaying;

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.keyboard_arrow_down),
              onPressed: () => context.pop(),
            ),
          ),
          extendBodyBehindAppBar: true,
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.surface,
                ],
                stops: const [0.5, 1.0],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      station.favicon.isNotEmpty
                          ? station.favicon
                          : 'https://picsum.photos/seed/${station.name.hashCode}/400',
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: double.infinity,
                        height: 300,
                        color: Colors.grey.shade300,
                        alignment: Alignment.center,
                        child: const Icon(Icons.radio, size: 64, color: Colors.grey),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Text(
                          station.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),

                      BlocBuilder<SavedRadiosBloc, SavedRadiosState>(
                        builder: (context, savedState) {
                          final isSaved = savedState.stations.any(
                            (s) => s.stationuuid == station.stationuuid,
                          );

                          return IconButton(
                            iconSize: 32,
                            color: isSaved
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurfaceVariant,
                            icon: Icon(
                              isSaved
                                  ? Icons.check_circle
                                  : Icons.add_circle_outline,
                            ),
                            onPressed: () {
                              if (isSaved) {
                                context.read<SavedRadiosBloc>().add(RemoveRadio(station.stationuuid));
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(content: Text('Removed ${station.name} from My Radios')),
                                  );
                              } else {
                                context.read<SavedRadiosBloc>().add(AddRadio(station));
                                ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(
                                    SnackBar(content: Text('Added ${station.name} to My Radios')),
                                  );
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous),
                        iconSize: 48.0,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: Icon(
                          isPlaying
                              ? Icons.pause_circle_filled
                              : Icons.play_circle_filled,
                          color: theme.colorScheme.primary,
                        ),
                        iconSize: 80.0,
                        onPressed: () {
                          if (isPlaying) {
                            context.read<PlaybarBloc>().add(Pause());
                          } else {
                            context.read<PlaybarBloc>().add(Play(station));
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next),
                        iconSize: 48.0,
                        onPressed: () {},
                      ),
                    ],
                  ),

                  const Spacer(flex: 2),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
