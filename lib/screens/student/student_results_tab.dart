import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../utils/mock_data.dart';
import '../../widgets/common_widgets.dart';

class StudentResultsTab extends StatefulWidget {
  const StudentResultsTab({super.key});

  @override
  State<StudentResultsTab> createState() => _StudentResultsTabState();
}

class _StudentResultsTabState extends State<StudentResultsTab> {
  final _idCtrl = TextEditingController();
  String _examType = 'Mid-Term';
  List<Map<String, dynamic>>? _results;
  bool _loading = false;
  String? _error;

  static const _examTypes = ['Mid-Term', 'Final', 'Unit Test 1'];

  Future<void> _fetchResults() async {
    final id = _idCtrl.text.trim();
    if (id.isEmpty) {
      setState(() => _error = 'Please enter a Student ID');
      return;
    }
    setState(() { _loading = true; _error = null; });
    await Future.delayed(const Duration(milliseconds: 700));
    final data = MockData.examResults[id]?[_examType];
    setState(() {
      _loading = false;
      if (data != null) {
        _results = List<Map<String, dynamic>>.from(data);
        _error = null;
      } else {
        _results = null;
        _error = 'No results found for ID "$id" — $_examType';
      }
    });
  }

  double get _totalMarks => _results?.fold(0.0, (sum, r) => sum! + (r['marks'] as num)) ?? 0;
  double get _totalMax   => _results?.fold(0.0, (sum, r) => sum! + (r['total'] as num))  ?? 0;
  double get _percentage => _totalMax > 0 ? (_totalMarks / _totalMax) * 100 : 0;

  Color _barColor(int marks, int total) {
    final p = marks / total;
    if (p >= 0.9) return AppTheme.studentColor;
    if (p >= 0.75) return AppTheme.success;
    if (p >= 0.6) return AppTheme.warning;
    return AppTheme.error;
  }

  @override
  void dispose() { _idCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Input Card ───────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Fetch Results', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _idCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Student ID',
                      hintText: 'e.g. STU001',
                      prefixIcon: Icon(Icons.badge_outlined, color: AppTheme.studentColor),
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<String>(
                    value: _examType,
                    decoration: const InputDecoration(
                      labelText: 'Exam Type',
                      prefixIcon: Icon(Icons.edit_note, color: AppTheme.studentColor),
                    ),
                    items: _examTypes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setState(() { _examType = v!; _results = null; }),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.search),
                      label: const Text('Fetch Results'),
                      onPressed: _loading ? null : _fetchResults,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Error ────────────────────────────────────────────
          if (_error != null) Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Card(
              color: AppTheme.error.withOpacity(0.08),
              child: ListTile(
                leading: const Icon(Icons.error_outline, color: AppTheme.error),
                title: Text(_error!, style: const TextStyle(color: AppTheme.error)),
              ),
            ),
          ),

          // ── Loading ──────────────────────────────────────────
          if (_loading) const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(child: CircularProgressIndicator(color: AppTheme.studentColor)),
          ),

          // ── Results ──────────────────────────────────────────
          if (_results != null && !_loading) ...[
            const SizedBox(height: 16),
            // Summary card
            Card(
              color: AppTheme.studentColor,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Overall Score', style: TextStyle(color: Colors.white70, fontSize: 13)),
                          const SizedBox(height: 6),
                          Text('${_totalMarks.toInt()} / ${_totalMax.toInt()}',
                            style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('$_examType Results', style: const TextStyle(color: Colors.white70, fontSize: 13)),
                        ],
                      ),
                    ),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 80, height: 80,
                          child: CircularProgressIndicator(
                            value: _percentage / 100,
                            strokeWidth: 7,
                            backgroundColor: Colors.white24,
                            valueColor: const AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                        Text('${_percentage.toStringAsFixed(1)}%',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Text('Subject-wise Marks', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            ),
            ..._results!.map((r) {
              final marks = r['marks'] as int;
              final total = r['total'] as int;
              final grade = r['grade'] as String;
              final color = _barColor(marks, total);
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: Text(r['subject'] as String,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15))),
                          GradeBadge(grade: grade),
                          const SizedBox(width: 12),
                          Text('$marks / $total', style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 15)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: marks / total,
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation(color),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
