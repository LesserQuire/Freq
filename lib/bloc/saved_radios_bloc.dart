import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/station.dart';

// --- Events ---
abstract class SavedRadiosEvent extends Equatable {
  const SavedRadiosEvent();
  @override
  List<Object> get props => [];
}

class AddRadio extends SavedRadiosEvent {
  final Station station;
  const AddRadio(this.station);
  @override
  List<Object> get props => [station];
}

class RemoveRadio extends SavedRadiosEvent {
  final Station station;
  const RemoveRadio(this.station);
  @override
  List<Object> get props => [station];
}

// --- State ---
class SavedRadiosState extends Equatable {
  final List<Station> stations;
  const SavedRadiosState({this.stations = const []});

  @override
  List<Object> get props => [stations];
}

// --- Bloc ---
class SavedRadiosBloc extends Bloc<SavedRadiosEvent, SavedRadiosState> {
  SavedRadiosBloc() : super(const SavedRadiosState()) {
    on<AddRadio>(_onAddRadio);
    on<RemoveRadio>(_onRemoveRadio);
  }

  void _onAddRadio(AddRadio event, Emitter<SavedRadiosState> emit) {
    final List<Station> updatedList = List.from(state.stations);
    if (!updatedList.contains(event.station)) {
      updatedList.add(event.station);
      emit(SavedRadiosState(stations: updatedList));
    }
  }

  void _onRemoveRadio(RemoveRadio event, Emitter<SavedRadiosState> emit) {
    final List<Station> updatedList = List.from(state.stations)
      ..remove(event.station);
    emit(SavedRadiosState(stations: updatedList));
  }
}
