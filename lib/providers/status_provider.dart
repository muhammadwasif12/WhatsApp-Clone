import 'package:flutter/material.dart';
import '../models/status_model.dart';
import '../data/dummy_data.dart';

class StatusProvider extends ChangeNotifier {
  List<Status> _statuses = [];
  int _currentStatusIndex = 0;
  bool _isViewingStatus = false;

  List<Status> get statuses => _statuses;
  int get currentStatusIndex => _currentStatusIndex;
  bool get isViewingStatus => _isViewingStatus;

  StatusProvider() {
    _loadStatuses();
  }

  void _loadStatuses() {
    _statuses = DummyData.getStatuses();
    notifyListeners();
  }

  void viewStatus(int index) {
    _currentStatusIndex = index;
    _isViewingStatus = true;
    notifyListeners();
  }

  void closeStatus() {
    _isViewingStatus = false;
    notifyListeners();
  }

  void nextStatus() {
    if (_currentStatusIndex < _statuses.length - 1) {
      _currentStatusIndex++;
      // Mark current as viewed
      _markAsViewed(_currentStatusIndex - 1);
      notifyListeners();
    } else {
      closeStatus();
    }
  }

  void previousStatus() {
    if (_currentStatusIndex > 0) {
      _currentStatusIndex--;
      notifyListeners();
    }
  }

  void _markAsViewed(int index) {
    if (index >= 0 && index < _statuses.length) {
      final status = _statuses[index];
      if (!status.isViewed) {
        _statuses[index] = Status(
          id: status.id,
          userName: status.userName,
          avatarUrl: status.avatarUrl,
          statusImageUrl: status.statusImageUrl,
          timestamp: status.timestamp,
          isViewed: true,
          isMuted: status.isMuted,
        );
      }
    }
  }

  void addStatus(String userName, String? imageUrl) {
    final newStatus = Status(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userName: userName,
      avatarUrl: null,
      statusImageUrl: imageUrl,
      timestamp: DateTime.now(),
      isViewed: false,
    );
    _statuses.insert(1, newStatus);
    notifyListeners();
  }

  void muteStatus(String statusId) {
    final index = _statuses.indexWhere((s) => s.id == statusId);
    if (index != -1) {
      final status = _statuses[index];
      _statuses[index] = Status(
        id: status.id,
        userName: status.userName,
        avatarUrl: status.avatarUrl,
        statusImageUrl: status.statusImageUrl,
        timestamp: status.timestamp,
        isViewed: status.isViewed,
        isMuted: !status.isMuted,
      );
      notifyListeners();
    }
  }
}
