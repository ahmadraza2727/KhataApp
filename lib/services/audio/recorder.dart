import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

Future<bool> requestMicrophonePermission() async {
  final status = await Permission.microphone.request();
  return status.isGranted;
}

class AudioRecorder {
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _filePath;

  Future<void> initRecorder() async {
    _recorder = FlutterSoundRecorder();
    await _recorder!.openRecorder();
  }

  Future<bool> startRecording() async {
    if (!await requestMicrophonePermission()) {
      // print("Microphone permission denied");
      return false;
    }

    final dir = await getApplicationDocumentsDirectory();
    _filePath =
        "${dir.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac";

    await _recorder!.startRecorder(toFile: _filePath!);
    _isRecording = true;
    return true;
    // print("Recording started: $_filePath");
  }

  Future<void> stopRecording() async {
    if (!_isRecording) return;
    await _recorder!.stopRecorder();
    _isRecording = false;
    // print("Recording saved: $_filePath");
  }

  String? get filePath => _filePath; // Get the file path of recorded audio
}
