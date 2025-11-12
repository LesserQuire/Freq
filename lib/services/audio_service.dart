import 'dart:developer';

import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';

class AudioService {
  // Singleton instance
  static final AudioService instance = AudioService._internal();

  factory AudioService() {
    return instance;
  }

  AudioService._internal();

  final AudioPlayer _player = AudioPlayer();

  Future<void> init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.music());
    _player.playbackEventStream.listen((event) {
      log('Playback event: $event');
    }, onError: (Object e, StackTrace stackTrace) {
      log('A stream error occurred: $e');
    });
  }

  Future<void> play(String url) async {
    try {
      // Tell the system that we are about to start playing audio.
      final session = await AudioSession.instance;
      await session.setActive(true);
      await _player.setUrl(
        url,
        headers: {
          'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/117.0.0.0 Safari/537.36'
        },
      );
      _player.play();
    } catch (e, s) {
      log("Error loading audio source: $e");
      log(s.toString());
    }
  }

  Future<void> stop() async {
    await _player.stop();
    // Tell the system that we are done playing audio.
    final session = await AudioSession.instance;
    await session.setActive(false);
  }

  Future<void> dispose() async {
    await _player.dispose();
    final session = await AudioSession.instance;
    await session.setActive(false);
  }
}
