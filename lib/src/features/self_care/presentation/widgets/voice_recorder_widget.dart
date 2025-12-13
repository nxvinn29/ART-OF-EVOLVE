import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

class VoiceRecorderWidget extends StatefulWidget {
  final Function(String audioPath, int duration) onRecordingComplete;

  const VoiceRecorderWidget({super.key, required this.onRecordingComplete});

  @override
  State<VoiceRecorderWidget> createState() => _VoiceRecorderWidgetState();
}

class _VoiceRecorderWidgetState extends State<VoiceRecorderWidget> {
  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isRecording = false;
  bool _isPlaying = false;
  int _recordDuration = 0;
  Timer? _timer;
  String? _recordedFilePath;

  @override
  void dispose() {
    _timer?.cancel();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final directory = await getApplicationDocumentsDirectory();
        final path =
            '${directory.path}/voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

        await _audioRecorder.start(const RecordConfig(), path: path);

        setState(() {
          _isRecording = true;
          _recordDuration = 0;
          _recordedFilePath = null;
        });

        _startTimer();
      }
    } catch (e) {
      debugPrint('Error starting recording: $e');
    }
  }

  Future<void> _stopRecording() async {
    try {
      final path = await _audioRecorder.stop();
      _timer?.cancel();

      if (path != null) {
        setState(() {
          _isRecording = false;
          _recordedFilePath = path;
        });
        widget.onRecordingComplete(path, _recordDuration);
      }
    } catch (e) {
      debugPrint('Error stopping recording: $e');
    }
  }

  Future<void> _playRecording() async {
    if (_recordedFilePath != null && !_isPlaying) {
      setState(() => _isPlaying = true);
      await _audioPlayer.play(DeviceFileSource(_recordedFilePath!));
      _audioPlayer.onPlayerComplete.listen((event) {
        if (mounted) setState(() => _isPlaying = false);
      });
    } else {
      await _audioPlayer.stop();
      setState(() => _isPlaying = false);
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordDuration++;
      });
    });
  }

  String _formatDuration(int seconds) {
    final minutes = (seconds / 60).floor().toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          if (_recordedFilePath == null)
            IconButton(
              icon: Icon(
                _isRecording ? Icons.stop_circle : Icons.mic,
                color: _isRecording ? Colors.red : Colors.blue,
                size: 32,
              ),
              onPressed: _isRecording ? _stopRecording : _startRecording,
            )
          else
            IconButton(
              icon: Icon(
                _isPlaying ? Icons.stop : Icons.play_arrow,
                color: Colors.green,
                size: 32,
              ),
              onPressed: _playRecording,
            ),
          const SizedBox(width: 16),
          if (_isRecording) ...[
            const Text('Recording...'),
            const Spacer(),
            Text(
              _formatDuration(_recordDuration),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ] else if (_recordedFilePath != null) ...[
            const Text('Voice Note Recorded'),
            const Spacer(),
            Text(
              _formatDuration(_recordDuration),
              style: const TextStyle(color: Colors.grey),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.grey),
              onPressed: () {
                setState(() {
                  _recordedFilePath = null;
                  _recordDuration = 0;
                });
              },
            ),
          ] else
            const Text('Tap mic to record'),
        ],
      ),
    );
  }
}
