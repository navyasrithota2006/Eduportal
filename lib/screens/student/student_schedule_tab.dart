import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../utils/mock_data.dart';

class StudentScheduleTab extends StatefulWidget {
  const StudentScheduleTab({super.key});

  @override
  State<StudentScheduleTab> createState() => _StudentScheduleTabState();
}

class _StudentScheduleTabState extends State<StudentScheduleTab> {
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

  List<Map<String, String>> get _schedule => MockData.studentSchedule[_dayName] ?? [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Date Picker Header ───────────────────────────────
        Container(
          color: AppTheme.studentColor,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Class Schedule', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    icon: const Icon(Icons.calendar_month, size: 18),
                    label: const Text('Pick Date', style: TextStyle(fontSize: 13)),
                    onPressed: _pickDate,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Week strip
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  itemBuilder: (_, i) {
                    final date = _weekStart.add(Duration(days: i));
                    final isSelected = date.day == _selectedDate.day && date.month == _selectedDate.month;
                    const days = ['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'];
                    return GestureDetector(
                      onTap: () => setState(() => _selectedDate = date),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 44,
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white : Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(days[i], style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600,
                              color: isSelected ? AppTheme.studentColor : Colors.white70,
                            )),
                            const SizedBox(height: 4),
                            Text('${date.day}', style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,
                              color: isSelected ? AppTheme.studentColor : Colors.white,
                            )),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // ── Selected Date Label ──────────────────────────────
        Container(
          color: AppTheme.surface,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
          child: Row(
            children: [
              const Icon(Icons.today, size: 18, color: AppTheme.studentColor),
              const SizedBox(width: 8),
              Text(_dayName,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
              const SizedBox(width: 8),
              Text('• ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.studentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('${_schedule.length} periods',
                  style: const TextStyle(fontSize: 12, color: AppTheme.studentColor, fontWeight: FontWeight.w600)),
              ),
            ],
          ),
        ),

        // ── Schedule List ────────────────────────────────────
        Expanded(
          child: _schedule.isEmpty
            ? const Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.weekend, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('No classes scheduled', style: TextStyle(color: AppTheme.textSecondary, fontSize: 15)),
                  Text('Enjoy your day off! 🎉', style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                ],
              ))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _schedule.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final p = _schedule[i];
                  final colors = [
                    AppTheme.studentColor, const Color(0xFF2E7D32), const Color(0xFF6A1B9A),
                    Colors.orange, const Color(0xFF00838F), Colors.red.shade700, Colors.indigo,
                  ];
                  final c = colors[i % colors.length];
                  return Card(
                    margin: EdgeInsets.zero,
                    child: IntrinsicHeight(
                      child: Row(
                        children: [
                          Container(width: 5, decoration: BoxDecoration(
                            color: c, borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
                          )),
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  const Icon(Icons.access_time, size: 14, color: AppTheme.textSecondary),
                                  const SizedBox(width: 4),
                                  Text(p['time']!, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                                ]),
                                const SizedBox(height: 6),
                                Text(p['subject']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 4),
                                Row(children: [
                                  const Icon(Icons.person_outline, size: 14, color: AppTheme.textSecondary),
                                  const SizedBox(width: 4),
                                  Text(p['teacher']!, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                                ]),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(14),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: c.withOpacity(0.1), shape: BoxShape.circle),
                              child: Icon(_subjectIcon(p['subject']!), color: c, size: 22),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        ),
      ],
    );
  }

  DateTime get _weekStart {
    final now = _selectedDate;
    return now.subtract(Duration(days: now.weekday - 1));
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

  IconData _subjectIcon(String subject) {
    if (subject.contains('Math')) return Icons.calculate;
    if (subject.contains('Science')) return Icons.science;
    if (subject.contains('English')) return Icons.menu_book;
    if (subject.contains('History')) return Icons.history_edu;
    if (subject.contains('Computer')) return Icons.computer;
    if (subject.contains('Physical')) return Icons.sports;
    if (subject.contains('Geography')) return Icons.public;
    if (subject.contains('Art')) return Icons.palette;
    return Icons.book;
  }
}
