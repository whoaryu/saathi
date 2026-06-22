import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:saathi/core/services/api_service.dart';
import 'package:saathi/features/chatbot/domain/models/chat_message.dart';

class GeminiService {
  String get _aiBaseUrl {
    try {
      final uri = Uri.parse(ApiService.baseUrl);
      // Construct the AI microservice URL dynamically based on the current Node.js host IP
      return '${uri.scheme}://${uri.host}:8000';
    } catch (e) {
      print('⚠️ Failed parsing ApiService.baseUrl: $e. Falling back to default IP.');
      return 'http://192.168.29.188:8000';
    }
  }

  Future<String> generateResponse(
    String userMessage,
    List<ChatMessage> conversationHistory,
    String userId,
  ) async {
    try {
      print('🤖 Sending message to FastAPI AI Microservice for User ID: $userId');
      
      // Convert conversation history to JSON compatible with FastAPI schema
      final List<Map<String, dynamic>> historyJson = [];
      
      // Limit to last 10 messages for performance and context limits
      final recentHistory = conversationHistory.length > 10 
          ? conversationHistory.sublist(conversationHistory.length - 10)
          : conversationHistory;

      for (final msg in recentHistory) {
        historyJson.add({
          'id': msg.id,
          'content': msg.content,
          'type': msg.type == MessageType.user ? 'user' : 'bot',
          'timestamp': msg.timestamp.toIso8601String(),
        });
      }

      final url = '$_aiBaseUrl/api/chat/message';
      print('📤 Requesting URL: $url');

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'user_id': userId,
          'message': userMessage,
          'history': historyJson,
        }),
      );

      print('📥 Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final botMessage = data['bot_message'];
        return botMessage['content'] as String;
      } else {
        print('❌ FastAPI server error: ${response.statusCode} - ${response.body}');
        return 'I\'m sorry, I\'m having difficulty processing that request right now. Please try again.';
      }
    } catch (e) {
      print('❌ Gemini Service error: $e');
      return 'Sorry, I\'m having trouble connecting to my brain right now. Please check your internet connection.';
    }
  }

  // Fallback local mock response in case the server is offline entirely
  String getMockResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    
    if (lowerMessage.contains('hello') || lowerMessage.contains('hi')) {
      return 'Hello! 👋 I\'m Saathi, your pet training assistant. How can I help you with your furry friend today?';
    } else if (lowerMessage.contains('dog') && lowerMessage.contains('train')) {
      return 'Great question! 🐕 For dog training, start with basic commands like "sit" and "stay". Use positive reinforcement with treats and praise. Keep sessions short (5-10 minutes) and consistent.';
    } else if (lowerMessage.contains('cat') && lowerMessage.contains('train')) {
      return 'Cats can be trained too! 😸 Use clicker training and treats. Start with simple commands like "come" or "sit".';
    } else {
      return 'That\'s an interesting question! 🤔 I\'d love to help you with pet training. Could you provide more details about your specific situation?';
    }
  }
}