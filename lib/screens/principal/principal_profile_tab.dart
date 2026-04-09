import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/auth_provider.dart';
import '../../utils/app_theme.dart';
import '../../widgets/common_widgets.dart';

class PrincipalProfileTab extends StatelessWidget {
  const PrincipalProfileTab({super.key});

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
              color: AppTheme.principalColor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Column(
              children: [
                AvatarCircle(name: user.name, radius: 50, color: Colors.white),
                const SizedBox(height: 14),
                Text(user.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text(user.email, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                  child: const Text('Principal', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),

          // ── Edit ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.edit_outlined, color: AppTheme.principalColor),
                label: const Text('Edit Profile', style: TextStyle(color: AppTheme.principalColor)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.principalColor)),
                onPressed: () {},
              ),
            ),
          ),

          // ── Contact Info ─────────────────────────────────────
          const SectionHeader(title: 'Contact Information'),
          _Section(color: AppTheme.principalColor, items: [
            _Item(Icons.badge, 'Principal ID', user.id),
            _Item(Icons.email_outlined, 'Email', user.email),
            _Item(Icons.phone_outlined, 'Contact Number', extra['phone'] ?? '9911223344'),
          ]),

          // ── Branch ───────────────────────────────────────────
          const SectionHeader(title: 'Branch Details'),
          _Section(color: AppTheme.principalColor, items: [
            _Item(Icons.business, 'Branch', extra['branch'] ?? 'Delhi Main Campus'),
            _Item(Icons.school, 'Institution', 'EduPortal School System'),
            _Item(Icons.calendar_today, 'Academic Year', '2025 – 2026'),
            _Item(Icons.people, 'Total Strength', '1,240 Students • 68 Staff'),
          ]),

          // ── Salary ───────────────────────────────────────────
          const SectionHeader(title: 'Salary Status'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppTheme.principalColor, Color(0xFF9C27B0)],
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.account_balance, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('April 2026 Salary', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                      Text(extra['salary_amount'] ?? '₹1,20,000',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    ]),
                    const Spacer(),
                    StatusChip(label: extra['salary_status'] ?? 'Credited'),
                  ],
                ),
              ),
            ),
          ),

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
}

class _Section extends StatelessWidget {
  final Color color;
  final List<_Item> items;
  const _Section({required this.color, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(children: items.map((item) => Column(children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(item.icon, color: color, size: 20),
          ),
          title: Text(item.label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          subtitle: Text(item.value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ),
        if (item != items.last) const Divider(height: 1, indent: 60),
      ])).toList()),
    );
  }
}

class _Item {
  final IconData icon;
  final String label;
  final String value;
  const _Item(this.icon, this.label, this.value);
}
