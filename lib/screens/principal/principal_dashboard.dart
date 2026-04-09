import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/auth_provider.dart';
import '../../utils/app_theme.dart';
import 'principal_home_tab.dart';
import 'principal_attendance_tab.dart';
import 'principal_alerts_tab.dart';
import 'principal_profile_tab.dart';

class PrincipalDashboard extends StatefulWidget {
  const PrincipalDashboard({super.key});

  @override
  State<PrincipalDashboard> createState() => _PrincipalDashboardState();
}

class _PrincipalDashboardState extends State<PrincipalDashboard> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    PrincipalHomeTab(),
    PrincipalAttendanceTab(),
    PrincipalAlertsTab(),
    PrincipalProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.principalColor,
        title: Row(
          children: [
            const Icon(Icons.auto_stories_rounded, size: 22),
            const SizedBox(width: 8),
            const Text('EduPortal'),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: PopupMenuButton(
              icon: CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Text(user.name[0], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              itemBuilder: (_) => [
                PopupMenuItem(
                  child: ListTile(
                    leading: const Icon(Icons.logout),
                    title: const Text('Logout'),
                    onTap: () {
                      Navigator.pop(context);
                      context.read<AuthProvider>().logout();
                      Navigator.pushReplacementNamed(context, '/');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _tabs),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        selectedItemColor: AppTheme.principalColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined),          activeIcon: Icon(Icons.home),              label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline),         activeIcon: Icon(Icons.people),            label: 'Attendance'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications_outlined), activeIcon: Icon(Icons.notifications),     label: 'Alerts'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline),         activeIcon: Icon(Icons.person),            label: 'Profile'),
        ],
      ),
    );
  }
}
