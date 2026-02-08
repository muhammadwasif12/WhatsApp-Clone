import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../models/status_model.dart';
import '../models/call_model.dart';

class DummyData {
  static List<Chat> getChats() {
    return [
      Chat(
        id: '1',
        name: 'Family Group',
        lastMessage: 'Mom: See you at dinner! 🍽️',
        lastMessageTime: DateTime.now().subtract(Duration(minutes: 2)),
        isUnread: true,
        unreadCount: 5,
        isGroup: true,
        isPinned: true,
      ),
      Chat(
        id: '2',
        name: 'John Doe',
        lastMessage: 'Can we meet tomorrow?',
        lastMessageTime: DateTime.now().subtract(Duration(minutes: 15)),
        isUnread: true,
        unreadCount: 1,
        isOnline: true,
      ),
      Chat(
        id: '3',
        name: 'Sarah Smith',
        lastMessage: 'Thanks for the help! 🙏',
        lastMessageTime: DateTime.now().subtract(Duration(hours: 1)),
        isUnread: false,
        isMuted: true,
      ),
      Chat(
        id: '4',
        name: 'Work Team',
        lastMessage: 'Meeting rescheduled to 3 PM',
        lastMessageTime: DateTime.now().subtract(Duration(hours: 2)),
        isGroup: true,
      ),
      Chat(
        id: '5',
        name: 'Mike Johnson',
        lastMessage: 'Photo',
        lastMessageTime: DateTime.now().subtract(Duration(hours: 3)),
        isUnread: true,
        unreadCount: 3,
      ),
      Chat(
        id: '6',
        name: 'Emma Wilson',
        lastMessage: 'Voice message',
        lastMessageTime: DateTime.now().subtract(Duration(hours: 5)),
        isMuted: true,
      ),
      Chat(
        id: '7',
        name: 'David Brown',
        lastMessage: 'Great idea! 💡',
        lastMessageTime: DateTime.now().subtract(Duration(hours: 8)),
      ),
      Chat(
        id: '8',
        name: 'Best Friends',
        lastMessage: 'Alice: Who\'s up for movie night? 🎬',
        lastMessageTime: DateTime.now().subtract(Duration(days: 1)),
        isGroup: true,
        isPinned: true,
      ),
      Chat(
        id: '9',
        name: 'Lisa Anderson',
        lastMessage: 'Happy Birthday! 🎉',
        lastMessageTime: DateTime.now().subtract(Duration(days: 1)),
      ),
      Chat(
        id: '10',
        name: 'Chris Martin',
        lastMessage: 'See you soon',
        lastMessageTime: DateTime.now().subtract(Duration(days: 2)),
        isMuted: true,
      ),
    ];
  }

  static List<Message> getMessages(String chatId) {
    return [
      Message(
        id: '1',
        senderId: 'other',
        text: 'Hey! How are you doing?',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        isMe: false,
        isRead: true,
      ),
      Message(
        id: '2',
        senderId: 'me',
        text: 'I\'m doing great! Just finished work. How about you?',
        timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 55)),
        isMe: true,
        isRead: true,
      ),
      Message(
        id: '3',
        senderId: 'other',
        text: 'Same here! Are you free this weekend?',
        timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 50)),
        isMe: false,
        isRead: true,
      ),
      Message(
        id: '4',
        senderId: 'me',
        text: 'Yeah, I should be. What do you have in mind?',
        timestamp: DateTime.now().subtract(Duration(hours: 1, minutes: 45)),
        isMe: true,
        isRead: true,
      ),
      Message(
        id: '5',
        senderId: 'other',
        text: 'Can we meet tomorrow?',
        timestamp: DateTime.now().subtract(Duration(minutes: 15)),
        isMe: false,
        isRead: false,
      ),
    ];
  }

  static List<Status> getStatuses() {
    return [
      Status(
        id: '1',
        userName: 'My Status',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
      ),
      Status(
        id: '2',
        userName: 'John Doe',
        timestamp: DateTime.now().subtract(Duration(minutes: 30)),
      ),
      Status(
        id: '3',
        userName: 'Sarah Smith',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        isViewed: true,
      ),
      Status(
        id: '4',
        userName: 'Mike Johnson',
        timestamp: DateTime.now().subtract(Duration(hours: 5)),
        isViewed: true,
        isMuted: true,
      ),
      Status(
        id: '5',
        userName: 'Emma Wilson',
        timestamp: DateTime.now().subtract(Duration(hours: 8)),
        isViewed: true,
      ),
      Status(
        id: '6',
        userName: 'David Brown',
        timestamp: DateTime.now().subtract(Duration(hours: 12)),
        isViewed: true,
      ),
    ];
  }

  static List<Call> getCalls() {
    return [
      Call(
        id: '1',
        name: 'John Doe',
        timestamp: DateTime.now().subtract(Duration(minutes: 5)),
        isOutgoing: true,
        isVideo: true,
      ),
      Call(
        id: '2',
        name: 'Sarah Smith',
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
        isOutgoing: false,
        isVideo: false,
        isMissed: true,
      ),
      Call(
        id: '3',
        name: 'Mike Johnson',
        timestamp: DateTime.now().subtract(Duration(hours: 5)),
        isOutgoing: true,
        isVideo: false,
      ),
      Call(
        id: '4',
        name: 'Emma Wilson',
        timestamp: DateTime.now().subtract(Duration(days: 1)),
        isOutgoing: false,
        isVideo: true,
      ),
      Call(
        id: '5',
        name: 'Family Group',
        timestamp: DateTime.now().subtract(Duration(days: 2)),
        isOutgoing: true,
        isVideo: true,
      ),
      Call(
        id: '6',
        name: 'David Brown',
        timestamp: DateTime.now().subtract(Duration(days: 3)),
        isOutgoing: false,
        isVideo: false,
      ),
    ];
  }

  static List<String> getChannels() {
    return [
      'Tech News',
      'Flutter Community',
      'Design Inspiration',
      'Daily Motivation',
      'Cooking Tips',
    ];
  }
}
