import 'package:flutter/foundation.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

/// Result structure for tremor analysis
class TremorAnalysisResult {
final String predictedClass;
final double confidence;
final List<Map<String, dynamic>> topConfidences; // top 3 with class and confidence
final Uint8List thumbnail; // small image for display

TremorAnalysisResult({
  required this.predictedClass,
  required this.confidence,
  required this.topConfidences,
  required this.thumbnail,
});
}

/// Provider for tremor analysis using TFLite MobileNetV2 model
class TremorProvider extends ChangeNotifier {
  late Interpreter _interpreter;
  bool _modelLoaded = false;
  bool get modelLoaded => _modelLoaded;

  static const List<String> classNames = [
    'spiral_healthy',
    'spiral_parkinson',
    'wave_healthy',
    'wave_parkinson'
  ];

  TremorProvider() {
    _loadModel();
  }

  Future<void> _loadModel() async {
    _interpreter = await Interpreter.fromAsset(
      'assets/models/netv2_model.tflite',
      options: InterpreterOptions()..threads = 4,
    );
    _modelLoaded = true;
    notifyListeners();
  }

  /// Preprocess image: resize to 224x224, convert to float32 RGB
  Float32List _preprocessImage(img.Image image) {
    // Resize to 224x224
    img.Image resized = img.copyResize(image, width: 224, height: 224);

    // Convert to float32 RGB (no normalization, model handles it)
    Float32List input = Float32List(224 * 224 * 3);
    int index = 0;
    for (int y = 0; y < 224; y++) {
      for (int x = 0; x < 224; x++) {
        var pixel = resized.getPixel(x, y);
        input[index++] = pixel.r.toDouble();
        input[index++] = pixel.g.toDouble();
        input[index++] = pixel.b.toDouble();
      }
    }
    return input;
  }

  /// Create thumbnail: resize to 100x100, encode as PNG
  Uint8List _createThumbnail(img.Image image) {
    img.Image thumb = img.copyResize(image, width: 100, height: 100);
    return Uint8List.fromList(img.encodePng(thumb));
  }

  /// Run inference on the image
  Future<TremorAnalysisResult> analyzeImage(Uint8List imageBytes) async {
    if (!_modelLoaded) throw Exception('Model not loaded yet');

    // Decode image
    img.Image? image = img.decodeImage(imageBytes);
    if (image == null) throw Exception('Failed to decode image');

    // Preprocess
    Float32List input = _preprocessImage(image);

    // Prepare input tensor [1, 224, 224, 3]
    var inputTensor = TremorListReshape(input).reshape([1, 224, 224, 3]);

    // Output tensor [1, 4]
    var output = TremorListReshape(List.filled(1 * 4, 0.0)).reshape([1, 4]);

    // Run inference
    _interpreter.run(inputTensor, output);

    // Get probabilities
    List<double> probabilities = output[0];

    // Find top prediction
    int topIndex = 0;
    double maxProb = probabilities[0];
    for (int i = 1; i < probabilities.length; i++) {
      if (probabilities[i] > maxProb) {
        maxProb = probabilities[i];
        topIndex = i;
      }
    }

    // Create list of class-confidence pairs
    List<Map<String, dynamic>> allConfidences = [];
    for (int i = 0; i < classNames.length; i++) {
      allConfidences.add({
        'class': classNames[i],
        'confidence': probabilities[i] * 100, // to percentage
      });
    }

    // Sort by confidence descending
    allConfidences.sort((a, b) => (b['confidence'] as double).compareTo(a['confidence'] as double));

    // Top 3
    List<Map<String, dynamic>> topConfidences = allConfidences.take(3).toList();

    // Create thumbnail
    Uint8List thumbnail = _createThumbnail(image);

    return TremorAnalysisResult(
      predictedClass: classNames[topIndex],
      confidence: maxProb * 100,
      topConfidences: topConfidences,
      thumbnail: thumbnail,
    );
  }
}

extension TremorListReshape on List {
  List reshape(List<int> dims) {
    if (dims.length == 4 && dims[0] == 1 && dims[1] == 224 && dims[2] == 224 && dims[3] == 3) {
      // For [1, 224, 224, 3]
      List<List<List<List<double>>>> reshaped = List.generate(
        1,
        (_) => List.generate(
          224,
          (_) => List.generate(
            224,
            (_) => List.filled(3, 0.0),
          ),
        ),
      );
      int idx = 0;
      for (int h = 0; h < 224; h++) {
        for (int w = 0; w < 224; w++) {
          for (int c = 0; c < 3; c++) {
            reshaped[0][h][w][c] = this[idx++];
          }
        }
      }
      return reshaped;
    } else if (dims.length == 2) {
      // For [1, 4]
      int rows = dims[0];
      int cols = dims[1];
      List<List<double>> reshaped = List.generate(rows, (_) => List.filled(cols, 0.0));
      for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
          reshaped[i][j] = this[i * cols + j];
        }
      }
      return reshaped;
    }
    return this;
  }
}