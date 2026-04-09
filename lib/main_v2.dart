// ─────────────────────────────────────────────────────────────────────────────
// main_v2.dart  –  Enhanced entry point (rename to main.dart to use)
// Changes vs main.dart:
//   • SplashScreen as initial route with session restore
//   • Named routes for /notifications and /settings
//   • /analytics for Principal
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'utils/app_theme.dart';
import 'utils/auth_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/student/student_dashboard.dart';
import 'screens/teacher/teacher_dashboard.dart';
import 'screens/principal/principal_dashboard.dart';
import 'screens/principal/principal_analytics_screen.dart';
import 'screens/shared/notifications_screen.dart';
import 'screens/shared/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();
  await authProvider.restoreSession(); // Restore persisted session
  runApp(
    ChangeNotifierProvider.value(
      value: authProvider,
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
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const SplashScreen());
          case '/login':
            return MaterialPageRoute(builder: (_) => const LoginScreen());
          case '/student':
            return MaterialPageRoute(builder: (_) => const StudentDashboard());
          case '/teacher':
            return MaterialPageRoute(builder: (_) => const TeacherDashboard());
          case '/principal':
            return MaterialPageRoute(builder: (_) => const PrincipalDashboard());
          case '/analytics':
            return MaterialPageRoute(builder: (_) => const PrincipalAnalyticsScreen());
          case '/settings':
            return MaterialPageRoute(builder: (_) => const SettingsScreen());
          case '/notifications':
            final role = settings.arguments as String? ?? 'student';
            return MaterialPageRoute(
              builder: (_) => NotificationsScreen(role: role),
            );
          default:
            return MaterialPageRoute(builder: (_) => const SplashScreen());
        }
      },
    );
  }
}
