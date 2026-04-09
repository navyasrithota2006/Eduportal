import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../utils/mock_data.dart';

class TeacherAttendanceTab extends StatefulWidget {
  const TeacherAttendanceTab({super.key});

  @override
  State<TeacherAttendanceTab> createState() => _TeacherAttendanceTabState();
}

class _TeacherAttendanceTabState extends State<TeacherAttendanceTab> {
  DateTime _date = DateTime.now();
  String _grade = '10';
  String _section = 'A';
  Map<String, bool> _attendance = {};
  bool _submitted = false;

  static const _grades = ['8', '9', '10'];
  static const _sections = ['A', 'B'];

  List<Map<String, dynamic>> get _students =>
    MockData.studentsList.where((s) => s['class'] == _grade && s['section'] == _section).toList();

  void _initAttendance() {
    _attendance = { for (var s in _students) s['id'] as String: true };
    _submitted = false;
  }

  void _submit() {
    final presentCount = _attendance.values.where((v) => v).length;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Attendance saved! $presentCount/${_students.length} present.'),
        backgroundColor: AppTheme.success,
      ),
    );
    setState(() => _submitted = true);
  }

  @override
  void initState() {
    super.initState();
    _initAttendance();
  }

  @override
  Widget build(BuildContext context) {
    if (_attendance.isEmpty) _initAttendance();
    final presentCount = _attendance.values.where((v) => v).length;

    return Column(
      children: [
        // ── Filter Bar ───────────────────────────────────────
        Container(
          color: AppTheme.teacherColor,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.fact_check, color: Colors.white),
                  const SizedBox(width: 8),
                  const Text('Mark Attendance', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
                  const Spacer(),
                  OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white54)),
                    icon: const Icon(Icons.calendar_month, size: 16),
                    label: Text('${_date.day}/${_date.month}/${_date.year}', style: const TextStyle(fontSize: 12)),
                    onPressed: () async {
                      final p = await showDatePicker(context: context,
                        initialDate: _date, firstDate: DateTime(2026), lastDate: DateTime(2027));
                      if (p != null) setState(() { _date = p; _submitted = false; });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _DropChip(
                    label: 'Grade',
                    value: _grade,
                    items: _grades,
                    onChanged: (v) => setState(() { _grade = v!; _initAttendance(); }),
                  ),
                  const SizedBox(width: 10),
                  _DropChip(
                    label: 'Section',
                    value: _section,
                    items: _sections,
                    onChanged: (v) => setState(() { _section = v!; _initAttendance(); }),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('$presentCount / ${_students.length} Present',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                  ),
                ],
              ),
            ],
          ),
        ),

        // ── Mark All Buttons ─────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Mark All Present'),
                  style: OutlinedButton.styleFrom(foregroundColor: AppTheme.success, side: const BorderSide(color: AppTheme.success)),
                  onPressed: () => setState(() {
                    for (var key in _attendance.keys) _attendance[key] = true;
                    _submitted = false;
                  }),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.cancel_outlined, size: 18),
                  label: const Text('Mark All Absent'),
                  style: OutlinedButton.styleFrom(foregroundColor: AppTheme.error, side: const BorderSide(color: AppTheme.error)),
                  onPressed: () => setState(() {
                    for (var key in _attendance.keys) _attendance[key] = false;
                    _submitted = false;
                  }),
                ),
              ),
            ],
          ),
        ),

        // ── Student List ─────────────────────────────────────
        Expanded(
          child: _students.isEmpty
            ? const Center(child: Text('No students in this class-section'))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _students.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (_, i) {
                  final s = _students[i];
                  final id = s['id'] as String;
                  final present = _attendance[id] ?? true;
                  return Card(
                    margin: EdgeInsets.zero,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: (present ? AppTheme.success : AppTheme.error).withOpacity(0.15),
                        child: Text(
                          (s['name'] as String).split(' ').map((w) => w[0]).take(2).join(),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: present ? AppTheme.success : AppTheme.error,
                          ),
                        ),
                      ),
                      title: Text(s['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('ID: $id', style: const TextStyle(fontSize: 12)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(present ? 'Present' : 'Absent',
                            style: TextStyle(
                              color: present ? AppTheme.success : AppTheme.error,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            )),
                          const SizedBox(width: 8),
                          Switch(
                            value: present,
                            activeColor: AppTheme.success,
                            inactiveThumbColor: AppTheme.error,
                            onChanged: (v) => setState(() { _attendance[id] = v; _submitted = false; }),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
        ),

        // ── Submit Button ────────────────────────────────────
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: _submitted ? AppTheme.success : AppTheme.teacherColor),
              icon: Icon(_submitted ? Icons.check : Icons.save),
              label: Text(_submitted ? 'Attendance Saved!' : 'Submit Attendance'),
              onPressed: _submitted ? null : _submit,
            ),
          ),
        ),
      ],
    );
  }
}

class _DropChip extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropChip({required this.label, required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
      child: DropdownButton<String>(
        value: value,
        isDense: true,
        dropdownColor: AppTheme.teacherColor,
        underline: const SizedBox(),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 18),
        items: items.map((e) => DropdownMenuItem(
          value: e,
          child: Text('$label: $e', style: const TextStyle(color: Colors.white)),
        )).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
