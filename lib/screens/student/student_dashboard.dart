import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/auth_provider.dart';
import '../../utils/app_theme.dart';
import 'student_home_tab.dart';
import 'student_schedule_tab.dart';
import 'student_results_tab.dart';
import 'student_profile_tab.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    StudentHomeTab(),
    StudentScheduleTab(),
    StudentResultsTab(),
    StudentProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.studentColor,
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
        selectedItemColor: AppTheme.studentColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined),     activeIcon: Icon(Icons.home),              label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), activeIcon: Icon(Icons.calendar_today), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_outlined), activeIcon: Icon(Icons.bar_chart),         label: 'Results'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline),    activeIcon: Icon(Icons.person),             label: 'Profile'),
        ],
      ),
    );
  }
}
