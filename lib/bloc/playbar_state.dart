part of 'playbar_bloc.dart';

abstract class PlaybarState extends Equatable {
  const PlaybarState();

  @override
  List<Object> get props => [];
}

class PlaybarInitial extends PlaybarState {}

class PlaybarPlaying extends PlaybarState {
  final String station;

  const PlaybarPlaying(this.station);

  @override
  List<Object> get props => [station];
}

class PlaybarPaused extends PlaybarState {
  final String station;

  const PlaybarPaused(this.station);

  @override
  List<Object> get props => [station];
}
