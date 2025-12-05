//import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
//import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
//import 'package:wave/wave.dart'; // optional if needed for audio reading
//import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart'; // optional if needed for conversion
//import 'package:audio_waveforms/audio_waveforms.dart'; // or any audio reader

/// Result structure
class ParkinsonInferenceResult {
  final int overallClass; // 0 = healthy, 1 = Parkinson's
  final int parkinsonSegmentCount;
  final double confidence; // percentage 0-100%
  final List<double> segmentProbabilities;

  ParkinsonInferenceResult({
    required this.overallClass,
    required this.parkinsonSegmentCount,
    required this.confidence,
    required this.segmentProbabilities,
  });
}

/// Provider to perform inference
class ParkinsonInferenceProvider extends ChangeNotifier {
  late Interpreter _embeddingInterpreter;
  late Interpreter _classifierInterpreter;

  bool _modelsLoaded = false;
  bool get modelsLoaded => _modelsLoaded;

  ParkinsonInferenceProvider() {
    _loadModels();
  }

  Future<void> _loadModels() async {
    _embeddingInterpreter = await Interpreter.fromAsset('assets/models/yamnet_5s_mean_embedding.tflite',
        options: InterpreterOptions()..threads = 4);
        print("Loaded embedding model");

    _classifierInterpreter = await Interpreter.fromAsset('assets/models/best_pd_yamnet_classifier.tflite',
        options: InterpreterOptions()..threads = 4);
        print("Loaded classifier model");
    _modelsLoaded = true;
    notifyListeners();
  }

  /// Main function: accepts raw PCM float32 audio, 16 kHz
  Future<ParkinsonInferenceResult> predictFromAudio(Float32List waveform) async {
    if (!_modelsLoaded) throw Exception('Models not loaded yet');

    const int sampleRate = 16000;
    const int segmentSamples = sampleRate * 5; // 5 sec
    int totalSegments = (waveform.length / segmentSamples).ceil();

    List<int> segmentPredictions = [];
    List<double> segmentProbabilities = [];

    for (int i = 0; i < totalSegments; i++) {
      // Calculate segment range
      int start = i * segmentSamples;
      //int end = min(start + segmentSamples, waveform.length);

      // Copy segment
      Float32List segment = Float32List(segmentSamples);
      for (int j = 0; j < segmentSamples; j++) {
        if (start + j < waveform.length) {
          segment[j] = waveform[start + j];
        } else {
          segment[j] = 0.0; // zero-pad if last segment is shorter
        }
      }

      // --- Step 1: Run embedding model ---
      // Input shape: [1, 80000]
      var input = segment.buffer.asFloat32List();
      var inputTensor = [input]; // batch dimension
      var embeddingOutput = ListReshape(List.filled(1 * 1024, 0.0)).reshape([1, 1024]);

      _embeddingInterpreter.run(inputTensor, embeddingOutput);

      // --- Step 2: Run classifier model ---
      // Input: (1, 1024)
      var classifierInput = embeddingOutput;
      var classifierOutput = ListReshape(List.filled(1 * 1, 0.0)).reshape([1, 1]);

      _classifierInterpreter.run(classifierInput, classifierOutput);

      // --- Step 3: Threshold 0.5 ---
      int predictedClass = classifierOutput[0][0] >= 0.5 ? 1 : 0;
      segmentPredictions.add(predictedClass);
      segmentProbabilities.add(classifierOutput[0][0]);
    }

    // --- Step 4: Majority voting ---
    int parkinsonCount = segmentPredictions.where((c) => c == 1).length;
    int healthyCount = segmentPredictions.where((c) => c == 0).length;
    int overallClass = parkinsonCount > healthyCount ? 1 : 0;

    // --- Step 5: Confidence percentage ---
    int maxCount = max(parkinsonCount, healthyCount);
    double confidence = (maxCount / totalSegments) * 100.0;

    return ParkinsonInferenceResult(
      overallClass: overallClass,
      parkinsonSegmentCount: parkinsonCount,
      confidence: confidence,
      segmentProbabilities: segmentProbabilities,
    );
  }
}

extension ListReshape on List {
  List reshape(List<int> dims) {
    // Simple reshape for 1D to 2D
    if (dims.length == 2) {
      int rows = dims[0];
      int cols = dims[1];
      List<List<double>> reshaped = List.generate(rows, (_) => List.filled(cols, 0.0));
      for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
          reshaped[i][j] = this[i * cols + j];
        }
      }
      return reshaped;
    } else {
      return this;
    }
  }
}
