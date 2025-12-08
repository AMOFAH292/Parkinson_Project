import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:audio_waveforms/audio_waveforms.dart';
import '../providers/voice_test_provider.dart';
import 'voice_test_initial_screen.dart';
import 'voice_test_recording_screen.dart';
import 'voice_test_analysis_screen.dart';

enum ScreenState { initial, recording, analysis }

class VoiceTestScreen extends StatefulWidget {
  const VoiceTestScreen({super.key});

  @override
  State<VoiceTestScreen> createState() => _VoiceTestScreenState();
}

class _VoiceTestScreenState extends State<VoiceTestScreen> with TickerProviderStateMixin {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  bool _isRecording = false;
  bool _isPlaying = false;
  bool _isRecorderReady = false;
  String? _result;
  String? _recordedFilePath;
  List<double>? _segmentProbabilities;
  final ParkinsonInferenceProvider _provider = ParkinsonInferenceProvider();

  ScreenState currentState = ScreenState.initial;
  Timer? recordingTimer;
  int recordingDuration = 0;
  List<double> waveformData = [];
  ScrollController textScrollController = ScrollController();
  Timer? scrollTimer;
  double textScrollPosition = 0.0;
  bool isDraggingText = false;

  late RecorderController recorderController;

  List<String> lines = [];
  int currentLineIndex = 0;

  bool isPaused = false;

  // Metrics
  double pitch = 0.0;
  double volume = 0.0;
  double clarity = 0.0;
  List<double> speechPatterns = [];


  final String textToRead = """
The quick brown fox jumps over the lazy dog. This is a sample text for voice recording. Please read it aloud clearly and at a natural pace. The system will analyze your voice for potential signs of Parkinson's disease. Speak loudly enough for the microphone to capture your voice accurately. Remember to pronounce each word distinctly.
""";

  List<String> _splitIntoLines(String text, int wordsPerLine) {
    List<String> words = text.split(' ');
    List<String> lines = [];
    for (int i = 0; i < words.length; i += wordsPerLine) {
      int end = (i + wordsPerLine < words.length) ? i + wordsPerLine : words.length;
      lines.add(words.sublist(i, end).join(' '));
    }
    return lines;
  }

  @override
  void initState() {
    super.initState();
    _recorder = FlutterSoundRecorder();
    _player = FlutterSoundPlayer();
    recorderController = RecorderController();
    lines = _splitIntoLines(textToRead, 8); // 8 words per line
    _openRecorder();
  }

  @override
  void dispose() {
    if (_recorder != null && _recorder!.isRecording) {
      _stopRecording();
    }
    _recorder?.closeRecorder();
    _player?.closePlayer();
    recordingTimer?.cancel();
    scrollTimer?.cancel();
    textScrollController.dispose();
    recorderController.dispose();
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

  void _startTest() {
    setState(() {
      currentState = ScreenState.recording;
      recordingDuration = 0;
      waveformData = [];
      currentLineIndex = 0;
    });
    _startRecording();
    _startTimer();
    _startScrollingText();
  }

  Future<void> _startRecording() async {
    if (!_isRecorderReady || _isRecording) return;

    Directory docsDir = await getApplicationDocumentsDirectory();
    String path = p.join(docsDir.path, 'voice_test_full.wav');
    _recordedFilePath = path;

    setState(() {
      _isRecording = true;
      _result = 'Recording...';
    });

    await _recorder?.startRecorder(
      toFile: path,
      codec: Codec.pcm16WAV,
      sampleRate: 16000,
    );

    // Read waveform data from file periodically
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_isRecording) {
        timer.cancel();
        return;
      }
      if (File(path).existsSync()) {
        final bytes = File(path).readAsBytesSync();
        if (bytes.length > 44) {
          final data = bytes.sublist(44);
          final buffer = ByteData.sublistView(Uint8List.fromList(data));
          final samples = <double>[];
          int numSamples = min(data.length ~/ 2, 200);
          for (int i = 0; i < numSamples; i++) {
            int val = buffer.getUint16(i * 2, Endian.little);
            val = val - 32768; // convert unsigned to signed
            samples.add(val / 32768.0);
          }
          setState(() => waveformData = samples);
        }
      }
    });
  }

  void _startTimer() {
    recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        recordingDuration++;
        if (recordingDuration >= 120) {
          _stopTest();
        }
      });
    });
  }

  void _startScrollingText() {
    scrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) { // Slower pace for lines
      setState(() {
        currentLineIndex++;
        if (currentLineIndex >= lines.length) {
          currentLineIndex = lines.length - 1;
          timer.cancel();
        }
      });
    });
  }

  void _pauseOrResumeRecording() {
    if (isPaused) {
      _resumeRecording();
    } else {
      _pauseRecording();
    }
  }

  Future<void> _pauseRecording() async {
    await _recorder?.pauseRecorder();
    recordingTimer?.cancel();
    setState(() => isPaused = true);
  }

  Future<void> _resumeRecording() async {
    await _recorder?.resumeRecorder();
    _startTimer();
    setState(() => isPaused = false);
  }

  void _stopTest() {
    _stopRecording();
    recordingTimer?.cancel();
    scrollTimer?.cancel();
    setState(() {
      currentState = ScreenState.analysis;
    });
    _analyzeRecording();
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    String? path = await _recorder?.stopRecorder();
    _recordedFilePath = path;
    setState(() => _isRecording = false);
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _analyzeRecording() async {
    if (_recordedFilePath == null || !File(_recordedFilePath!).existsSync()) {
      setState(() => _result = 'Recording file not found');
      return;
    }

    setState(() => _result = 'Analyzing...');

    try {
      Float32List waveform = await _loadWavAsFloat32(_recordedFilePath!);

      // Calculate metrics
      volume = _calculateVolume(waveform);
      pitch = _calculatePitch(waveform);
      clarity = _calculateClarity(waveform);
      speechPatterns = _calculateSpeechPatterns(waveform);

      // Run inference
      final inference = await _provider.predictFromAudio(waveform);

      setState(() {
        _segmentProbabilities = inference.segmentProbabilities;
        _result =
            'Overall Class: ${inference.overallClass == 1 ? "Parkinson" : "Healthy"}\n'
            'Parkinson Segments: ${inference.parkinsonSegmentCount}\n'
            'Confidence: ${inference.confidence.toStringAsFixed(1)}%';
      });
    } catch (e) {
      setState(() => _result = 'Classification Error: $e');
    }
  }

  double _calculateVolume(Float32List waveform) {
    if (waveform.isEmpty) return 0.0;
    double maxVal = 0;
    for (var sample in waveform) {
      maxVal = max(maxVal, sample.abs());
    }
    return maxVal;
  }

  double _calculatePitch(Float32List waveform) {
    if (waveform.isEmpty) return 0.0;
    // Simple zero crossing rate for approximate pitch
    int zeroCrossings = 0;
    for (int i = 1; i < waveform.length; i++) {
      if (waveform[i - 1] * waveform[i] < 0) zeroCrossings++;
    }
    double duration = waveform.length / 16000.0; // sample rate
    double freq = zeroCrossings / (2.0 * duration);
    return freq.clamp(75, 500); // clamp to reasonable range
  }

  double _calculateClarity(Float32List waveform) {
    if (waveform.isEmpty) return 0.0;
    // Simple SNR approximation
    double signal = waveform.map((x) => x * x).reduce((a, b) => a + b) / waveform.length;
    double mean = waveform.reduce((a, b) => a + b) / waveform.length;
    double variance = waveform.map((x) => pow(x - mean, 2)).reduce((a, b) => a + b) / waveform.length;
    double noise = variance;
    if (signal + noise == 0) return 0.0;
    return signal / (signal + noise);
  }

  List<double> _calculateSpeechPatterns(Float32List waveform) {
    // Simple segmentation
    int segments = 4;
    int segmentLength = waveform.length ~/ segments;
    List<double> patterns = [];
    for (int i = 0; i < segments; i++) {
      int start = i * segmentLength;
      int end = (i + 1) * segmentLength;
      if (end > waveform.length) end = waveform.length;
      double avg = waveform.sublist(start, end).reduce((a, b) => a + b) / (end - start);
      patterns.add(avg.abs());
    }
    return patterns;
  }


  Future<Float32List> _loadWavAsFloat32(String filePath) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();

    final data = bytes.sublist(44);
    final buffer = ByteData.sublistView(Uint8List.fromList(data));
    final samples = Float32List(data.length ~/ 2);

    for (int i = 0; i < samples.length; i++) {
      int val = buffer.getUint16(i * 2, Endian.little);
      val = val - 32768; // convert unsigned to signed
      samples[i] = val / 32768.0;
    }
    return samples;
  }

  Future<void> _playRecording() async {
    if (_recordedFilePath == null || !File(_recordedFilePath!).existsSync()) {
      setState(() => _result = 'No recording to play');
      return;
    }

    try {
      await _player?.openPlayer();
      setState(() => _isPlaying = true);
      await _player?.startPlayer(fromURI: _recordedFilePath);
      _player?.onProgress?.listen((event) {
        if (event.position >= event.duration) {
          setState(() => _isPlaying = false);
        }
      });
    } catch (e) {
      setState(() => _result = 'Playback error: $e');
    }
  }

  Future<void> _stopPlaying() async {
    try {
      await _player?.stopPlayer();
      await _player?.closePlayer();
      setState(() => _isPlaying = false);
    } catch (e) {
      setState(() => _result = 'Stop playback error: $e');
    }
  }

  void _retakeTest() {
    setState(() {
      currentState = ScreenState.initial;
      _result = null;
      _segmentProbabilities = null;
      waveformData = [];
      recordingDuration = 0;
      currentLineIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Voice Test',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    switch (currentState) {
      case ScreenState.initial:
        return VoiceTestInitialScreen(onStartTest: _startTest);
      case ScreenState.recording:
        return VoiceTestRecordingScreen(
          recordingDuration: recordingDuration,
          waveformData: waveformData,
          text: textToRead,
          isPaused: isPaused,
          onPauseResume: _pauseOrResumeRecording,
          onStopTest: _stopTest,
        );
      case ScreenState.analysis:
        return VoiceTestAnalysisScreen(
          result: _result,
          clarity: clarity,
          volume: volume,
          pitch: pitch,
          onPlayRecording: _playRecording,
          onRetakeTest: _retakeTest,
          onExportResults: () {},
        );
    }
  }
}
