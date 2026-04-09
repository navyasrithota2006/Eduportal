import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../utils/mock_data.dart';

class TeacherStudentsTab extends StatefulWidget {
  const TeacherStudentsTab({super.key});

  @override
  State<TeacherStudentsTab> createState() => _TeacherStudentsTabState();
}

class _TeacherStudentsTabState extends State<TeacherStudentsTab> {
  String _grade = 'All';
  String _section = 'All';
  String _search = '';

  static const _grades = ['All', '8', '9', '10'];
  static const _sections = ['All', 'A', 'B'];

  List<Map<String, dynamic>> get _filtered {
    return MockData.studentsList.where((s) {
      final matchGrade   = _grade == 'All'   || s['class'] == _grade;
      final matchSection = _section == 'All' || s['section'] == _section;
      final matchSearch  = _search.isEmpty  || (s['name'] as String).toLowerCase().contains(_search.toLowerCase())
                          || (s['id'] as String).toLowerCase().contains(_search.toLowerCase());
      return matchGrade && matchSection && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final students = _filtered;
    return Column(
      children: [
        // ── Filter Header ────────────────────────────────────
        Container(
          color: AppTheme.teacherColor,
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            children: [
              Row(children: [
                const Icon(Icons.groups, color: Colors.white),
                const SizedBox(width: 8),
                const Text('Students', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
                  child: Text('${students.length} found', style: const TextStyle(color: Colors.white, fontSize: 13)),
                ),
              ]),
              const SizedBox(height: 12),
              TextField(
                onChanged: (v) => setState(() => _search = v),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search by name or ID...',
                  hintStyle: const TextStyle(color: Colors.white60),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.15),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                ),
              ),
              const SizedBox(height: 10),
              Row(children: [
                _FilterChip(label: 'Grade', value: _grade, items: _grades,
                  onChanged: (v) => setState(() => _grade = v!)),
                const SizedBox(width: 10),
                _FilterChip(label: 'Section', value: _section, items: _sections,
                  onChanged: (v) => setState(() => _section = v!)),
              ]),
            ],
          ),
        ),

        // ── Student List ─────────────────────────────────────
        Expanded(
          child: students.isEmpty
            ? const Center(child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_search, size: 64, color: Colors.grey),
                  SizedBox(height: 12),
                  Text('No students found', style: TextStyle(color: AppTheme.textSecondary)),
                ],
              ))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: students.length,
                separatorBuilder: (_, __) => const SizedBox(height: 6),
                itemBuilder: (_, i) {
                  final s = students[i];
                  final att = s['attendance'] as int;
                  return Card(
                    margin: EdgeInsets.zero,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppTheme.teacherColor.withOpacity(0.15),
                        child: Text(
                          (s['name'] as String).split(' ').map((w) => w[0]).take(2).join(),
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.teacherColor),
                        ),
                      ),
                      title: Text(s['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text('ID: ${s['id']}  •  Class ${s['class']}-${s['section']}',
                        style: const TextStyle(fontSize: 12)),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('$att%', style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: att >= 85 ? AppTheme.success : att >= 75 ? AppTheme.warning : AppTheme.error,
                          )),
                          const Text('Att.', style: TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
                        ],
                      ),
                      onTap: () => _showStudent(context, s),
                    ),
                  );
                },
              ),
        ),
      ],
    );
  }

  void _showStudent(BuildContext context, Map<String, dynamic> s) {
    final att = s['attendance'] as int;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 36,
              backgroundColor: AppTheme.teacherColor.withOpacity(0.15),
              child: Text(
                (s['name'] as String).split(' ').map((w) => w[0]).take(2).join(),
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.teacherColor),
              ),
            ),
            const SizedBox(height: 14),
            Text(s['name'] as String, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text('ID: ${s['id']}  •  Class ${s['class']}-${s['section']}',
              style: const TextStyle(color: AppTheme.textSecondary)),
            const SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              _Stat('Attendance', '$att%', att >= 85 ? AppTheme.success : AppTheme.warning),
              _Stat('Class', '${s['class']}-${s['section']}', AppTheme.teacherColor),
              _Stat('Status', 'Active', AppTheme.success),
            ]),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _Stat(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) => Column(children: [
    Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
    Text(label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
  ]);
}

class _FilterChip extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _FilterChip({required this.label, required this.value, required this.items, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
      child: DropdownButton<String>(
        value: value,
        isDense: true,
        dropdownColor: AppTheme.teacherColor,
        underline: const SizedBox(),
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
        icon: const Icon(Icons.arrow_drop_down, color: Colors.white, size: 18),
        items: items.map((e) => DropdownMenuItem(value: e, child: Text('$label: $e', style: const TextStyle(color: Colors.white)))).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
