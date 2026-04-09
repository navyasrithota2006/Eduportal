import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/auth_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/mock_data.dart';
import '../../widgets/common_widgets.dart';

class StudentHomeTab extends StatelessWidget {
  const StudentHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser!;
    final extra = user.extraData;
    final attendance = (extra['attendance'] as num?)?.toDouble() ?? 0.0;
    final todayName = _todayName();
    final meal = MockData.weeklyMeal.firstWhere(
      (m) => m['day'] == todayName,
      orElse: () => {'menu': 'No meal info available'},
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header Banner ────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
            decoration: const BoxDecoration(
              color: AppTheme.studentColor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back,', style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.85))),
                const SizedBox(height: 4),
                Text(user.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                  child: Text('Class ${extra['class']} – Section ${extra['section']} | ID: ${user.id}',
                    style: const TextStyle(color: Colors.white, fontSize: 13)),
                ),
              ],
            ),
          ),

          // ── Stats Cards ──────────────────────────────────────
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(child: _StatMiniCard(
                  label: 'Attendance',
                  value: '$attendance%',
                  icon: Icons.how_to_reg,
                  color: attendance >= 85 ? AppTheme.success : AppTheme.warning,
                )),
                const SizedBox(width: 12),
                Expanded(child: _StatMiniCard(
                  label: 'Class',
                  value: '${extra['class']} – ${extra['section']}',
                  icon: Icons.class_,
                  color: AppTheme.studentColor,
                )),
              ],
            ),
          ),

          // ── Attendance Progress ──────────────────────────────
          const SectionHeader(title: 'Attendance Overview'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Text('Overall Attendance', style: TextStyle(fontWeight: FontWeight.w600)),
                        const Spacer(),
                        Text('$attendance%', style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.studentColor)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: attendance / 100,
                        minHeight: 10,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation(attendance >= 85 ? AppTheme.success : AppTheme.warning),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          attendance >= 75 ? Icons.check_circle : Icons.warning,
                          size: 14,
                          color: attendance >= 75 ? AppTheme.success : AppTheme.warning,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          attendance >= 75 ? 'Above required 75% – Keep it up!' : 'Below 75% – Attendance at risk!',
                          style: TextStyle(fontSize: 12, color: attendance >= 75 ? AppTheme.success : AppTheme.warning),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Today's Meal ─────────────────────────────────────
          const SectionHeader(title: "Today's Midday Meal"),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.restaurant, color: Colors.orange),
                ),
                title: Text(todayName, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(meal['menu']!, style: const TextStyle(fontSize: 13)),
              ),
            ),
          ),

          // ── Upcoming ─────────────────────────────────────────
          const SectionHeader(title: 'Upcoming Tasks'),
          ..._upcoming.map((t) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Card(
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (t['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(t['icon'] as IconData, color: t['color'] as Color, size: 20),
                ),
                title: Text(t['title'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                subtitle: Text(t['date'] as String, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (t['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(t['tag'] as String, style: TextStyle(fontSize: 11, color: t['color'] as Color, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          )),
        ],
      ),
    );
  }

  String _todayName() {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[DateTime.now().weekday - 1];
  }

  static const List<Map<String, dynamic>> _upcoming = [
    {'title': 'Mathematics Assignment', 'date': 'Due: April 12, 2026', 'icon': Icons.assignment, 'color': AppTheme.studentColor, 'tag': 'Assignment'},
    {'title': 'Science Project', 'date': 'Due: April 15, 2026', 'icon': Icons.science, 'color': Color(0xFF2E7D32), 'tag': 'Project'},
    {'title': 'Mid-Term Exams', 'date': 'April 20 – April 25, 2026', 'icon': Icons.edit_note, 'color': Colors.orange, 'tag': 'Exam'},
    {'title': 'Annual Sports Day', 'date': 'April 20, 2026', 'icon': Icons.sports_soccer, 'color': Colors.purple, 'tag': 'Event'},
  ];
}

class _StatMiniCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatMiniCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
