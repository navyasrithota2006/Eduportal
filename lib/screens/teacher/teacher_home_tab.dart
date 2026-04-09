import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/auth_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/mock_data.dart';
import '../../widgets/common_widgets.dart';

class TeacherHomeTab extends StatefulWidget {
  const TeacherHomeTab({super.key});

  @override
  State<TeacherHomeTab> createState() => _TeacherHomeTabState();
}

class _TeacherHomeTabState extends State<TeacherHomeTab> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  String get _dayName {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    return days[_selectedDate.weekday - 1];
  }

  List<Map<String, String>> get _todayClasses => MockData.teacherTimetable[_dayName] ?? [];

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser!;
    final extra = user.extraData;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ───────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
            decoration: const BoxDecoration(
              color: AppTheme.teacherColor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AvatarCircle(name: user.name, radius: 28, color: Colors.white),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Good ${_greeting()}, Teacher!',
                            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
                          Text(user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  children: [
                    _chip(extra['subject'] ?? 'Math Teacher', Icons.book),
                    _chip('ID: ${user.id}', Icons.badge),
                  ],
                ),
              ],
            ),
          ),

          // ── Quick Stats ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Row(
              children: [
                _MiniStat('Classes Today', '${_todayClasses.length}', Icons.today, AppTheme.teacherColor),
                const SizedBox(width: 12),
                _MiniStat('Total Students', '42', Icons.groups, Colors.orange),
                const SizedBox(width: 12),
                _MiniStat('Leaves Pending', '1', Icons.pending_actions, AppTheme.warning),
              ],
            ),
          ),

          // ── Date Selector ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Row(
              children: [
                const Text('Daily Timetable', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const Spacer(),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.teacherColor,
                    side: const BorderSide(color: AppTheme.teacherColor),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  ),
                  icon: const Icon(Icons.calendar_month, size: 16),
                  label: Text('${_selectedDate.day}/${_selectedDate.month}', style: const TextStyle(fontSize: 13)),
                  onPressed: _pickDate,
                ),
              ],
            ),
          ),

          // ── Day Tabs ─────────────────────────────────────────
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'].map((day) {
                final fullDay = _shortToFull(day);
                final selected = _dayName.startsWith(fullDay.substring(0, 3));
                return GestureDetector(
                  onTap: () {
                    final now = DateTime.now();
                    final wStart = now.subtract(Duration(days: now.weekday - 1));
                    setState(() => _selectedDate = wStart.add(Duration(days: _shortToIndex(day))));
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? AppTheme.teacherColor : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: selected ? AppTheme.teacherColor : Colors.grey.shade300),
                    ),
                    child: Text(day,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : AppTheme.textSecondary,
                      )),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),

          // ── Timetable ────────────────────────────────────────
          if (_todayClasses.isEmpty)
            const Padding(
              padding: EdgeInsets.all(40),
              child: Center(child: Text('No classes on this day', style: TextStyle(color: AppTheme.textSecondary))),
            )
          else
            ..._todayClasses.asMap().entries.map((e) {
              final i = e.key;
              final cls = e.value;
              const colors = [AppTheme.teacherColor, Colors.orange, Color(0xFF6A1B9A), Color(0xFF00838F)];
              final c = colors[i % colors.length];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Card(
                  margin: EdgeInsets.zero,
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Container(width: 5, decoration: BoxDecoration(
                          color: c,
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                        )),
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(cls['time']!, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                              const SizedBox(height: 4),
                              Text(cls['subject']!, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Row(children: [
                                Icon(Icons.class_, size: 14, color: c),
                                const SizedBox(width: 4),
                                Text('Class ${cls['class']}-${cls['section']}',
                                  style: TextStyle(fontSize: 13, color: c, fontWeight: FontWeight.w600)),
                              ]),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: c.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                            child: Icon(Icons.calculate, color: c, size: 22),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _chip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 14, color: Colors.white),
        const SizedBox(width: 5),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white)),
      ]),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Morning';
    if (h < 17) return 'Afternoon';
    return 'Evening';
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2026, 1),
      lastDate: DateTime(2027, 12),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  String _shortToFull(String s) {
    const map = {'Mon': 'Monday', 'Tue': 'Tuesday', 'Wed': 'Wednesday', 'Thu': 'Thursday', 'Fri': 'Friday'};
    return map[s]!;
  }

  int _shortToIndex(String s) {
    const map = {'Mon': 0, 'Tue': 1, 'Wed': 2, 'Thu': 3, 'Fri': 4};
    return map[s]!;
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MiniStat(this.label, this.value, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
