import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class AudioService {
  final AudioPlayer _player = AudioPlayer();

  Future<void> init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
  }

  Future<void> play(String url) async {
    try {
      await _player.setUrl(url);
      _player.play();
    } catch (e) {
      print("Error loading audio source: $e");
    }
  }

  void stop() {
    _player.stop();
  }

  void dispose() {
    _player.dispose();
  }
}
