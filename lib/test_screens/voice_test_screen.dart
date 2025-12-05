import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
//import 'package:wave/wave.dart'; // for reading WAV PCM
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
  final ParkinsonInferenceProvider _provider = ParkinsonInferenceProvider();

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _openRecorder();
  }

  @override
  void dispose() {
    if (_recorder != null && _recorder!.isRecording) {
      _stopRecording();
    }
    _recorder?.closeRecorder();
    super.dispose();
  }

  Future<void> _openRecorder() async {
    var status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      setState(() => _result = 'Microphone permission denied');
      return;
    }

    try {
      await _recorder?.openRecorder();
      setState(() => _isRecorderReady = true);
    } catch (e) {
      setState(() => _result = 'Failed to open recorder: $e');
    }
  }

  Future<void> _startRecording() async {
    if (!_isRecorderReady || _isRecording) return;

    Directory docsDir = await getApplicationDocumentsDirectory();
    String path = p.join(docsDir.path, 'voice_test_full.wav');

    setState(() {
      _isRecording = true;
      _result = 'Recording...';
    });

    await _recorder?.startRecorder(
      toFile: path,
      codec: Codec.pcm16WAV,
      sampleRate: 16000,
    );
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    String? path = await _recorder?.stopRecorder();
    setState(() => _isRecording = false);
    await Future.delayed(const Duration(milliseconds: 500));

    if (path == null || !File(path).existsSync()) {
      setState(() => _result = 'Recording file not found');
      return;
    }

    setState(() => _result = 'Analyzing...');

    try {
      // --- Convert WAV file to Float32List PCM ---
      Float32List waveform = await _loadWavAsFloat32(path);

      // --- Run inference ---
      final inference = await _provider.predictFromAudio(waveform);

      setState(() {
        _result =
            'Overall Class: ${inference.overallClass == 1 ? "Parkinson" : "Healthy"}\n'
            'Parkinson Segments: ${inference.parkinsonSegmentCount}\n'
            'Confidence: ${inference.confidence.toStringAsFixed(1)}%';
      });
    } catch (e) {
      setState(() => _result = 'Classification Error: $e');
    }
  }

  // --- Helper: Load WAV file as Float32List ---
  Future<Float32List> _loadWavAsFloat32(String filePath) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();

    // WAV file header is 44 bytes (PCM16)
    final data = bytes.sublist(44);
    final buffer = ByteData.sublistView(Uint8List.fromList(data));
    final samples = Float32List(data.length ~/ 2);

    for (int i = 0; i < samples.length; i++) {
      int val = buffer.getInt16(i * 2, Endian.little);
      samples[i] = val / 32768.0; // normalize to [-1.0, 1.0]
    }
    return samples;
  }

  @override
  Widget build(BuildContext context) {
    bool canStart = _isRecorderReady && !_isRecording;
    bool canStop = _isRecording;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Voice Test',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _isRecording ? Icons.mic : Icons.mic_none,
              size: 150,
              color: _isRecording ? Colors.red : (canStart ? Colors.blue : Colors.grey),
            ),
            const SizedBox(height: 40),
            Text(
              _isRecording ? 'Recording...' : 'Prepare for Voice Test',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (_result != null) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _result!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _result!.contains('Parkinson') ? Colors.red.shade800 : Colors.green.shade800,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: canStart ? _startRecording : null,
                      child: Text(
                        _isRecording ? 'Recording...' : 'Start Recording',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: canStop ? _stopRecording : null,
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text(
                        'Stop & Analyze',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
