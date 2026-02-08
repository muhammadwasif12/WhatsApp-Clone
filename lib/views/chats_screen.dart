import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import '../providers/providers.dart';
import '../models/chat_model.dart';
import '../widgets/chat_list_item.dart';
import '../widgets/search_bar_widget.dart';
import 'chat_detail_screen.dart';
import 'new_chat_screen.dart';
import 'settings_screen.dart';
import 'archived_chats_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  String _selectedFilter = 'All';
  final List<String> _filters = ['All', 'Unread', 'Favorites', 'Groups'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _showChatOptions(Chat chat) {
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
              _buildOptionTile(
                icon: chat.isPinned ? Icons.push_pin_outlined : Icons.push_pin,
                title: chat.isPinned ? 'Unpin chat' : 'Pin chat',
                onTap: () {
                  Provider.of<ChatProvider>(context, listen: false).pinChat(chat.id);
                  Navigator.pop(context);
                },
              ),
              _buildOptionTile(
                icon: chat.isMuted ? Icons.volume_up : Icons.volume_off,
                title: chat.isMuted ? 'Unmute notifications' : 'Mute notifications',
                onTap: () {
                  Provider.of<ChatProvider>(context, listen: false).muteChat(chat.id);
                  Navigator.pop(context);
                },
              ),
              _buildOptionTile(
                icon: Icons.archive,
                title: 'Archive chat',
                onTap: () {
                  Provider.of<ChatProvider>(context, listen: false).archiveChat(chat.id);
                  Navigator.pop(context);
                  _showUndoSnackBar(chat);
                },
              ),
              _buildOptionTile(
                icon: Icons.delete,
                title: 'Delete chat',
                color: Colors.red,
                onTap: () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(chat);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showUndoSnackBar(Chat chat) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          const Icon(Icons.archive, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '${chat.name} archived',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF1F2C34),
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.fixed,
      action: SnackBarAction(
        label: 'UNDO',
        textColor: const Color(0xFF00A884),
        onPressed: () {
          Provider.of<ChatProvider>(context, listen: false).unarchiveChat(chat.id);
        },
      ),
    );
    
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _showDeleteConfirmation(Chat chat) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1F2C34),
        title: const Text(
          'Delete this chat?',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Messages will only be removed from this device.',
          style: TextStyle(color: Colors.grey.shade400),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<ChatProvider>(context, listen: false).deleteChat(chat.id);
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

  Widget _buildOptionTile({
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

  List<Chat> _filterChats(List<Chat> chats) {
    switch (_selectedFilter) {
      case 'Unread':
        return chats.where((chat) => chat.isUnread).toList();
      case 'Favorites':
        return chats.where((chat) => chat.isPinned).toList();
      case 'Groups':
        return chats.where((chat) => chat.isGroup).toList();
      default:
        return chats;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatProvider>(
      builder: (context, chatProvider, child) {
        final allChats = chatProvider.chats;
        final filteredChats = _filterChats(allChats);
        final hasArchived = chatProvider.archivedChats.isNotEmpty;

        return Scaffold(
          backgroundColor: const Color(0xFF0B141A),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: const Color(0xFF1F2C34),
                elevation: 0,
                pinned: true,
                floating: false,
                snap: false,
                expandedHeight: chatProvider.isSearching ? 120 : 56,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.symmetric(horizontal: 16),
                  title: chatProvider.isSearching
                      ? null
                      : Row(
                          children: [
                            const Text(
                              'WhatsApp',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 22,
                              ),
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 20),
                            PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, color: Colors.white, size: 24),
                              color: const Color(0xFF1F2C34),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                              onSelected: (value) {
                                switch (value) {
                                  case 'settings':
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const SettingsScreen(),
                                      ),
                                    );
                                    break;
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'new_group',
                                  child: Text('New group', style: TextStyle(color: Colors.white)),
                                ),
                                const PopupMenuItem(
                                  value: 'new_broadcast',
                                  child: Text('New broadcast', style: TextStyle(color: Colors.white)),
                                ),
                                const PopupMenuItem(
                                  value: 'linked_devices',
                                  child: Text('Linked devices', style: TextStyle(color: Colors.white)),
                                ),
                                const PopupMenuItem(
                                  value: 'starred_messages',
                                  child: Text('Starred messages', style: TextStyle(color: Colors.white)),
                                ),
                                const PopupMenuItem(
                                  value: 'settings',
                                  child: Text('Settings', style: TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ],
                        ),
                ),
                bottom: chatProvider.isSearching
                    ? PreferredSize(
                        preferredSize: const Size.fromHeight(60),
                        child: SearchBarWidget(
                          onChanged: chatProvider.setSearchQuery,
                          onClose: chatProvider.toggleSearch,
                        ),
                      )
                    : null,
              ),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A3942),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          onChanged: chatProvider.setSearchQuery,
                          style: const TextStyle(color: Colors.white, fontSize: 16),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search, color: Colors.grey),
                            hintText: 'Ask Meta AI or Search',
                            hintStyle: const TextStyle(color: Colors.grey, fontSize: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Filter Chips - Glassmorphism Oval Shape
                    Container(
                      height: 36,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Row(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _filters.length,
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                final filter = _filters[index];
                                final isSelected = _selectedFilter == filter;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _selectedFilter = filter;
                                      });
                                    },
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(18),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: isSelected 
                                                ? const Color(0xFF00A884).withAlpha(200) 
                                                : const Color(0xFF2A3942).withAlpha(150),
                                            borderRadius: BorderRadius.circular(18),
                                            border: Border.all(
                                              color: isSelected 
                                                  ? const Color(0xFF00A884).withAlpha(150) 
                                                  : Colors.grey.shade700.withAlpha(100),
                                              width: 0.5,
                                            ),
                                            boxShadow: isSelected
                                                ? [
                                                    BoxShadow(
                                                      color: const Color(0xFF00A884).withAlpha(100),
                                                      blurRadius: 8,
                                                      spreadRadius: 0,
                                                    ),
                                                  ]
                                                : null,
                                          ),
                                          child: Center(
                                            child: Text(
                                              filter,
                                              style: TextStyle(
                                                color: isSelected ? Colors.black : const Color(0xFF8696A0),
                                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                                                fontSize: 13,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          // Plus Button - Glassmorphism
                          GestureDetector(
                            onTap: () {
                              // Add new filter or show options
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2A3942).withAlpha(150),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.grey.shade700.withAlpha(100),
                                      width: 0.5,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Color(0xFF8696A0),
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (hasArchived)
                SliverToBoxAdapter(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ArchivedChatsScreen(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.archive,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Archived',
                              style: TextStyle(
                                color: Colors.grey.shade300,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Text(
                            '${chatProvider.archivedChats.length}',
                            style: const TextStyle(
                              color: Color(0xFF00A884),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final chat = filteredChats[index];
                    return Dismissible(
                      key: Key(chat.id),
                      background: Container(
                        color: const Color(0xFF00A884),
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 20),
                        child: const Icon(
                          Icons.archive,
                          color: Colors.white,
                        ),
                      ),
                      secondaryBackground: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      onDismissed: (direction) {
                        if (direction == DismissDirection.startToEnd) {
                          Provider.of<ChatProvider>(context, listen: false).archiveChat(chat.id);
                          _showUndoSnackBar(chat);
                        } else {
                          Provider.of<ChatProvider>(context, listen: false).deleteChat(chat.id);
                        }
                      },
                      child: ChatListItem(
                        chat: chat,
                        onTap: () {
                          chatProvider.markAsRead(chat.id);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatDetailScreen(chat: chat),
                            ),
                          );
                        },
                        onLongPress: () => _showChatOptions(chat),
                      ),
                    );
                  },
                  childCount: filteredChats.length,
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NewChatScreen(),
                ),
              );
            },
            backgroundColor: const Color(0xFF00A884),
            child: const Icon(Icons.chat, color: Colors.black),
          ),
        );
      },
    );
  }
}
