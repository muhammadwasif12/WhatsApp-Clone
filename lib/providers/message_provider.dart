import 'package:flutter/material.dart';
import '../models/message_model.dart';
import '../data/dummy_data.dart';
import 'dart:math';

class MessageProvider extends ChangeNotifier {
  Map<String, List<Message>> _messages = {};
  Map<String, bool> _isTyping = {};
  String? _replyingTo;
  String? _replyingToMessageId;

  List<Message> getMessages(String chatId) {
    if (!_messages.containsKey(chatId)) {
      _messages[chatId] = DummyData.getMessages(chatId);
    }
    return _messages[chatId]!;
  }

  bool isTyping(String chatId) => _isTyping[chatId] ?? false;
  String? get replyingTo => _replyingTo;
  String? get replyingToMessageId => _replyingToMessageId;

  void sendMessage(String chatId, String text, {String? imageUrl, String? audioUrl}) {
    final newMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: 'me',
      text: text,
      timestamp: DateTime.now(),
      isMe: true,
      isRead: false,
      imageUrl: imageUrl,
      audioUrl: audioUrl,
    );

    if (!_messages.containsKey(chatId)) {
      _messages[chatId] = [];
    }
    _messages[chatId]!.add(newMessage);
    
    _replyingTo = null;
    _replyingToMessageId = null;
    
    notifyListeners();

    // Simulate typing and response
    _simulateResponse(chatId);
  }

  void _simulateResponse(String chatId) {
    _isTyping[chatId] = true;
    notifyListeners();

    Future.delayed(const Duration(seconds: 2), () {
      _isTyping[chatId] = false;
      
      final responses = [
        'That\'s awesome! 🎉',
        'I completely agree with you',
        'Can you explain more?',
        'Sounds good to me!',
        'I\'ll get back to you on that',
        'Perfect timing!',
        'Let me know when you\'re free',
        'Haha, that\'s funny 😂',
        'Thanks for sharing!',
        'I was just thinking about that',
      ];
      
      final response = responses[Random().nextInt(responses.length)];
      
      final replyMessage = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: 'other',
        text: response,
        timestamp: DateTime.now(),
        isMe: false,
        isRead: false,
      );

      if (!_messages.containsKey(chatId)) {
        _messages[chatId] = [];
      }
      _messages[chatId]!.add(replyMessage);
      notifyListeners();
    });
  }

  void markMessagesAsRead(String chatId) {
    if (_messages.containsKey(chatId)) {
      _messages[chatId] = _messages[chatId]!.map((msg) {
        if (!msg.isMe) {
          return Message(
            id: msg.id,
            senderId: msg.senderId,
            text: msg.text,
            timestamp: msg.timestamp,
            isMe: msg.isMe,
            isRead: true,
            imageUrl: msg.imageUrl,
            audioUrl: msg.audioUrl,
            audioDuration: msg.audioDuration,
          );
        }
        return msg;
      }).toList();
      notifyListeners();
    }
  }

  void deleteMessage(String chatId, String messageId) {
    if (_messages.containsKey(chatId)) {
      _messages[chatId]!.removeWhere((msg) => msg.id == messageId);
      notifyListeners();
    }
  }

  void starMessage(String chatId, String messageId) {
    // Implement star functionality
    notifyListeners();
  }

  void setReplyTo(String? messageText, String? messageId) {
    _replyingTo = messageText;
    _replyingToMessageId = messageId;
    notifyListeners();
  }

  void cancelReply() {
    _replyingTo = null;
    _replyingToMessageId = null;
    notifyListeners();
  }

  void forwardMessage(String fromChatId, String toChatId, String messageId) {
    if (_messages.containsKey(fromChatId)) {
      final message = _messages[fromChatId]!.firstWhere(
        (msg) => msg.id == messageId,
        orElse: () => Message(
          id: '',
          senderId: '',
          text: '',
          timestamp: DateTime.now(),
          isMe: false,
        ),
      );
      
      if (message.id.isNotEmpty) {
        if (!_messages.containsKey(toChatId)) {
          _messages[toChatId] = [];
        }
        
        final forwardedMessage = Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: 'me',
          text: message.text,
          timestamp: DateTime.now(),
          isMe: true,
          isRead: false,
          imageUrl: message.imageUrl,
          audioUrl: message.audioUrl,
        );
        
        _messages[toChatId]!.add(forwardedMessage);
        notifyListeners();
      }
    }
  }

  void clearChat(String chatId) {
    _messages[chatId] = [];
    notifyListeners();
  }
}
