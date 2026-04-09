import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/auth_provider.dart';
import '../../utils/app_theme.dart';
import 'teacher_home_tab.dart';
import 'teacher_attendance_tab.dart';
import 'teacher_students_tab.dart';
import 'teacher_reports_tab.dart';
import 'teacher_profile_tab.dart';

class TeacherDashboard extends StatefulWidget {
  const TeacherDashboard({super.key});

  @override
  State<TeacherDashboard> createState() => _TeacherDashboardState();
}

class _TeacherDashboardState extends State<TeacherDashboard> {
  int _currentIndex = 0;

  final List<Widget> _tabs = const [
    TeacherHomeTab(),
    TeacherAttendanceTab(),
    TeacherStudentsTab(),
    TeacherReportsTab(),
    TeacherProfileTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.teacherColor,
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
        selectedItemColor: AppTheme.teacherColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined),         activeIcon: Icon(Icons.home),              label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.fact_check_outlined),   activeIcon: Icon(Icons.fact_check),        label: 'Attendance'),
          BottomNavigationBarItem(icon: Icon(Icons.groups_outlined),       activeIcon: Icon(Icons.groups),            label: 'Students'),
          BottomNavigationBarItem(icon: Icon(Icons.assessment_outlined),   activeIcon: Icon(Icons.assessment),        label: 'Reports'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline),        activeIcon: Icon(Icons.person),            label: 'Profile'),
        ],
      ),
    );
  }
}
