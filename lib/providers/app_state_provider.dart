import 'package:flutter/material.dart';

class AppStateProvider extends ChangeNotifier {
  bool _isDarkMode = true;
  String _currentUserName = 'You';
  String? _currentUserAvatar;
  String _currentUserStatus = 'Hey there! I am using WhatsApp';
  bool _isOnline = true;
  String _lastSeen = 'now';

  bool get isDarkMode => _isDarkMode;
  String get currentUserName => _currentUserName;
  String? get currentUserAvatar => _currentUserAvatar;
  String get currentUserStatus => _currentUserStatus;
  bool get isOnline => _isOnline;
  String get lastSeen => _lastSeen;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  void updateUserName(String name) {
    _currentUserName = name;
    notifyListeners();
  }

  void updateUserAvatar(String? avatarUrl) {
    _currentUserAvatar = avatarUrl;
    notifyListeners();
  }

  void updateUserStatus(String status) {
    _currentUserStatus = status;
    notifyListeners();
  }

  void setOnline(bool online) {
    _isOnline = online;
    if (!online) {
      _lastSeen = 'last seen today at ${_getCurrentTime()}';
    }
    notifyListeners();
  }

  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}
