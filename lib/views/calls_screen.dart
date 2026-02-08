import 'package:flutter/material.dart';
import '../data/dummy_data.dart';
import '../models/call_model.dart';

class CallsScreen extends StatelessWidget {
  const CallsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final calls = DummyData.getCalls();

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: const Color(0xFF1F1F1F),
            elevation: 0,
            pinned: true,
            floating: true,
            title: const Text(
              'Calls',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.camera_alt_outlined, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onPressed: () {},
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: ListTile(
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF00A884),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.link,
                  color: Colors.black,
                ),
              ),
              title: const Text(
                'Create call link',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text(
                'Share a link for your WhatsApp call',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
              child: Text(
                'Recent',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final call = calls[index];
                return _buildCallItem(call);
              },
              childCount: calls.length,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF00A884),
        child: const Icon(Icons.add_call, color: Colors.black),
      ),
    );
  }

  Widget _buildCallItem(Call call) {
    String timeText;
    final now = DateTime.now();
    final difference = now.difference(call.timestamp);

    if (difference.inDays == 0) {
      timeText = '${call.timestamp.hour.toString().padLeft(2, '0')}:${call.timestamp.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      timeText = 'Yesterday';
    } else {
      timeText = '${call.timestamp.day}/${call.timestamp.month}/${call.timestamp.year}';
    }

    IconData callIcon;
    Color callIconColor;
    if (call.isMissed) {
      callIcon = call.isOutgoing ? Icons.call_made : Icons.call_received;
      callIconColor = Colors.red;
    } else {
      callIcon = call.isOutgoing ? Icons.call_made : Icons.call_received;
      callIconColor = const Color(0xFF00A884);
    }

    return ListTile(
      leading: CircleAvatar(
        radius: 28,
        backgroundColor: Colors.grey.shade700,
        backgroundImage: call.avatarUrl != null
            ? NetworkImage(call.avatarUrl!)
            : null,
        child: call.avatarUrl == null
            ? Text(
                call.name[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              )
            : null,
      ),
      title: Text(
        call.name,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Row(
        children: [
          Icon(
            callIcon,
            color: callIconColor,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            timeText,
            style: TextStyle(
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              call.isVideo ? Icons.videocam : Icons.call,
              color: const Color(0xFF00A884),
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
