import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/playbar_bloc.dart';
import '../bloc/saved_radios_bloc.dart';
import '../models/station.dart';
import '../services/radio_service.dart';

class HomePage extends StatefulWidget {
  final bool isPremium;
  const HomePage({super.key, required this.isPremium});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RadioService _radioService = RadioService();
  List<Station> _sponsoredStations = [];
  bool _isLoadingSponsored = false;

  @override
  void initState() {
    super.initState();
    _fetchSponsoredStations();
  }

  Future<void> _fetchSponsoredStations() async {
    if (widget.isPremium) return; // Don't fetch if user is premium

    setState(() {
      _isLoadingSponsored = true;
    });

    try {
      final results = await Future.wait([
        _radioService.fetchStationsByName('DKFM'),
        _radioService.fetchStationsByName('J-pop powerplay kawaii'),
        _radioService.fetchStationsByName('jazz sakura'),
      ]);

      final stations = <Station>[];
      if (results[0].isNotEmpty) stations.add(results[0].first);
      if (results[1].isNotEmpty) stations.add(results[1].first);
      if (results[2].isNotEmpty) stations.add(results[2].first);

      if (mounted) {
        setState(() {
          _sponsoredStations = stations;
        });
      }
    } catch (e) {
      print("Failed to load sponsored stations: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingSponsored = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    if (_isLoadingSponsored)
                      const Center(child: CircularProgressIndicator())
                    else
                      ..._sponsoredStations.map((station) {
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
