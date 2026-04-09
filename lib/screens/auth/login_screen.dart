import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/auth_provider.dart';
import '../../utils/app_theme.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  String _role = 'student';
  final _idCtrl = TextEditingController();
  final _pwCtrl = TextEditingController();
  bool _obscurePw = true;
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  final List<Map<String, dynamic>> _roles = [
    {'value': 'student',   'label': 'Student',   'icon': Icons.school,        'color': AppTheme.studentColor},
    {'value': 'teacher',   'label': 'Teacher',   'icon': Icons.person,        'color': AppTheme.teacherColor},
    {'value': 'principal', 'label': 'Principal', 'icon': Icons.admin_panel_settings, 'color': AppTheme.principalColor},
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _idCtrl.dispose();
    _pwCtrl.dispose();
    super.dispose();
  }

  String get _idHint {
    switch (_role) {
      case 'teacher':   return 'Teacher ID (e.g. TCH001)';
      case 'principal': return 'Principal ID (e.g. PRI001)';
      default:          return 'Student ID (e.g. STU001)';
    }
  }

  Color get _roleColor {
    final r = _roles.firstWhere((r) => r['value'] == _role);
    return r['color'] as Color;
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.login(_idCtrl.text.trim(), _pwCtrl.text, _role);
    if (!mounted) return;
    if (ok) {
      final role = auth.currentUser!.role;
      if (role == 'student')        Navigator.pushReplacementNamed(context, '/student');
      else if (role == 'teacher')   Navigator.pushReplacementNamed(context, '/teacher');
      else                          Navigator.pushReplacementNamed(context, '/principal');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error ?? 'Login failed'), backgroundColor: AppTheme.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // ── Logo ────────────────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: _roleColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.auto_stories_rounded, size: 60, color: _roleColor),
                  ),
                  const SizedBox(height: 16),
                  Text('EduPortal', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: _roleColor)),
                  const SizedBox(height: 4),
                  const Text('Smarter Management of Schools', style: TextStyle(fontSize: 14, color: AppTheme.textSecondary)),
                  const SizedBox(height: 36),

                  // ── Role Selector ────────────────────────────────
                  const Align(alignment: Alignment.centerLeft, child: Text('Select Role', style: TextStyle(fontWeight: FontWeight.w600))),
                  const SizedBox(height: 10),
                  Row(
                    children: _roles.map((r) {
                      final selected = _role == r['value'];
                      final c = r['color'] as Color;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() { _role = r['value']; _idCtrl.clear(); }),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: selected ? c : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: selected ? c : const Color(0xFFE0E0E0), width: 1.5),
                              boxShadow: selected ? [BoxShadow(color: c.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 3))] : [],
                            ),
                            child: Column(
                              children: [
                                Icon(r['icon'] as IconData, color: selected ? Colors.white : c, size: 24),
                                const SizedBox(height: 6),
                                Text(r['label'] as String,
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
                                    color: selected ? Colors.white : c)),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),

                  // ── ID Field ─────────────────────────────────────
                  TextFormField(
                    controller: _idCtrl,
                    decoration: InputDecoration(
                      labelText: _idHint,
                      prefixIcon: Icon(Icons.badge_outlined, color: _roleColor),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Please enter your ID' : null,
                  ),
                  const SizedBox(height: 16),

                  // ── Password Field ───────────────────────────────
                  TextFormField(
                    controller: _pwCtrl,
                    obscureText: _obscurePw,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(Icons.lock_outline, color: _roleColor),
                      suffixIcon: IconButton(
                        icon: Icon(_obscurePw ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                        onPressed: () => setState(() => _obscurePw = !_obscurePw),
                      ),
                    ),
                    validator: (v) => v == null || v.isEmpty ? 'Please enter your password' : null,
                  ),
                  const SizedBox(height: 28),

                  // ── Login Button ─────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: _roleColor),
                      onPressed: auth.isLoading ? null : _login,
                      child: auth.isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text('Login'),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // ── Sign-up Link ─────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SignupScreen())),
                        child: Text('Sign Up', style: TextStyle(color: _roleColor, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                  // ── Demo Credentials ─────────────────────────────
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(children: [
                          Icon(Icons.info_outline, size: 16, color: Colors.blue),
                          SizedBox(width: 6),
                          Text('Demo Credentials', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue, fontSize: 13)),
                        ]),
                        const SizedBox(height: 8),
                        const Text('Student  → STU001 / pass123', style: TextStyle(fontSize: 12)),
                        const Text('Teacher  → TCH001 / pass123', style: TextStyle(fontSize: 12)),
                        const Text('Principal → PRI001 / pass123', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
