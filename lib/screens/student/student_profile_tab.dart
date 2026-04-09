import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/auth_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class StudentProfileTab extends StatelessWidget {
  const StudentProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser!;
    final extra = user.extraData;

    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Profile Header ───────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 28),
            decoration: const BoxDecoration(
              color: AppTheme.studentColor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    AvatarCircle(name: user.name, radius: 45, color: Colors.white),
                    Positioned(
                      right: 0, bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt, size: 16, color: AppTheme.studentColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text(user.email, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('Student', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),

          // ── Edit Button ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.edit_outlined, color: AppTheme.studentColor),
                label: const Text('Edit Profile', style: TextStyle(color: AppTheme.studentColor)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.studentColor)),
                onPressed: () => _showEditDialog(context),
              ),
            ),
          ),

          // ── Details ──────────────────────────────────────────
          const SectionHeader(title: 'Personal Information'),
          _ProfileSection(items: [
            _InfoItem(icon: Icons.badge, label: 'Student ID', value: user.id),
            _InfoItem(icon: Icons.class_, label: 'Class & Section', value: 'Class ${extra['class']} – Section ${extra['section']}'),
            _InfoItem(icon: Icons.email_outlined, label: 'Email', value: user.email),
            _InfoItem(icon: Icons.location_on_outlined, label: 'Address', value: extra['address']?.toString().isNotEmpty == true ? extra['address'] : '12, Rose Garden, Mumbai – 400001'),
          ]),

          const SectionHeader(title: 'Guardian Information'),
          _ProfileSection(items: [
            _InfoItem(icon: Icons.family_restroom, label: 'Guardian', value: extra['guardian']?.toString().isNotEmpty == true ? extra['guardian'] : 'Rajesh Sharma (Father)'),
            _InfoItem(icon: Icons.phone_outlined, label: 'Contact', value: '9876543210'),
          ]),

          const SectionHeader(title: 'Academic Info'),
          _ProfileSection(items: [
            _InfoItem(icon: Icons.how_to_reg, label: 'Attendance', value: '${extra['attendance']}%'),
            _InfoItem(icon: Icons.school, label: 'Academic Year', value: '2025 – 2026'),
            _InfoItem(icon: Icons.workspace_premium, label: 'Status', value: 'Active'),
          ]),

          const SizedBox(height: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                onPressed: () {
                  context.read<AuthProvider>().logout();
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Profile'),
        content: const Text('Profile editing will be available in a future update.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('OK'))],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  final List<_InfoItem> items;
  const _ProfileSection({required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        children: items.map((item) => Column(
          children: [
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.studentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(item.icon, color: AppTheme.studentColor, size: 20),
              ),
              title: Text(item.label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
              subtitle: Text(item.value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
            ),
            if (item != items.last) const Divider(height: 1, indent: 60),
          ],
        )).toList(),
      ),
    );
  }
}

class _InfoItem {
  final IconData icon;
  final String label;
  final String value;
  const _InfoItem({required this.icon, required this.label, required this.value});
}
