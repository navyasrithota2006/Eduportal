import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/auth_provider.dart';
import '../utils/app_theme.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoCtrl;
  late AnimationController _textCtrl;
  late AnimationController _progressCtrl;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _textSlide;
  late Animation<double> _textOpacity;
  late Animation<double> _progressValue;

  @override
  void initState() {
    super.initState();

    // Logo animation
    _logoCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _logoScale   = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.easeIn));

    // Text animation
    _textCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _textSlide   = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut));
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(_textCtrl);

    // Progress animation
    _progressCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1800));
    _progressValue = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _progressCtrl, curve: Curves.easeInOut));

    _runSequence();
  }

  Future<void> _runSequence() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _logoCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _textCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _progressCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;
    _navigate();
  }

  void _navigate() {
    final auth = context.read<AuthProvider>();
    if (auth.isLoggedIn) {
      final role = auth.currentUser!.role;
      if (role == 'student')        Navigator.pushReplacementNamed(context, '/student');
      else if (role == 'teacher')   Navigator.pushReplacementNamed(context, '/teacher');
      else                          Navigator.pushReplacementNamed(context, '/principal');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D47A1),
              Color(0xFF1565C0),
              Color(0xFF1976D2),
              Color(0xFF00ACC1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // ── Logo ────────────────────────────────────────
              ScaleTransition(
                scale: _logoScale,
                child: FadeTransition(
                  opacity: _logoOpacity,
                  child: Column(
                    children: [
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 30, spreadRadius: 5),
                          ],
                        ),
                        child: const Icon(Icons.auto_stories_rounded, size: 60, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // ── App Name ─────────────────────────────────────
              SlideTransition(
                position: _textSlide,
                child: FadeTransition(
                  opacity: _textOpacity,
                  child: Column(
                    children: [
                      const Text(
                        'EduPortal',
                        style: TextStyle(
                          fontSize: 38,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Smarter Management of Schools',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // ── Feature Pills ─────────────────────────────────
              FadeTransition(
                opacity: _textOpacity,
                child: Wrap(
                  spacing: 10,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _pill(Icons.school, 'Students'),
                    _pill(Icons.person, 'Teachers'),
                    _pill(Icons.admin_panel_settings, 'Principals'),
                  ],
                ),
              ),

              const Spacer(),

              // ── Progress Bar ─────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 60),
                child: Column(
                  children: [
                    AnimatedBuilder(
                      animation: _progressValue,
                      builder: (_, __) => ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: _progressValue.value,
                          minHeight: 4,
                          backgroundColor: Colors.white.withOpacity(0.2),
                          valueColor: const AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Loading…',
                      style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pill(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.25)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: Colors.white),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
      ]),
    );
  }
}
