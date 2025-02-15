import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerService extends ChangeNotifier {
  final AudioPlayer _player = AudioPlayer();
  bool isPlaying = false;
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  AudioPlayerService() {
    _player.onDurationChanged.listen((duration) {
      totalDuration = duration;
      notifyListeners(); // Notify UI of changes
    });

    _player.onPositionChanged.listen((position) {
      currentPosition = position;
      notifyListeners(); // Notify UI of changes
    });

    _player.onPlayerComplete.listen((event) {
      isPlaying = false;
      currentPosition = Duration.zero;
      notifyListeners(); // Notify UI of changes
    });

    _player.onPlayerStateChanged.listen((state) {
      isPlaying = state == PlayerState.playing;
      notifyListeners(); // Notify UI of changes
    });
  }
  void notify() {
    notifyListeners();
  }

  /// Load audio duration without playing it
  Future<void> loadAudioDuration(String filePath) async {
    if (await File(filePath).exists()) {
      await _player.setSource(DeviceFileSource(filePath)); // Set source
      totalDuration =
          await _player.getDuration() ?? Duration.zero; // Get duration
      notifyListeners();
    } else {
      print("File not found: $filePath");
    }
  }

  Future<void> playAudio(String filePath) async {
    if (isPlaying) {
      await _player.pause();
    } else {
      if (await File(filePath).exists()) {
        await _player.play(DeviceFileSource(filePath));
      } else {
        print("File not found: $filePath");
        return;
      }
    }
    notifyListeners(); // Ensure UI updates
  }

  Future<void> seekAudio(Duration position) async {
    await _player.seek(position);
    notifyListeners(); // Ensure UI updates
  }

  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
