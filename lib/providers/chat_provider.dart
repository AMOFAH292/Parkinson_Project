import 'package:flutter/foundation.dart';
import 'package:park_ai/services/llama_api_service.dart';

/// Represents a single message in a chat
class ChatMessage {
  final String id;
  final String content;
  final bool isUser;
  final DateTime timestamp;
  final bool isStreaming;

  ChatMessage({
    required this.id,
    required this.content,
    required this.isUser,
    required this.timestamp,
    this.isStreaming = false,
  });

  ChatMessage copyWith({
    String? id,
    String? content,
    bool? isUser,
    DateTime? timestamp,
    bool? isStreaming,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }
}

/// Represents a chat conversation
class Chat {
  final String id;
  final String title;
  final List<ChatMessage> messages;
  final DateTime lastUpdated;

  Chat({
    required this.id,
    required this.title,
    required this.messages,
    required this.lastUpdated,
  });

  Chat copyWith({
    String? id,
    String? title,
    List<ChatMessage>? messages,
    DateTime? lastUpdated,
  }) {
    return Chat(
      id: id ?? this.id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

/// Provider for managing chat functionality
class ChatProvider extends ChangeNotifier {
  final LlamaApiService _apiService = LlamaApiService();
  final List<Chat> _chats = [];
  Chat? _currentChat;
  bool _isLoading = false;
  String? _errorMessage;

  List<Chat> get chats => List.unmodifiable(_chats);
  Chat? get currentChat => _currentChat;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ChatProvider() {
    _initializeDefaultChat();
  }

  void _initializeDefaultChat() {
    final defaultChat = Chat(
      id: 'default',
      title: 'AI Assistant',
      messages: [],
      lastUpdated: DateTime.now(),
    );
    _chats.add(defaultChat);
    _currentChat = defaultChat;
  }

  /// Create a new chat
  void createNewChat() {
    final newChat = Chat(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: 'New Chat',
      messages: [],
      lastUpdated: DateTime.now(),
    );
    _chats.insert(0, newChat);
    _currentChat = newChat;
    notifyListeners();
  }

  /// Select a chat
  void selectChat(String chatId) {
    _currentChat = _chats.firstWhere((chat) => chat.id == chatId);
    notifyListeners();
  }

  /// Delete a chat
  void deleteChat(String chatId) {
    _chats.removeWhere((chat) => chat.id == chatId);
    if (_currentChat?.id == chatId) {
      _currentChat = _chats.isNotEmpty ? _chats.first : null;
    }
    notifyListeners();
  }

  /// Send a message and get streaming response
  Future<void> sendMessage(String message) async {
    if (_currentChat == null) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Add user message
      final userMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: message,
        isUser: true,
        timestamp: DateTime.now(),
      );

      _currentChat = _currentChat!.copyWith(
        messages: [..._currentChat!.messages, userMessage],
        lastUpdated: DateTime.now(),
      );

      // Update chat title if it's the first message
      if (_currentChat!.messages.length == 1) {
        _currentChat = _currentChat!.copyWith(
          title: message.length > 30 ? '${message.substring(0, 30)}...' : message,
        );
      }

      // Get response
      final response = await _apiService.sendMessage(message);
      if (response.startsWith('Error:')) {
        _errorMessage = response;
      } else {
        // Add AI message
        final aiMessage = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: response,
          isUser: false,
          timestamp: DateTime.now(),
          isStreaming: false,
        );

        _currentChat = _currentChat!.copyWith(
          messages: [..._currentChat!.messages, aiMessage],
          lastUpdated: DateTime.now(),
        );

        // Update chat list
        final chatIndex = _chats.indexWhere((chat) => chat.id == _currentChat!.id);
        if (chatIndex != -1) {
          _chats[chatIndex] = _currentChat!;
        }
      }

      notifyListeners();

    } catch (e) {
      _errorMessage = 'Failed to send message: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}