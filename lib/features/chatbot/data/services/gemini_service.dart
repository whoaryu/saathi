import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:saathi/features/chatbot/domain/models/chat_message.dart';

class GeminiService {
  static const String _baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';
  static const String _apiKey = ''; // Replace with actual API key

  Future<String> generateResponse(String userMessage, List<ChatMessage> conversationHistory) async {
    try {
      print('🤖 Generating response for: "$userMessage"');
      
      // Prepare conversation context
      final List<Map<String, dynamic>> messages = [];
      
      // Add system prompt for pet training context
      messages.add({
        'role': 'user',
        'parts': [{
          'text': '''You are Saathi, a specialized pet training and pet care assistant. You ONLY answer questions related to:

PET TRAINING:
- Dog training techniques and commands
- Cat training methods
- Bird training and behavior
- Puppy and kitten training
- Housebreaking and potty training
- Obedience training
- Behavior modification
- Training schedules and routines

PET CARE:
- Pet health and wellness
- Pet nutrition and diet
- Pet exercise and enrichment
- Pet grooming and hygiene
- Pet socialization
- Pet safety and first aid
- Pet behavior understanding

IMPORTANT RULES:
1. ONLY answer questions about pets, pet training, and pet care
2. If asked about anything else (coding, math, history, etc.), politely redirect to pet topics
3. Keep responses friendly, practical, and actionable
4. Use emojis occasionally to make responses engaging
5. Always provide specific, helpful advice for pet owners
6. If unsure about a pet topic, suggest consulting a veterinarian or professional trainer

Example responses for off-topic questions:
- "I'm specialized in pet training and care! 🐕🐱 I'd be happy to help with any questions about your furry friends instead."
- "That's outside my expertise! I focus on helping pet owners with training and care. What pet-related questions do you have?"
- "I'm your pet training assistant! 🐾 Let's talk about your pets instead. How can I help with training or care?"'''
        }]
      });
      
      // Add conversation history (last 5 messages for context)
      final recentMessages = conversationHistory.take(5).toList();
      for (final message in recentMessages) {
        messages.add({
          'role': message.type == MessageType.user ? 'user' : 'model',
          'parts': [{'text': message.content}]
        });
      }
      
      // Add current user message
      messages.add({
        'role': 'user',
        'parts': [{'text': userMessage}]
      });

      print('📤 Sending request to Gemini API...');
      print('🔑 Using API key: ${_apiKey.substring(0, 10)}...');

      final response = await http.post(
        Uri.parse('$_baseUrl?key=$_apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'contents': messages,
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 500,
          },
        }),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📄 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Check for error in response
        if (data.containsKey('error')) {
          print('❌ Gemini API Error: ${data['error']}');
          return 'I\'m having trouble connecting to my brain right now. Please try again in a moment.';
        }
        
        final candidates = data['candidates'] as List?;
        if (candidates != null && candidates.isNotEmpty) {
          final content = candidates[0]['content'];
          final parts = content['parts'] as List?;
          if (parts != null && parts.isNotEmpty) {
            final responseText = parts[0]['text'] as String;
            print('✅ Generated response: "$responseText"');
            
            // Safety check: if response seems off-topic, redirect to pet topics
            if (_isOffTopicResponse(responseText, userMessage)) {
              return 'I\'m specialized in pet training and care! 🐕🐱 I\'d be happy to help with any questions about your furry friends instead. What pet-related questions do you have?';
            }
            
            return responseText;
          }
        }
        
        print('⚠️ No valid response structure found');
        return 'I apologize, but I couldn\'t generate a proper response at the moment. Please try again.';
      } else {
        print('❌ HTTP Error: ${response.statusCode} - ${response.body}');
        return 'I\'m having trouble connecting right now. Please check your internet connection and try again.';
      }
    } catch (e) {
      print('❌ Gemini Service Error: $e');
      return 'Sorry, I encountered an error. Please try again later.';
    }
  }

  // Mock response for testing when API key is not available
  String getMockResponse(String userMessage) {
    final lowerMessage = userMessage.toLowerCase();
    
    if (lowerMessage.contains('hello') || lowerMessage.contains('hi')) {
      return 'Hello! 👋 I\'m Saathi, your pet training assistant. How can I help you with your furry friend today?';
    } else if (lowerMessage.contains('dog') && lowerMessage.contains('train')) {
      return 'Great question! 🐕 For dog training, start with basic commands like "sit" and "stay". Use positive reinforcement with treats and praise. Keep sessions short (5-10 minutes) and consistent. What specific behavior are you working on?';
    } else if (lowerMessage.contains('cat') && lowerMessage.contains('train')) {
      return 'Cats can be trained too! 😸 Use clicker training and treats. Start with simple commands like "come" or "sit". Be patient - cats learn at their own pace. What would you like to teach your cat?';
    } else if (lowerMessage.contains('bark') || lowerMessage.contains('noise')) {
      return 'Excessive barking can be challenging! 🐕 Try identifying the trigger (boredom, attention, fear). Provide mental stimulation, exercise, and teach the "quiet" command. Would you like specific techniques for your situation?';
    } else if (lowerMessage.contains('litter') || lowerMessage.contains('potty')) {
      return 'Litter box issues are common! 🐱 Ensure the box is clean, in a quiet location, and the right size. Try different litter types if needed. How long has this been happening?';
    } else if (lowerMessage.contains('aggressive') || lowerMessage.contains('bite')) {
      return 'Aggression needs careful handling! 🚨 First, identify the trigger. Never punish - use positive reinforcement. Consider consulting a professional trainer. What type of aggression are you seeing?';
    } else if (lowerMessage.contains('puppy') || lowerMessage.contains('young')) {
      return 'Puppies are like sponges! 🐾 Start training early with socialization and basic commands. Use crate training for housebreaking. Be consistent and patient. How old is your puppy?';
    } else if (lowerMessage.contains('exercise') || lowerMessage.contains('energy')) {
      return 'High energy pets need outlets! ⚡ Provide daily exercise, mental stimulation, and structured playtime. Consider puzzle toys and training sessions. What type of pet do you have?';
    } else if (lowerMessage.contains('food') || lowerMessage.contains('diet')) {
      return 'Nutrition is key! 🍽️ Feed high-quality food appropriate for your pet\'s age and size. Use treats sparingly for training. Always provide fresh water. Any specific dietary concerns?';
    } else if (lowerMessage.contains('social') || lowerMessage.contains('other pets')) {
      return 'Socialization is important! 🤝 Introduce pets gradually in neutral territory. Use positive reinforcement and never force interactions. How are your pets currently getting along?';
    } else if (lowerMessage.contains('vet') || lowerMessage.contains('health')) {
      return 'Health comes first! 🏥 Regular vet checkups are essential. Watch for changes in behavior, appetite, or energy. Don\'t hesitate to consult your vet for concerns. Any specific health issues?';
    } else if (lowerMessage.contains('thank') || lowerMessage.contains('thanks')) {
      return 'You\'re welcome! 😊 I\'m here to help with all your pet training questions. Feel free to ask anything anytime!';
    } else if (lowerMessage.contains('bye') || lowerMessage.contains('goodbye')) {
      return 'Goodbye! 👋 Feel free to come back anytime for more pet training advice. Good luck with your furry friend!';
    } else {
      return 'That\'s an interesting question! 🤔 I\'d love to help you with pet training. Could you provide more details about your specific situation or what you\'d like to achieve? I can help with training techniques, behavior issues, pet care, and more!';
    }
  }

  bool _isOffTopicResponse(String response, String userMessage) {
    final lowerResponse = response.toLowerCase();
    final lowerUserMessage = userMessage.toLowerCase();
    
    // Keywords that indicate off-topic responses
    final offTopicKeywords = [
      'python', 'javascript', 'java', 'coding', 'programming', 'code',
      'algorithm', 'function', 'variable', 'loop', 'database', 'api',
      'mathematics', 'algebra', 'calculus', 'geometry', 'statistics',
      'history', 'politics', 'economics', 'geography', 'science',
      'chemistry', 'physics', 'biology', 'astronomy', 'geology',
      'cooking', 'recipes', 'food', 'restaurant', 'cuisine',
      'travel', 'vacation', 'tourism', 'hotel', 'flight',
      'business', 'marketing', 'finance', 'investment', 'stock',
      'sports', 'football', 'basketball', 'tennis', 'golf',
      'music', 'art', 'literature', 'poetry', 'novel',
      'technology', 'computer', 'software', 'hardware', 'internet'
    ];
    
    // Check if response contains off-topic keywords
    for (final keyword in offTopicKeywords) {
      if (lowerResponse.contains(keyword) && !_isPetRelated(lowerUserMessage)) {
        return true;
      }
    }
    
    // Check if response is too generic and doesn't mention pets
    if (!_containsPetKeywords(lowerResponse) && !_isPetRelated(lowerUserMessage)) {
      return true;
    }
    
    return false;
  }
  
  bool _isPetRelated(String message) {
    final petKeywords = [
      'pet', 'dog', 'cat', 'bird', 'puppy', 'kitten', 'animal',
      'train', 'training', 'behavior', 'care', 'health', 'food',
      'exercise', 'groom', 'vet', 'veterinarian', 'adopt', 'adoption'
    ];
    
    return petKeywords.any((keyword) => message.contains(keyword));
  }
  
  bool _containsPetKeywords(String response) {
    final petKeywords = [
      'pet', 'dog', 'cat', 'bird', 'puppy', 'kitten', 'animal',
      'train', 'training', 'behavior', 'care', 'health', 'food',
      'exercise', 'groom', 'vet', 'veterinarian', 'adopt', 'adoption',
      '🐕', '🐱', '🐦', '🐾', '🏥', '🍽️', '⚡'
    ];
    
    return petKeywords.any((keyword) => response.contains(keyword));
  }
} 