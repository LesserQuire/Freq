import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/station.dart';
import '../services/audio_service.dart';

part 'playbar_event.dart';
part 'playbar_state.dart';

class PlaybarBloc extends Bloc<PlaybarEvent, PlaybarState> {
  final AudioService _audioService;

  PlaybarBloc(this._audioService) : super(PlaybarInitial()) {
    _audioService.init();

    on<Play>((event, emit) async {
      await _audioService.play(event.station.url);
      emit(PlaybarPlaying(event.station));
    });

    on<Pause>((event, emit) {
      _audioService.stop();
      if (state is PlaybarPlaying) {
        final playingState = state as PlaybarPlaying;
        emit(PlaybarPaused(playingState.station));
      }
    });

    on<Stop>((event, emit) {
      _audioService.stop();
      emit(PlaybarStopped());
    });
  }

  @override
  Future<void> close() {
    _audioService.dispose();
    return super.close();
  }
}
