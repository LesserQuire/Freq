import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'playbar_event.dart';
part 'playbar_state.dart';

class PlaybarBloc extends Bloc<PlaybarEvent, PlaybarState> {
  PlaybarBloc() : super(PlaybarInitial()) {
    on<Play>((event, emit) {
      emit(PlaybarPlaying(event.station));
    });
    on<Pause>((event, emit) {
      if (state is PlaybarPlaying) {
        final playingState = state as PlaybarPlaying;
        emit(PlaybarPaused(playingState.station));
      }
    });
  }
}
