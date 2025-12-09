import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Singleton service class for interacting with the Llama streaming API.
class LlamaApiService {
  static final LlamaApiService _instance = LlamaApiService._internal();

  factory LlamaApiService() => _instance;

  LlamaApiService._internal();

  final http.Client _client = http.Client();

  /// Sends a message to the Llama API and returns the parsed message text as a string.
  Future<String> sendMessage(String message) async {
    try {
      print('Sending message to Llama API: $message');

      final response = await http.post(
        Uri.parse('https://llama-chat-yxku.onrender.com/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'prompt': message}),
      ).timeout(const Duration(seconds: 60));

      if (response.statusCode == 422) {
        return 'Error: Invalid request format. Please check your message and try again.';
      } else if (response.statusCode != 200) {
        return 'Error: API error: ${response.statusCode} - ${response.reasonPhrase}';
      }

      print('Response received, status: ${response.statusCode}');
      try {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final String message = jsonResponse['response'] as String;
        return message;
      } catch (e) {
        print('JSON parsing error: $e');
        return 'Error: Failed to parse response';
      }
    } on TimeoutException catch (e) {
      print('Timeout error: $e');
      return 'Error: Request timed out';
    } on http.ClientException catch (e) {
      print('Network error: $e');
      return 'Error: Network issue - $e';
    } catch (e) {
      print('Unexpected error: $e');
      return 'Error: $e';
    }
  }
}