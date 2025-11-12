import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/playbar_bloc.dart';
import '../models/station.dart';
import '../services/location_service.dart';
import '../services/radio_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final LocationService _locationService = LocationService();
  final RadioService _radioService = RadioService();
  bool _gpsEnabled = false;
  List<Station> _localRadios = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchLocalRadios();
  }

  Future<void> _fetchLocalRadios() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final position = await _locationService.determinePosition();
      final List<Station> stations = await _radioService.fetchStationsByLocation(
          position.latitude, position.longitude);
      if (mounted) {
        setState(() {
          _localRadios = stations;
          _gpsEnabled = true;
        });
      }
    } catch (e) {
      print(e);
      if (mounted) {
        setState(() {
          _gpsEnabled = false;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  icon: Icon(_gpsEnabled ? Icons.gps_fixed : Icons.gps_off),
                  onPressed: () {
                    if (_gpsEnabled) {
                      setState(() {
                        _gpsEnabled = false;
                        _localRadios = [];
                      });
                    } else {
                      _fetchLocalRadios();
                    }
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : CustomScrollView(
                    slivers: [
                      if (_localRadios.isNotEmpty)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text('Local Radios', style: theme.textTheme.titleLarge),
                          ),
                        ),
                      if (_localRadios.isNotEmpty)
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final station = _localRadios[index];
                              final isPlaying = context.watch<PlaybarBloc>().state is PlaybarPlaying &&
                                  (context.watch<PlaybarBloc>().state as PlaybarPlaying).station == station;
                              return ListTile(
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
                                  onPressed: () => context.push('/search-details', extra: station),
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
                            childCount: _localRadios.length,
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
