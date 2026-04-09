import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/auth_provider.dart';
import '../../utils/app_theme.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String _role = 'student';
  final _formKey = GlobalKey<FormState>();
  final _idCtrl    = TextEditingController();
  final _nameCtrl  = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _pwCtrl    = TextEditingController();
  final _cpwCtrl   = TextEditingController();
  bool _obscurePw  = true;
  bool _obscureCpw = true;

  final List<Map<String, dynamic>> _roles = [
    {'value': 'student',   'label': 'Student',   'icon': Icons.school,        'color': AppTheme.studentColor},
    {'value': 'teacher',   'label': 'Teacher',   'icon': Icons.person,        'color': AppTheme.teacherColor},
    {'value': 'principal', 'label': 'Principal', 'icon': Icons.admin_panel_settings, 'color': AppTheme.principalColor},
  ];

  Color get _roleColor => (_roles.firstWhere((r) => r['value'] == _role)['color']) as Color;

  String get _idHint {
    switch (_role) {
      case 'teacher':   return 'Teacher ID';
      case 'principal': return 'Principal ID';
      default:          return 'Student ID';
    }
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final ok = await auth.signUp(
      id: _idCtrl.text.trim(),
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _pwCtrl.text,
      role: _role,
      extra: {'class': '10', 'section': 'A', 'attendance': 0.0, 'address': '', 'guardian': ''},
    );
    if (!mounted) return;
    if (ok) {
      final role = auth.currentUser!.role;
      if (role == 'student')        Navigator.pushReplacementNamed(context, '/student');
      else if (role == 'teacher')   Navigator.pushReplacementNamed(context, '/teacher');
      else                          Navigator.pushReplacementNamed(context, '/principal');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(auth.error ?? 'Sign up failed'), backgroundColor: AppTheme.error),
      );
    }
  }

  @override
  void dispose() {
    _idCtrl.dispose(); _nameCtrl.dispose(); _emailCtrl.dispose();
    _pwCtrl.dispose(); _cpwCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        backgroundColor: _roleColor,
      ),
      backgroundColor: AppTheme.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Role Selector ──────────────────────────────────
              const Text('Select Your Role', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
              const SizedBox(height: 10),
              Row(
                children: _roles.map((r) {
                  final selected = _role == r['value'];
                  final c = r['color'] as Color;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() { _role = r['value']; }),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: selected ? c : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: selected ? c : const Color(0xFFE0E0E0), width: 1.5),
                        ),
                        child: Column(
                          children: [
                            Icon(r['icon'] as IconData, color: selected ? Colors.white : c, size: 22),
                            const SizedBox(height: 5),
                            Text(r['label'] as String,
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                                color: selected ? Colors.white : c)),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              // ── Fields ─────────────────────────────────────────
              TextFormField(
                controller: _idCtrl,
                decoration: InputDecoration(
                  labelText: _idHint,
                  prefixIcon: Icon(Icons.badge_outlined, color: _roleColor),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Please enter your ID' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline, color: _roleColor),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: Icon(Icons.email_outlined, color: _roleColor),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter your email';
                  if (!v.contains('@')) return 'Enter a valid email';
                  return null;
                },
              ),
              const SizedBox(height: 14),
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
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please enter a password';
                  if (v.length < 6) return 'Password must be at least 6 characters';
                  return null;
                },
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _cpwCtrl,
                obscureText: _obscureCpw,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  prefixIcon: Icon(Icons.lock_outline, color: _roleColor),
                  suffixIcon: IconButton(
                    icon: Icon(_obscureCpw ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                    onPressed: () => setState(() => _obscureCpw = !_obscureCpw),
                  ),
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Please confirm your password';
                  if (v != _pwCtrl.text) return 'Passwords do not match';
                  return null;
                },
              ),
              const SizedBox(height: 28),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: _roleColor),
                  onPressed: auth.isLoading ? null : _signUp,
                  child: auth.isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Create Account & Login'),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text('Login', style: TextStyle(color: _roleColor, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
