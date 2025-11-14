import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/station.dart';
import '../services/station_service.dart';
import '../services/auth_service.dart';

// --- Events ---
abstract class SavedRadiosEvent extends Equatable {
  const SavedRadiosEvent();
  @override
  List<Object> get props => [];
}

class LoadSavedRadios extends SavedRadiosEvent {
  const LoadSavedRadios();
}

class UpdateSavedRadios extends SavedRadiosEvent {
  final List<Station> stations;
  const UpdateSavedRadios(this.stations);
  @override
  List<Object> get props => [stations];
}

class AddRadio extends SavedRadiosEvent {
  final Station station;
  const AddRadio(this.station);
  @override
  List<Object> get props => [station];
}

class RemoveRadio extends SavedRadiosEvent {
  final String stationuuid; // Use stationuuid for removal
  const RemoveRadio(this.stationuuid);
  @override
  List<Object> get props => [stationuuid];
}

// --- State ---
class SavedRadiosState extends Equatable {
  final List<Station> stations;
  final bool isLoading;
  final String? error;

  const SavedRadiosState({
    this.stations = const [],
    this.isLoading = false,
    this.error,
  });

  SavedRadiosState copyWith({
    List<Station>? stations,
    bool? isLoading,
    String? error,
  }) {
    return SavedRadiosState(
      stations: stations ?? this.stations,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [stations, isLoading, error];
}

// --- Bloc ---
class SavedRadiosBloc extends Bloc<SavedRadiosEvent, SavedRadiosState> {
  final StationService _stationService;
  final AuthService _authService;
  StreamSubscription<List<Station>>? _savedStationsSubscription;
  StreamSubscription<User?>? _authStateSubscription;

  SavedRadiosBloc(this._stationService, this._authService) : super(const SavedRadiosState(isLoading: true)) {
    on<LoadSavedRadios>(_onLoadSavedRadios);
    on<UpdateSavedRadios>(_onUpdateSavedRadios);
    on<AddRadio>(_onAddRadio);
    on<RemoveRadio>(_onRemoveRadio);

    _authStateSubscription = _authService.authStateChanges.listen((user) {
      if (user != null) {
        // User logged in, start listening to saved stations
        _savedStationsSubscription?.cancel(); // Cancel previous subscription if any
        _savedStationsSubscription = _stationService.getSavedStations().listen(
              (stations) => add(UpdateSavedRadios(stations)),
              onError: (e) => emit(state.copyWith(error: e.toString())),
            );
      } else {
        // User logged out, clear stations and cancel subscription
        _savedStationsSubscription?.cancel();
        emit(const SavedRadiosState(stations: []));
      }
    });
  }

  Future<void> _onLoadSavedRadios(LoadSavedRadios event, Emitter<SavedRadiosState> emit) async {
    emit(state.copyWith(isLoading: true, error: null));
    // The actual loading is handled by the stream listener in the constructor
    // This event might be used to re-trigger a refresh if needed
  }

  void _onUpdateSavedRadios(UpdateSavedRadios event, Emitter<SavedRadiosState> emit) {
    emit(state.copyWith(stations: event.stations, isLoading: false, error: null));
  }

  Future<void> _onAddRadio(AddRadio event, Emitter<SavedRadiosState> emit) async {
    try {
      await _stationService.addStation(event.station);
      // State will be updated via the stream subscription
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  Future<void> _onRemoveRadio(RemoveRadio event, Emitter<SavedRadiosState> emit) async {
    try {
      await _stationService.removeStation(event.stationuuid);
      // State will be updated via the stream subscription
    } catch (e) {
      emit(state.copyWith(error: e.toString()));
    }
  }

  @override
  Future<void> close() {
    _savedStationsSubscription?.cancel();
    _authStateSubscription?.cancel();
    return super.close();
  }
}
