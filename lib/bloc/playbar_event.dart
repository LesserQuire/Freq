part of 'playbar_bloc.dart';

abstract class PlaybarEvent extends Equatable {
  const PlaybarEvent();

  @override
  List<Object> get props => [];
}

class Play extends PlaybarEvent {
  final Station station;

  const Play(this.station);

  @override
  List<Object> get props => [station];
}

class Pause extends PlaybarEvent {}

class Stop extends PlaybarEvent {}
