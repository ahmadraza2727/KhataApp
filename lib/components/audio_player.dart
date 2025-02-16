import 'package:app_1/services/audio/player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AudioPlayerWidget extends StatelessWidget {
  final String recordingPath;

  const AudioPlayerWidget({super.key, required this.recordingPath});

  @override
  Widget build(BuildContext context) {
    final playerService = Provider.of<AudioPlayerService>(context);
    playerService.loadAudioDuration(recordingPath);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title and Duration
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Recording $recordingPath ",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              _formatDuration(playerService.totalDuration),
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Progress Bar
        Slider(
          min: 0,
          max: playerService.totalDuration.inSeconds.toDouble(),
          value: playerService.currentPosition.inSeconds.toDouble().clamp(
              0,
              playerService.totalDuration.inSeconds
                  .toDouble()), // Ensures no overflow
          onChanged: (value) {
            // Updates UI instantly while sliding
            playerService.currentPosition = Duration(seconds: value.toInt());
            playerService.notify();
          },
          onChangeEnd: (value) async {
            // Actually seek to the selected position after user stops dragging
            final position = Duration(seconds: value.toInt());
            await playerService.seekAudio(position);
          },
        ),

        // Controls
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _formatDuration(playerService.currentPosition),
              style: const TextStyle(color: Colors.grey),
            ),

            // Play/Pause Button
            IconButton(
              icon: Icon(
                playerService.isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_fill,
                size: 40,
                color: Colors.blue,
              ),
              onPressed: () => playerService.playAudio(recordingPath),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}";
  }
}
