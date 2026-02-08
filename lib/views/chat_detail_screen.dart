import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../providers/providers.dart';

class ChatDetailScreen extends StatefulWidget {
  final Chat chat;

  const ChatDetailScreen({super.key, required this.chat});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen>
    with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isRecording = false;
  late AnimationController _recordingAnimationController;

  @override
  void initState() {
    super.initState();
    _recordingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    
    // Mark messages as read when opening chat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MessageProvider>(context, listen: false).markMessagesAsRead(widget.chat.id);
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _recordingAnimationController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      Provider.of<MessageProvider>(context, listen: false).sendMessage(
        widget.chat.id,
        _messageController.text.trim(),
      );
      Provider.of<ChatProvider>(context, listen: false).sendMessage(
        widget.chat.id,
        _messageController.text.trim(),
      );
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _showMessageOptions(Message message) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F2C34),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildMessageOption(
                icon: Icons.reply,
                title: 'Reply',
                onTap: () {
                  Navigator.pop(context);
                  Provider.of<MessageProvider>(context, listen: false).setReplyTo(
                    message.text,
                    message.id,
                  );
                },
              ),
              _buildMessageOption(
                icon: Icons.star_border,
                title: 'Star',
                onTap: () {
                  Provider.of<MessageProvider>(context, listen: false).starMessage(
                    widget.chat.id,
                    message.id,
                  );
                  Navigator.pop(context);
                },
              ),
              _buildMessageOption(
                icon: Icons.copy,
                title: 'Copy',
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Message copied')),
                  );
                },
              ),
              _buildMessageOption(
                icon: Icons.forward,
                title: 'Forward',
                onTap: () {
                  Navigator.pop(context);
                  _showForwardDialog(message);
                },
              ),
              if (message.isMe)
                _buildMessageOption(
                  icon: Icons.delete,
                  title: 'Delete',
                  color: Colors.red,
                  onTap: () {
                    Navigator.pop(context);
                    _showDeleteMessageDialog(message);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteMessageDialog(Message message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F2C34),
        title: const Text(
          'Delete message?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'This message will be deleted for everyone.',
          style: TextStyle(color: Colors.grey.shade400),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<MessageProvider>(context, listen: false).deleteMessage(
                widget.chat.id,
                message.id,
              );
              Navigator.pop(context);
            },
            child: const Text(
              'DELETE',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showForwardDialog(Message message) {
    final chats = Provider.of<ChatProvider>(context, listen: false).chats;
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F2C34),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'Forward to...',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ...chats.take(5).map((chat) {
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade700,
                    backgroundImage: chat.avatarUrl != null
                        ? NetworkImage(chat.avatarUrl!)
                        : null,
                    child: chat.avatarUrl == null
                        ? Text(chat.name[0])
                        : null,
                  ),
                  title: Text(
                    chat.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Provider.of<MessageProvider>(context, listen: false).forwardMessage(
                      widget.chat.id,
                      chat.id,
                      message.id,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Forwarded to ${chat.name}')),
                    );
                  },
                );
              }),
            ],
          ),
        );
      },
    );
  }

  void _showReactions(Message message) {
    final reactions = ['👍', '❤️', '😂', '😮', '😢', '🙏'];
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F2C34),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: reactions.map((reaction) {
              return GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Reacted with $reaction'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                child: Text(
                  reaction,
                  style: const TextStyle(fontSize: 32),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildMessageOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.white),
      title: Text(
        title,
        style: TextStyle(color: color ?? Colors.white),
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B141A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2C34),
        elevation: 0,
        leadingWidth: 80,
        leading: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            Hero(
              tag: 'avatar_${widget.chat.id}',
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade700,
                backgroundImage: widget.chat.avatarUrl != null
                    ? NetworkImage(widget.chat.avatarUrl!)
                    : null,
                child: widget.chat.avatarUrl == null
                    ? Text(
                        widget.chat.name[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.chat.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            Consumer<MessageProvider>(
              builder: (context, messageProvider, child) {
                final isTyping = messageProvider.isTyping(widget.chat.id);
                return Text(
                  isTyping
                      ? 'typing...'
                      : (widget.chat.isOnline ? 'online' : 'last seen recently'),
                  style: TextStyle(
                    color: isTyping ? const Color(0xFF00A884) : Colors.grey,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            color: const Color(0xFF1F2C34),
            onSelected: (value) {
              if (value == 'clear') {
                Provider.of<MessageProvider>(context, listen: false).clearChat(widget.chat.id);
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'view_contact',
                child: Text('View contact', style: TextStyle(color: Colors.white)),
              ),
              const PopupMenuItem(
                value: 'media',
                child: Text('Media, links, and docs', style: TextStyle(color: Colors.white)),
              ),
              const PopupMenuItem(
                value: 'search',
                child: Text('Search', style: TextStyle(color: Colors.white)),
              ),
              const PopupMenuItem(
                value: 'mute',
                child: Text('Mute notifications', style: TextStyle(color: Colors.white)),
              ),
              const PopupMenuItem(
                value: 'disappearing',
                child: Text('Disappearing messages', style: TextStyle(color: Colors.white)),
              ),
              const PopupMenuItem(
                value: 'wallpaper',
                child: Text('Wallpaper', style: TextStyle(color: Colors.white)),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Text('Clear chat', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<MessageProvider>(
              builder: (context, messageProvider, child) {
                final messages = messageProvider.getMessages(widget.chat.id);
                final replyingTo = messageProvider.replyingTo;

                return Column(
                  children: [
                    if (replyingTo != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        color: const Color(0xFF1F2C34),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Replying to',
                                    style: TextStyle(
                                      color: Color(0xFF00A884),
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    replyingTo,
                                    style: const TextStyle(color: Colors.white),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.grey),
                              onPressed: () {
                                messageProvider.cancelReply();
                              },
                            ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        reverse: true,
                        padding: const EdgeInsets.all(16),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[messages.length - 1 - index];
                          return _buildMessageBubble(message);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      color: const Color(0xFF1F2C34),
      child: SafeArea(
        child: Row(
          children: [
            AnimatedBuilder(
              animation: _recordingAnimationController,
              builder: (context, child) {
                return IconButton(
                  icon: Icon(
                    _isRecording ? Icons.mic : Icons.emoji_emotions_outlined,
                    color: _isRecording
                        ? Colors.red.withValues(alpha: _recordingAnimationController.value)
                        : Colors.grey,
                  ),
                  onPressed: () {},
                );
              },
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2A3942),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          hintText: 'Message',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.attach_file, color: Colors.grey),
                      onPressed: () {
                        _showAttachmentOptions();
                      },
                    ),
                    if (_messageController.text.isEmpty)
                      IconButton(
                        icon: const Icon(Icons.camera_alt, color: Colors.grey),
                        onPressed: () {},
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onLongPressStart: (_) {
                setState(() => _isRecording = true);
              },
              onLongPressEnd: (_) {
                setState(() => _isRecording = false);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Voice message sent'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF00A884),
                child: IconButton(
                  icon: Icon(
                    _messageController.text.isEmpty ? Icons.mic : Icons.send,
                    color: Colors.white,
                  ),
                  onPressed: _messageController.text.isEmpty
                      ? null
                      : _sendMessage,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1F2C34),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: [
                  _buildAttachmentOption(Icons.insert_drive_file, 'Document', Colors.indigo),
                  _buildAttachmentOption(Icons.camera_alt, 'Camera', Colors.pink),
                  _buildAttachmentOption(Icons.image, 'Gallery', Colors.purple),
                  _buildAttachmentOption(Icons.headphones, 'Audio', Colors.orange),
                  _buildAttachmentOption(Icons.location_on, 'Location', Colors.green),
                  _buildAttachmentOption(Icons.person, 'Contact', Colors.blue),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttachmentOption(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color,
          child: Icon(icon, color: Colors.white, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(Message message) {
    return GestureDetector(
      onLongPress: () => _showMessageOptions(message),
      onDoubleTap: () => _showReactions(message),
      child: Align(
        alignment: message.isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: message.isMe
                ? const Color(0xFF005C4B)
                : const Color(0xFF1F2C34),
            borderRadius: BorderRadius.circular(8),
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.75,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                message.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${message.timestamp.hour.toString().padLeft(2, '0')}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 11,
                    ),
                  ),
                  if (message.isMe)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(
                        message.isRead ? Icons.done_all : Icons.done,
                        color: message.isRead
                            ? const Color(0xFF53BDEB)
                            : Colors.grey,
                        size: 14,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
