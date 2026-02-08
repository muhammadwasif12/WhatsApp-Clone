import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool notifications = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B141A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F2C34),
        elevation: 0,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView(
        children: [
          _buildProfileHeader(),
          const Divider(color: Color(0xFF2A3942)),
          _buildSettingsTile(
            icon: Icons.key,
            title: 'Account',
            subtitle: 'Security notifications, change number',
          ),
          _buildSettingsTile(
            icon: Icons.lock,
            title: 'Privacy',
            subtitle: 'Block contacts, disappearing messages',
          ),
          _buildSettingsTile(
            icon: Icons.chat,
            title: 'Chats',
            subtitle: 'Theme, wallpapers, chat history',
          ),
          _buildSettingsTile(
            icon: Icons.notifications,
            title: 'Notifications',
            subtitle: 'Message, group & call tones',
            trailing: Switch(
              value: notifications,
              onChanged: (value) => setState(() => notifications = value),
              activeTrackColor: const Color(0xFF00A884),
              activeThumbColor: Colors.white,
            ),
          ),
          _buildSettingsTile(
            icon: Icons.storage,
            title: 'Storage and data',
            subtitle: 'Network usage, auto-download',
          ),
          _buildSettingsTile(
            icon: Icons.language,
            title: 'App language',
            subtitle: "English (device's language)",
          ),
          _buildSettingsTile(
            icon: Icons.help_outline,
            title: 'Help',
            subtitle: 'Help centre, contact us, privacy policy',
          ),
          const Divider(color: Color(0xFF2A3942)),
          _buildSettingsTile(
            icon: Icons.group,
            title: 'Invite a friend',
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'from Meta',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return InkWell(
      onTap: () {
        // Navigate to profile edit screen
      },
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'profile_avatar',
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A3942),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF00A884),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: const Color(0xFF00A884),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFF0B141A),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.black,
                      size: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Your Name',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hey there! I am using WhatsApp',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.qr_code,
              color: Color(0xFF00A884),
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFF00A884).withAlpha(51),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF00A884),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 13,
              ),
            )
          : null,
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
      onTap: onTap,
    );
  }
}
