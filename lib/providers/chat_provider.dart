import 'package:flutter/material.dart';
import '../models/chat_model.dart';
import '../data/dummy_data.dart';
import 'dart:math';

class ChatProvider extends ChangeNotifier {
  List<Chat> _chats = [];
  List<Chat> _archivedChats = [];
  String _searchQuery = '';
  bool _isSearching = false;

  List<Chat> get chats => _filterChats(_chats);
  List<Chat> get archivedChats => _archivedChats;
  String get searchQuery => _searchQuery;
  bool get isSearching => _isSearching;

  ChatProvider() {
    _loadInitialData();
  }

  void _loadInitialData() {
    _chats = DummyData.getChats();
    notifyListeners();
  }

  List<Chat> _filterChats(List<Chat> chatList) {
    if (_searchQuery.isEmpty) return chatList;
    return chatList.where((chat) {
      return chat.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          chat.lastMessage.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleSearch() {
    _isSearching = !_isSearching;
    if (!_isSearching) {
      _searchQuery = '';
    }
    notifyListeners();
  }

  void markAsRead(String chatId) {
    final index = _chats.indexWhere((chat) => chat.id == chatId);
    if (index != -1) {
      _chats[index] = Chat(
        id: _chats[index].id,
        name: _chats[index].name,
        avatarUrl: _chats[index].avatarUrl,
        lastMessage: _chats[index].lastMessage,
        lastMessageTime: _chats[index].lastMessageTime,
        isUnread: false,
        unreadCount: 0,
        isGroup: _chats[index].isGroup,
        isMuted: _chats[index].isMuted,
        isPinned: _chats[index].isPinned,
        isOnline: _chats[index].isOnline,
      );
      notifyListeners();
    }
  }

  void archiveChat(String chatId) {
    final index = _chats.indexWhere((chat) => chat.id == chatId);
    if (index != -1) {
      _archivedChats.add(_chats[index]);
      _chats.removeAt(index);
      notifyListeners();
    }
  }

  void unarchiveChat(String chatId) {
    final index = _archivedChats.indexWhere((chat) => chat.id == chatId);
    if (index != -1) {
      _chats.add(_archivedChats[index]);
      _archivedChats.removeAt(index);
      notifyListeners();
    }
  }

  void deleteChat(String chatId) {
    _chats.removeWhere((chat) => chat.id == chatId);
    _archivedChats.removeWhere((chat) => chat.id == chatId);
    notifyListeners();
  }

  void pinChat(String chatId) {
    final index = _chats.indexWhere((chat) => chat.id == chatId);
    if (index != -1) {
      final chat = _chats[index];
      _chats[index] = Chat(
        id: chat.id,
        name: chat.name,
        avatarUrl: chat.avatarUrl,
        lastMessage: chat.lastMessage,
        lastMessageTime: chat.lastMessageTime,
        isUnread: chat.isUnread,
        unreadCount: chat.unreadCount,
        isGroup: chat.isGroup,
        isMuted: chat.isMuted,
        isPinned: !chat.isPinned,
        isOnline: chat.isOnline,
      );
      _sortChats();
      notifyListeners();
    }
  }

  void muteChat(String chatId) {
    final index = _chats.indexWhere((chat) => chat.id == chatId);
    if (index != -1) {
      final chat = _chats[index];
      _chats[index] = Chat(
        id: chat.id,
        name: chat.name,
        avatarUrl: chat.avatarUrl,
        lastMessage: chat.lastMessage,
        lastMessageTime: chat.lastMessageTime,
        isUnread: chat.isUnread,
        unreadCount: chat.unreadCount,
        isGroup: chat.isGroup,
        isMuted: !chat.isMuted,
        isPinned: chat.isPinned,
        isOnline: chat.isOnline,
      );
      notifyListeners();
    }
  }

  void _sortChats() {
    _chats.sort((a, b) {
      if (a.isPinned && !b.isPinned) return -1;
      if (!a.isPinned && b.isPinned) return 1;
      return b.lastMessageTime.compareTo(a.lastMessageTime);
    });
  }

  void sendMessage(String chatId, String text) {
    final index = _chats.indexWhere((chat) => chat.id == chatId);
    if (index != -1) {
      final chat = _chats[index];
      _chats[index] = Chat(
        id: chat.id,
        name: chat.name,
        avatarUrl: chat.avatarUrl,
        lastMessage: text,
        lastMessageTime: DateTime.now(),
        isUnread: false,
        unreadCount: 0,
        isGroup: chat.isGroup,
        isMuted: chat.isMuted,
        isPinned: chat.isPinned,
        isOnline: chat.isOnline,
      );
      _sortChats();
      notifyListeners();
    }
  }

  void simulateIncomingMessage(String chatId) {
    final index = _chats.indexWhere((chat) => chat.id == chatId);
    if (index != -1) {
      final responses = [
        'That sounds great! 👍',
        'I\'ll check and get back to you',
        'Can you send me the details?',
        'Thanks for letting me know!',
        'See you soon! 😊',
        'Let me think about it',
        'Perfect!',
      ];
      final randomResponse = responses[Random().nextInt(responses.length)];
      
      final chat = _chats[index];
      _chats[index] = Chat(
        id: chat.id,
        name: chat.name,
        avatarUrl: chat.avatarUrl,
        lastMessage: randomResponse,
        lastMessageTime: DateTime.now(),
        isUnread: true,
        unreadCount: chat.unreadCount + 1,
        isGroup: chat.isGroup,
        isMuted: chat.isMuted,
        isPinned: chat.isPinned,
        isOnline: chat.isOnline,
      );
      _sortChats();
      notifyListeners();
    }
  }

  void updateOnlineStatus(String chatId, bool isOnline) {
    final index = _chats.indexWhere((chat) => chat.id == chatId);
    if (index != -1) {
      final chat = _chats[index];
      _chats[index] = Chat(
        id: chat.id,
        name: chat.name,
        avatarUrl: chat.avatarUrl,
        lastMessage: chat.lastMessage,
        lastMessageTime: chat.lastMessageTime,
        isUnread: chat.isUnread,
        unreadCount: chat.unreadCount,
        isGroup: chat.isGroup,
        isMuted: chat.isMuted,
        isPinned: chat.isPinned,
        isOnline: isOnline,
      );
      notifyListeners();
    }
  }
}
