import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/playbar_bloc.dart';
import '../bloc/saved_radios_bloc.dart';
import '../models/station.dart';
import '../services/radio_service.dart';

class DetailsPage extends StatefulWidget {
  final Station station;
  const DetailsPage({super.key, required this.station});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final RadioService _radioService = RadioService();
  String? _description;

  @override
  void initState() {
    super.initState();
    _fetchDescription();
  }

  Future<void> _fetchDescription() async {
    final desc = await _radioService.fetchDescription(widget.station.stationuuid);
    if (mounted) {
      setState(() {
        _description = desc;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<PlaybarBloc, PlaybarState>(
      builder: (context, state) {
        final isPlaying =
            state is PlaybarPlaying && state.station.stationuuid == widget.station.stationuuid;

        return Scaffold(
          appBar: AppBar(
            title: Text(widget.station.name,
                style: TextStyle(color: theme.colorScheme.onPrimaryContainer)),
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
                    context.read<PlaybarBloc>().add(Play(widget.station));
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
                  widget.station.favicon,
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
                widget.station.name,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                widget.station.tags.replaceAll(',', ' • '),
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.secondary),
              ),
              const SizedBox(height: 16),
              if (_description == null)
                const Center(child: CircularProgressIndicator())
              else if (_description!.isNotEmpty)
                Text(
                  _description!,
                  style: theme.textTheme.bodyLarge,
                ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat(context, Icons.people, '${widget.station.votes} votes'),
                  _buildStat(context, Icons.headphones, '${widget.station.clickcount} clicks'),
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
                onPressed: () {
                  context.read<SavedRadiosBloc>().add(RemoveRadio(widget.station));
                  context.pop(); // Go back after removing
                },
                icon: const Icon(Icons.remove),
                label: const Text('Remove from My Radios'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.error,
                  foregroundColor: theme.colorScheme.onError,
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
