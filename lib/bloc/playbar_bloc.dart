import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/station.dart';
import '../services/audio_service.dart';

part 'playbar_event.dart';
part 'playbar_state.dart';

class PlaybarBloc extends Bloc<PlaybarEvent, PlaybarState> {
  final AudioService _audioService;

  PlaybarBloc(this._audioService) : super(PlaybarInitial()) {
    on<Play>((event, emit) {
      _audioService.play(event.station.url);
      emit(PlaybarPlaying(event.station));
    });
    on<Pause>((event, emit) {
      if (state is PlaybarPlaying) {
        _audioService.stop();
        emit(PlaybarPaused((state as PlaybarPlaying).station));
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
