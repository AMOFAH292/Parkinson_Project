import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import '../providers/voice_test_provider.dart';

class VoiceTestScreen extends StatefulWidget {
  const VoiceTestScreen({super.key});

  @override
  State<VoiceTestScreen> createState() => _VoiceTestScreenState();
}

class _VoiceTestScreenState extends State<VoiceTestScreen> {
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  bool _isRecorderReady = false;
  String? _result;
  Timer? _timer;
  final VoiceTestProvider _provider = VoiceTestProvider();

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _openRecorder();
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _openRecorder() async {
    try {
      await _recorder?.openRecorder();
      setState(() {
        _isRecorderReady = true;
      });
      print('Recorder opened successfully');
    } catch (e) {
      print('Failed to open recorder: $e');
    }
  }

  Future<void> _startRecording() async {
    print('Start recording called');
    if (!_isRecorderReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recorder not ready, please wait')),
      );
      return;
    }
    var status = await Permission.microphone.request();
    print('Permission status: $status');
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Microphone permission denied')),
      );
      return;
    }

    Directory docsDir = await getApplicationDocumentsDirectory();
    String path = p.join(docsDir.path, 'voice_test.wav');
    print('Recording to: $path');

    setState(() {
      _isRecording = true;
      _result = null;
    });

    try {
      await _recorder?.startRecorder(
        toFile: path,
        codec: Codec.pcm16WAV,
      );
      print('Recording started');

      _timer = Timer(const Duration(seconds: 10), _stopRecording);
    } catch (e) {
      print('Failed to start recording: $e');
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _stopRecording() async {
    await _recorder?.stopRecorder();
    setState(() {
      _isRecording = false;
    });
    _timer?.cancel();

    Directory docsDir = await getApplicationDocumentsDirectory();
    String path = p.join(docsDir.path, 'voice_test.wav');
    print('File exists: ${File(path).existsSync()}');

    try {
      String result = await _provider.classifyAudio(path);
      setState(() {
        _result = result;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Voice Test',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey.withValues(alpha: 0.5),
            width: 0.6,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isRecording ? Icons.mic : Icons.mic_none,
                  size: 150,
                  color: _isRecording ? Colors.red : const Color(0xFF2196F3),
                ),
                const SizedBox(height: 40),
                Text(
                  _isRecording ? 'Recording...' : 'Prepare for Voice Test',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _isRecording
                      ? 'Recording for 10 seconds...'
                      : 'Speak clearly and consistently into the microphone for about 10-15 seconds. Ensure you are in a quiet environment for accurate results.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                    height: 1.5,
                  ),
                ),
                if (_result != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    'Result: $_result',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isRecording ? null : _startRecording,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isRecording ? Colors.grey : const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  _isRecording ? 'Recording...' : 'Start Recording',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}