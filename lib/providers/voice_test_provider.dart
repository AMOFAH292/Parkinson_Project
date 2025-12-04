import 'dart:io';
//import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:logger/logger.dart';
import 'package:wav/wav.dart';

class VoiceTestProvider {
  Interpreter? _yamnetInterpreter;
  Interpreter? _classifierInterpreter;
  final Logger _logger = Logger();
  bool _modelsLoaded = false;

  VoiceTestProvider() {
    _loadModels();
  }

  Future<void> _loadModels() async {
    try {
      _yamnetInterpreter = await Interpreter.fromAsset(
          'assets/models/yamnet_feature_extractor.tflite', options: InterpreterOptions()..threads = 2);
      _classifierInterpreter = await Interpreter.fromAsset(
          'assets/models/best_pd_yamnet_classifier.tflite',
          options: InterpreterOptions()..threads = 2);
      _modelsLoaded = true;
      _logger.i("TFLite models loaded successfully");
    } catch (e) {
      _logger.e("Failed to load models: $e");
      _modelsLoaded = false;
    }
  }

  Future<String> classifyAudio(String filePath) async {
    if (!_modelsLoaded) {
      return "Models not loaded - TFLite version incompatibility";
    }
    final waveform = await _loadWaveform(filePath);
    final embeddings = _runYamnet(waveform);
    final label = _runClassifier(embeddings);
    return label;
  }


  Future<List<double>> _loadWaveform(String wavPath) async {
    final file = File(wavPath);
    final bytes = await file.readAsBytes();
    final wav = Wav.read(bytes);
    // Assume mono, take first channel
    final samples = wav.channels[0];
    return samples.map((s) => s.toDouble() / 32768.0).toList();
  }

  List<List<double>> _runYamnet(List<double> waveform) {
    final inputTensor = [waveform]; // shape [1, num_samples]
    final numPatches = 1; // adjust based on model output
    final embeddingSize = 1024;
    var outputTensor = List.generate(numPatches, (_) => List.filled(embeddingSize, 0.0));

    _yamnetInterpreter!.run(inputTensor, outputTensor);
    return outputTensor;
  }

  String _runClassifier(List<List<double>> embeddings) {
    List<int> predictions = [];

    for (var embedding in embeddings) {
      final input = [embedding]; // shape [1, 1024]
      var output = List.filled(1, 0.0).reshape([1, 1]);
      _classifierInterpreter!.run(input, output);
      predictions.add(output[0][0] >= 0.5 ? 1 : 0);
    }

    final meanPred = predictions.reduce((a, b) => a + b) / predictions.length;
    return meanPred >= 0.5 ? "Parkinson" : "Healthy";
  }
}