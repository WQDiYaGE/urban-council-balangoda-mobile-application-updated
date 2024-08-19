import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';

class AudioRecorderBottomSheet extends StatefulWidget {
  const AudioRecorderBottomSheet({super.key});

  @override
  _AudioRecorderBottomSheetState createState() =>
      _AudioRecorderBottomSheetState();
}

class _AudioRecorderBottomSheetState extends State<AudioRecorderBottomSheet> {
  FlutterSoundRecorder? _audioRecorder;
  bool isRecording = false;
  String? _filePath;

  @override
  void initState() {
    super.initState();
    _audioRecorder = FlutterSoundRecorder();
    _audioRecorder!.openRecorder();
  }

  Future<void> _initRecorder() async {
    await _audioRecorder!.openRecorder();
  }

  @override
  void dispose() {
    _audioRecorder!.closeRecorder();
    super.dispose();
  }

  Future<void> _startRecording() async {
    final directory = await getApplicationDocumentsDirectory();
    final path =
        '${directory.path}/audio_${DateTime.now().millisecondsSinceEpoch}.aac';
    await _audioRecorder!.startRecorder(toFile: path);
    setState(() {
      isRecording = true;
      _filePath = path;
    });
  }

  Future<void> _stopRecording() async {
    await _audioRecorder!.stopRecorder();
    setState(() {
      isRecording = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      height: 200,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(isRecording
              ? 'Recording...'
              : 'Press the button to start recording'),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () async {
              if (isRecording) {
                await _stopRecording();
                Navigator.pop(context, _filePath);
              } else {
                await _startRecording();
              }
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.blue[600],
                  borderRadius: BorderRadius.circular(30)),
              child: Icon(
                isRecording ? Icons.stop : Icons.mic,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
