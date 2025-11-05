import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/playbar_bloc.dart';

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic>? extra;
  const DetailsPage({super.key, this.extra});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final from = extra?['from'] ?? '';
    final isFromSearch = from == 'search';
    final isFromHome = from == 'home';
    final isSponsored = extra?['sponsored'] == true;

    const stationName = 'Freq Radio';
    const stationDescription =
        'Streaming the best curated music, talk, and live shows 24/7. '
        'Join our listeners worldwide and chat with other fans!';
    const followers = 12800;
    const listeners = 512;
    const category = 'Music • Talk • Live';

    String buttonLabel;
    VoidCallback onPressedAction;
    Color buttonColor;
    Color foregroundColor;

    if (isFromSearch) {
      buttonLabel = 'Add';
      onPressedAction = () => context.pop();
      buttonColor = theme.colorScheme.primary;
      foregroundColor = theme.colorScheme.onPrimary;
    } else if (isFromHome && isSponsored) {
      buttonLabel = 'Subscribe to Remove';
      onPressedAction = () => context.push('/account');
      buttonColor = theme.colorScheme.tertiary;
      foregroundColor = theme.colorScheme.onTertiary;
    } else {
      buttonLabel = 'Remove';
      onPressedAction = () => context.pop();
      buttonColor = theme.colorScheme.error;
      foregroundColor = theme.colorScheme.onError;
    }

    return BlocBuilder<PlaybarBloc, PlaybarState>(
      builder: (context, state) {
        final isPlaying = state is PlaybarPlaying && state.station == stationName;

        return Scaffold(
          appBar: AppBar(
            title: Text(stationName, style: TextStyle(color: theme.colorScheme.onPrimaryContainer)),
            backgroundColor: theme.colorScheme.primaryContainer,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
              color: theme.colorScheme.onPrimaryContainer,
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause_circle : Icons.play_circle,
                  size: 32,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
                onPressed: () {
                  if (isPlaying) {
                    context.read<PlaybarBloc>().add(Pause());
                  } else {
                    context.read<PlaybarBloc>().add(Play(stationName));
                  }
                },
              )
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  'https://picsum.photos/seed/${stationName.hashCode}/400/180',
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 180,
                    color: Colors.grey.shade300,
                    alignment: Alignment.center,
                    child: const Icon(Icons.radio, size: 64, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                stationName,
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                category,
                style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.secondary),
              ),
              const SizedBox(height: 16),
              Text(stationDescription, style: theme.textTheme.bodyLarge),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat(context, Icons.people, '$followers followers'),
                  _buildStat(context, Icons.headphones, '$listeners listening'),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => context.push('/chat'),
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Enter Chatroom'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onPressedAction,
                icon: Icon(
                  isFromSearch
                      ? Icons.add
                      : isSponsored
                          ? Icons.star
                          : Icons.remove,
                ),
                label: Text(buttonLabel),
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: foregroundColor,
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStat(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, color: theme.colorScheme.secondary),
        const SizedBox(width: 4),
        Text(
          text,
          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
