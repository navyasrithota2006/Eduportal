// ─────────────────────────────────────────────────────────────────────────────
// app_bar_actions.dart  –  Reusable AppBar actions widget with notif badge
// Usage in AppBar:  actions: [AppBarActions(role: 'student', user: user)]
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/auth_provider.dart';
import '../utils/mock_data.dart';

class AppBarActions extends StatelessWidget {
  final String role;

  const AppBarActions({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser!;
    final unreadCount = MockData.alerts.length; // simplified badge count

    return Row(
      children: [
        // ── Notifications Bell ──────────────────────────────
        Stack(
          clipBehavior: Clip.none,
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined, color: Colors.white),
              tooltip: 'Notifications',
              onPressed: () => Navigator.pushNamed(context, '/notifications', arguments: role),
            ),
            if (unreadCount > 0)
              Positioned(
                right: 6, top: 6,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    unreadCount > 9 ? '9+' : '$unreadCount',
                    style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),

        // ── Avatar Menu ─────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: PopupMenuButton<String>(
            icon: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white.withOpacity(0.25),
              child: Text(
                user.name.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join().toUpperCase(),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            offset: const Offset(0, 48),
            itemBuilder: (_) => [
              PopupMenuItem(
                enabled: false,
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  Text(user.email, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  Text('ID: ${user.id}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                ]),
              ),
              const PopupMenuDivider(),
              if (role == 'principal')
                const PopupMenuItem(
                  value: 'analytics',
                  child: ListTile(dense: true,
                    leading: Icon(Icons.bar_chart, color: Colors.purple),
                    title: Text('Analytics', style: TextStyle(fontSize: 14)),
                  ),
                ),
              const PopupMenuItem(
                value: 'settings',
                child: ListTile(dense: true,
                  leading: Icon(Icons.settings_outlined),
                  title: Text('Settings', style: TextStyle(fontSize: 14)),
                ),
              ),
              const PopupMenuItem(
                value: 'logout',
                child: ListTile(dense: true,
                  leading: Icon(Icons.logout, color: Colors.red),
                  title: Text('Logout', style: TextStyle(fontSize: 14, color: Colors.red)),
                ),
              ),
            ],
            onSelected: (value) async {
              switch (value) {
                case 'analytics':
                  Navigator.pushNamed(context, '/analytics');
                  break;
                case 'settings':
                  Navigator.pushNamed(context, '/settings');
                  break;
                case 'logout':
                  await context.read<AuthProvider>().logout();
                  if (context.mounted) Navigator.pushReplacementNamed(context, '/login');
                  break;
              }
            },
          ),
        ),
      ],
    );
  }
}
