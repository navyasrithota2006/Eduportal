import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../utils/mock_data.dart';
import '../../widgets/common_widgets.dart';

class TeacherReportsTab extends StatefulWidget {
  const TeacherReportsTab({super.key});

  @override
  State<TeacherReportsTab> createState() => _TeacherReportsTabState();
}

class _TeacherReportsTabState extends State<TeacherReportsTab> {
  String _grade = '10';
  String _section = 'A';
  List<Map<String, dynamic>>? _students;
  bool _loading = false;

  static const _grades = ['8', '9', '10'];
  static const _sections = ['A', 'B'];

  Future<void> _fetchReports() async {
    setState(() { _loading = true; _students = null; });
    await Future.delayed(const Duration(milliseconds: 600));
    final result = MockData.studentsList
      .where((s) => s['class'] == _grade && s['section'] == _section)
      .toList();
    setState(() { _loading = false; _students = result; });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // ── Filter Card ──────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Academic Performance Reports',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _grade,
                          decoration: const InputDecoration(labelText: 'Class', prefixIcon: Icon(Icons.class_, color: AppTheme.teacherColor)),
                          items: _grades.map((e) => DropdownMenuItem(value: e, child: Text('Class $e'))).toList(),
                          onChanged: (v) => setState(() { _grade = v!; _students = null; }),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _section,
                          decoration: const InputDecoration(labelText: 'Section', prefixIcon: Icon(Icons.segment, color: AppTheme.teacherColor)),
                          items: _sections.map((e) => DropdownMenuItem(value: e, child: Text('Section $e'))).toList(),
                          onChanged: (v) => setState(() { _section = v!; _students = null; }),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.teacherColor),
                      icon: const Icon(Icons.assessment),
                      label: const Text('Fetch Reports'),
                      onPressed: _loading ? null : _fetchReports,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Loading ──────────────────────────────────────────
          if (_loading) const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(child: CircularProgressIndicator(color: AppTheme.teacherColor)),
          ),

          // ── Results ──────────────────────────────────────────
          if (_students != null && !_loading) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Text('Class $_grade – Section $_section',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text('${_students!.length} students', style: const TextStyle(color: AppTheme.textSecondary)),
              ],
            ),
            const SizedBox(height: 8),
            // Summary stats
            Row(
              children: [
                _SumCard('Avg. Attendance',
                  '${(_students!.fold(0, (s, e) => s + (e['attendance'] as int)) / _students!.length).toStringAsFixed(1)}%',
                  AppTheme.teacherColor),
                const SizedBox(width: 8),
                _SumCard('Top Scorer', _students!.reduce((a, b) =>
                  (a['attendance'] as int) > (b['attendance'] as int) ? a : b)['name'].toString().split(' ').first,
                  AppTheme.success),
                const SizedBox(width: 8),
                _SumCard('At Risk', '${_students!.where((s) => (s['attendance'] as int) < 80).length}',
                  AppTheme.warning),
              ],
            ),
            const SizedBox(height: 12),
            ..._students!.map((s) {
              final att = s['attendance'] as int;
              final subjectMarks = MockData.examResults[s['id']]?['Mid-Term'] ?? [];
              final total = subjectMarks.isEmpty ? 0 : subjectMarks.fold(0, (sum, r) => sum + (r['marks'] as int));
              final maxTotal = subjectMarks.isEmpty ? 0 : subjectMarks.fold(0, (sum, r) => sum + (r['total'] as int));
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ExpansionTile(
                  leading: CircleAvatar(
                    backgroundColor: AppTheme.teacherColor.withOpacity(0.1),
                    child: Text(
                      (s['name'] as String).split(' ').map((w) => w[0]).take(2).join(),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.teacherColor),
                    ),
                  ),
                  title: Text(s['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text('ID: ${s['id']} • Attendance: $att%'),
                  trailing: StatusChip(label: att >= 85 ? 'Good' : att >= 75 ? 'Average' : 'At Risk'),
                  children: [
                    if (subjectMarks.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Mid-Term Score: $total / $maxTotal  (${maxTotal > 0 ? (total/maxTotal*100).toStringAsFixed(1) : 0}%)',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            ...subjectMarks.map((r) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(children: [
                                SizedBox(width: 120, child: Text(r['subject'] as String, style: const TextStyle(fontSize: 13))),
                                Expanded(child: ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: (r['marks'] as int) / (r['total'] as int),
                                    minHeight: 6,
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor: const AlwaysStoppedAnimation(AppTheme.teacherColor),
                                  ),
                                )),
                                const SizedBox(width: 8),
                                Text('${r['marks']}/${r['total']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                              ]),
                            )),
                          ],
                        ),
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('No exam data available for this student.',
                          style: TextStyle(color: AppTheme.textSecondary)),
                      ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _SumCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SumCard(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 3),
            Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
