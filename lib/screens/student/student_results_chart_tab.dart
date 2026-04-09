// ─────────────────────────────────────────────────────────────────────────────
// student_results_chart_tab.dart
// Replaces student_results_tab.dart with full fl_chart bar chart integration.
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/app_theme.dart';
import '../../utils/mock_data.dart';
import '../../widgets/common_widgets.dart';

class StudentResultsChartTab extends StatefulWidget {
  const StudentResultsChartTab({super.key});

  @override
  State<StudentResultsChartTab> createState() => _StudentResultsChartTabState();
}

class _StudentResultsChartTabState extends State<StudentResultsChartTab>
    with SingleTickerProviderStateMixin {
  final _idCtrl = TextEditingController();
  String _examType = 'Mid-Term';
  List<Map<String, dynamic>>? _results;
  bool _loading = false;
  String? _error;
  late TabController _viewCtrl;

  static const _examTypes = ['Mid-Term', 'Final', 'Unit Test 1'];

  @override
  void initState() {
    super.initState();
    _viewCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _idCtrl.dispose();
    _viewCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchResults() async {
    final id = _idCtrl.text.trim();
    if (id.isEmpty) { setState(() => _error = 'Please enter a Student ID'); return; }
    setState(() { _loading = true; _error = null; });
    await Future.delayed(const Duration(milliseconds: 700));
    final data = MockData.examResults[id]?[_examType];
    setState(() {
      _loading = false;
      if (data != null) { _results = List<Map<String, dynamic>>.from(data); _error = null; }
      else { _results = null; _error = 'No results for "$id" – $_examType'; }
    });
  }

  double get _totalMarks => _results?.fold(0.0, (s, r) => s! + (r['marks'] as num)) ?? 0;
  double get _totalMax   => _results?.fold(0.0, (s, r) => s! + (r['total']  as num)) ?? 0;
  double get _percentage => _totalMax > 0 ? (_totalMarks / _totalMax) * 100 : 0;

  Color _gradeColor(int marks, int total) {
    final p = marks / total;
    if (p >= 0.9) return AppTheme.studentColor;
    if (p >= 0.75) return AppTheme.success;
    if (p >= 0.6) return AppTheme.warning;
    return AppTheme.error;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Input Card ────────────────────────────────────────
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Fetch Exam Results',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 14),
                  TextField(
                    controller: _idCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Student ID (e.g. STU001)',
                      prefixIcon: Icon(Icons.badge_outlined, color: AppTheme.studentColor),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: _examType,
                    decoration: const InputDecoration(
                      labelText: 'Exam Type',
                      prefixIcon: Icon(Icons.edit_note, color: AppTheme.studentColor),
                    ),
                    items: _examTypes.map((e) =>
                      DropdownMenuItem(value: e, child: Text(e))).toList(),
                    onChanged: (v) => setState(() { _examType = v!; _results = null; }),
                  ),
                  const SizedBox(height: 14),
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

          // ── Error ──────────────────────────────────────────────
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

          if (_loading) const Padding(
            padding: EdgeInsets.only(top: 40),
            child: Center(child: CircularProgressIndicator(color: AppTheme.studentColor)),
          ),

          if (_results != null && !_loading) ...[
            const SizedBox(height: 16),

            // ── Score Banner ─────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.studentColor, Color(0xFF1976D2)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(20),
              child: Row(children: [
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Score', style: TextStyle(color: Colors.white70, fontSize: 13)),
                    const SizedBox(height: 4),
                    Text('${_totalMarks.toInt()} / ${_totalMax.toInt()}',
                      style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 2),
                    Text(_examType, style: const TextStyle(color: Colors.white70, fontSize: 13)),
                  ],
                )),
                // Donut
                SizedBox(width: 90, height: 90,
                  child: Stack(alignment: Alignment.center, children: [
                    PieChart(PieChartData(
                      sections: [
                        PieChartSectionData(
                          value: _percentage, color: Colors.white,
                          radius: 12, showTitle: false,
                        ),
                        PieChartSectionData(
                          value: 100 - _percentage,
                          color: Colors.white24, radius: 12, showTitle: false,
                        ),
                      ],
                      centerSpaceRadius: 34,
                      sectionsSpace: 2,
                    )),
                    Text('${_percentage.toStringAsFixed(0)}%',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                  ]),
                ),
              ]),
            ),

            const SizedBox(height: 16),

            // ── View Toggle ──────────────────────────────────────
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)],
              ),
              child: TabBar(
                controller: _viewCtrl,
                labelColor: AppTheme.studentColor,
                unselectedLabelColor: AppTheme.textSecondary,
                indicator: BoxDecoration(
                  color: AppTheme.studentColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                tabs: const [
                  Tab(icon: Icon(Icons.bar_chart), text: 'Bar Chart'),
                  Tab(icon: Icon(Icons.list),      text: 'Details'),
                ],
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              height: _viewCtrl.index == 0 ? 320 : (_results!.length * 80.0 + 20),
              child: TabBarView(
                controller: _viewCtrl,
                children: [
                  // ── Bar Chart ──────────────────────────────────
                  _buildBarChart(),
                  // ── Detail List ────────────────────────────────
                  _buildDetailList(),
                ],
              ),
            ),

            // ── Legend / Grade Key ───────────────────────────────
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Grade Legend', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    const SizedBox(height: 10),
                    Wrap(spacing: 8, runSpacing: 6, children: const [
                      GradeBadge(grade: 'A+'), GradeBadge(grade: 'A'),
                      GradeBadge(grade: 'B+'), GradeBadge(grade: 'B'),
                    ]),
                    const SizedBox(height: 8),
                    const Text('A+ ≥ 90%  •  A ≥ 80%  •  B+ ≥ 70%  •  B ≥ 60%',
                      style: TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    final subjects = _results!.map((r) => r['subject'] as String).toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 20, 12),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 110,
            minY: 0,
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, _, rod, __) {
                  final s = _results![group.x];
                  return BarTooltipItem(
                    '${s['subject']}\n${s['marks']}/${s['total']} (${s['grade']})',
                    const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 36,
                  getTitlesWidget: (v, meta) {
                    final label = subjects[v.toInt()];
                    final short = label.length > 4 ? label.substring(0, 4) : label;
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(short, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600)),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  getTitlesWidget: (v, _) => Text(
                    '${v.toInt()}',
                    style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary),
                  ),
                  interval: 20,
                ),
              ),
              topTitles:   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            gridData: FlGridData(
              show: true,
              horizontalInterval: 20,
              getDrawingHorizontalLine: (_) => FlLine(color: Colors.grey.shade200, strokeWidth: 1),
              drawVerticalLine: false,
            ),
            borderData: FlBorderData(show: false),
            barGroups: _results!.asMap().entries.map((e) {
              final i = e.key;
              final r = e.value;
              final marks = (r['marks'] as int).toDouble();
              final total = (r['total'] as int).toDouble();
              final color = _gradeColor(marks.toInt(), total.toInt());
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: marks,
                    width: 22,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [color.withOpacity(0.6), color],
                    ),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: total,
                      color: Colors.grey.shade100,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailList() {
    return Column(
      children: _results!.map((r) {
        final marks = r['marks'] as int;
        final total = r['total'] as int;
        final color = _gradeColor(marks, total);
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(child: Text(r['subject'] as String,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15))),
                GradeBadge(grade: r['grade'] as String),
                const SizedBox(width: 10),
                Text('$marks/$total',
                  style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 15)),
              ]),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: marks / total,
                  minHeight: 8,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation(color),
                ),
              ),
            ]),
          ),
        );
      }).toList(),
    );
  }
}
