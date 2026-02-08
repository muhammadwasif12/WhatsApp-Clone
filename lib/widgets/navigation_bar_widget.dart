import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/providers.dart';
import '../views/chats_screen.dart';
import '../views/updates_screen.dart';
import '../views/communities_screen.dart';
import '../views/calls_screen.dart';

class NavigationBarWidget extends StatefulWidget {
  const NavigationBarWidget({super.key});

  @override
  State<NavigationBarWidget> createState() => _NavigationBarWidgetState();
}

class _NavigationBarWidgetState extends State<NavigationBarWidget> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const ChatsScreen(),
    const UpdatesScreen(),
    const CommunitiesScreen(),
    const CallsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _simulateOnlineStatusUpdates();
  }

  void _simulateOnlineStatusUpdates() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        final chatProvider = Provider.of<ChatProvider>(context, listen: false);
        chatProvider.updateOnlineStatus('2', true);
        
        Future.delayed(const Duration(seconds: 10), () {
          if (mounted) {
            chatProvider.updateOnlineStatus('2', false);
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1F2C34),
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade800,
              width: 0.5,
            ),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color(0xFF00A884),
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 0 ? Icons.chat_bubble : Icons.chat_bubble_outline,
              ),
              label: 'Chats',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 1 ? Icons.radio_button_checked : Icons.radio_button_off,
              ),
              label: 'Updates',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 2 ? Icons.people : Icons.people_outline,
              ),
              label: 'Communities',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                _currentIndex == 3 ? Icons.call : Icons.call_outlined,
              ),
              label: 'Calls',
            ),
          ],
        ),
      ),
    );
  }
}
