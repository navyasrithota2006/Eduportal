import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/auth_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotif   = true;
  bool _emailNotif  = false;
  bool _darkMode    = false;
  bool _biometric   = false;
  String _language  = 'English';

  static const _languages = ['English', 'Hindi', 'Tamil', 'Telugu', 'Marathi', 'Bengali'];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser!;
    final roleColor = AppTheme.roleColor(user.role);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: roleColor,
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // ── User Info ─────────────────────────────────────────
          Container(
            color: roleColor.withOpacity(0.05),
            padding: const EdgeInsets.all(20),
            child: Row(children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: roleColor.withOpacity(0.15),
                child: Text(user.name[0],
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: roleColor)),
              ),
              const SizedBox(width: 16),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(user.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                Text(user.email, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(color: roleColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                  child: Text(user.role.toUpperCase(),
                    style: TextStyle(fontSize: 11, color: roleColor, fontWeight: FontWeight.bold)),
                ),
              ]),
            ]),
          ),

          const SizedBox(height: 8),

          // ── Notifications ─────────────────────────────────────
          _Section(title: 'Notifications', tiles: [
            _SwitchTile('Push Notifications', Icons.notifications_outlined, roleColor,
              _pushNotif, (v) => setState(() => _pushNotif = v)),
            _SwitchTile('Email Notifications', Icons.email_outlined, roleColor,
              _emailNotif, (v) => setState(() => _emailNotif = v)),
          ]),

          // ── Appearance ────────────────────────────────────────
          _Section(title: 'Appearance', tiles: [
            _SwitchTile('Dark Mode', Icons.dark_mode_outlined, roleColor,
              _darkMode, (v) => setState(() => _darkMode = v)),
            ListTile(
              leading: Icon(Icons.language_outlined, color: roleColor),
              title: const Text('Language'),
              subtitle: Text(_language, style: const TextStyle(fontSize: 12)),
              trailing: DropdownButton<String>(
                value: _language,
                underline: const SizedBox(),
                items: _languages.map((l) => DropdownMenuItem(value: l, child: Text(l, style: const TextStyle(fontSize: 13)))).toList(),
                onChanged: (v) => setState(() => _language = v!),
              ),
            ),
          ]),

          // ── Security ──────────────────────────────────────────
          _Section(title: 'Security', tiles: [
            _SwitchTile('Biometric Login', Icons.fingerprint, roleColor,
              _biometric, (v) => setState(() => _biometric = v)),
            ListTile(
              leading: Icon(Icons.lock_reset_outlined, color: roleColor),
              title: const Text('Change Password'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _showChangePasswordDialog(context, roleColor),
            ),
          ]),

          // ── About ─────────────────────────────────────────────
          _Section(title: 'About', tiles: [
            ListTile(
              leading: Icon(Icons.info_outline, color: roleColor),
              title: const Text('App Version'),
              trailing: const Text('1.0.0', style: TextStyle(color: AppTheme.textSecondary)),
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip_outlined, color: roleColor),
              title: const Text('Privacy Policy'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.help_outline, color: roleColor),
              title: const Text('Help & Support'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ]),

          // ── Logout ────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              onPressed: () async {
                await context.read<AuthProvider>().logout();
                if (context.mounted) Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context, Color roleColor) {
    final oldCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          TextField(controller: oldCtrl, obscureText: true,
            decoration: const InputDecoration(labelText: 'Current Password')),
          const SizedBox(height: 12),
          TextField(controller: newCtrl, obscureText: true,
            decoration: const InputDecoration(labelText: 'New Password')),
        ]),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: roleColor),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password updated!'), backgroundColor: AppTheme.success),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<Widget> tiles;
  const _Section({required this.title, required this.tiles});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 6),
          child: Text(title.toUpperCase(),
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold,
              color: AppTheme.textSecondary, letterSpacing: 1.2)),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          child: Column(children: [
            for (int i = 0; i < tiles.length; i++) ...[
              tiles[i],
              if (i < tiles.length - 1) const Divider(height: 1, indent: 56),
            ],
          ]),
        ),
      ],
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile(this.label, this.icon, this.color, this.value, this.onChanged);

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      secondary: Icon(icon, color: color),
      title: Text(label),
      value: value,
      activeColor: color,
      onChanged: onChanged,
    );
  }
}
