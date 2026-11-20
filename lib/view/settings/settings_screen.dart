// Owner: Aayusha

import 'package:flutter/material.dart';
import 'package:resolve/core/app_routes.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _workoutReminders = true;
  bool _darkMode = false;
  String _units = 'Metric (kg, cm)';
  bool _shareWorkouts = false;
  bool _publicProfile = true;

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                    (route) => false,
              );
            },
            child: const Text('Log out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade600,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          _sectionTitle('NOTIFICATIONS'),
          SwitchListTile(
            secondary: const Icon(Icons.notifications_outlined),
            title: const Text('Push notifications'),
            value: _notifications,
            onChanged: (v) => setState(() => _notifications = v),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.alarm),
            title: const Text('Workout reminders'),
            value: _workoutReminders,
            onChanged: (v) => setState(() => _workoutReminders = v),
          ),

          _sectionTitle('PREFERENCES'),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode_outlined),
            title: const Text('Dark mode'),
            value: _darkMode,
            onChanged: (v) => setState(() => _darkMode = v),
          ),
          ListTile(
            leading: const Icon(Icons.straighten),
            title: const Text('Units'),
            trailing: DropdownButton<String>(
              value: _units,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(
                  value: 'Metric (kg, cm)',
                  child: Text('Metric (kg, cm)'),
                ),
                DropdownMenuItem(
                  value: 'Imperial (lb, ft)',
                  child: Text('Imperial (lb, ft)'),
                ),
              ],
              onChanged: (v) => setState(() => _units = v!),
            ),
          ),

          _sectionTitle('PRIVACY'),
          SwitchListTile(
            secondary: const Icon(Icons.share_outlined),
            title: const Text('Share workout activity'),
            value: _shareWorkouts,
            onChanged: (v) => setState(() => _shareWorkouts = v),
          ),
          SwitchListTile(
            secondary: const Icon(Icons.visibility_outlined),
            title: const Text('Public profile'),
            value: _publicProfile,
            onChanged: (v) => setState(() => _publicProfile = v),
          ),

          _sectionTitle('ABOUT'),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('App version'),
            trailing: const Text('1.0.0'),
          ),

          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _confirmLogout,
              icon: const Icon(Icons.logout),
              label: const Text('Log out'),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}