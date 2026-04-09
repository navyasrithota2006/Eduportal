import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/app_theme.dart';
import 'utils/auth_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/student/student_dashboard.dart';
import 'screens/teacher/teacher_dashboard.dart';
import 'screens/principal/principal_dashboard.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: const EduPortalApp(),
    ),
  );
}

class EduPortalApp extends StatelessWidget {
  const EduPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduPortal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: '/',
      routes: {
        '/':          (_) => const LoginScreen(),
        '/student':   (_) => const StudentDashboard(),
        '/teacher':   (_) => const TeacherDashboard(),
        '/principal': (_) => const PrincipalDashboard(),
      },
    );
  }
}
