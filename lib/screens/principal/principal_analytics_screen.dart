// ─────────────────────────────────────────────────────────────────────────────
// principal_analytics_screen.dart
// Full-page analytics with pie + bar charts for the principal.
// ─────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/app_theme.dart';
import '../../utils/mock_data.dart';
import '../../widgets/common_widgets.dart';

class PrincipalAnalyticsScreen extends StatefulWidget {
  const PrincipalAnalyticsScreen({super.key});

  @override
  State<PrincipalAnalyticsScreen> createState() => _PrincipalAnalyticsScreenState();
}

class _PrincipalAnalyticsScreenState extends State<PrincipalAnalyticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  int _touchedPieIndex = -1;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() { _tabCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.principalColor,
        title: const Text('School Analytics'),
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Attendance'),
            Tab(text: 'Performance'),
            Tab(text: 'Staff'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _attendanceTab(),
          _performanceTab(),
          _staffTab(),
        ],
      ),
    );
  }

  // ─── Tab 1: Attendance ────────────────────────────────────────────────────
  Widget _attendanceTab() {
    final stats = MockData.principalStats;
    final totalStudents = stats['total_students'] as int;
    final present       = stats['students_present'] as int;
    final absent        = totalStudents - present;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        // Donut Pie Chart
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const Text('Student Attendance Today',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              SizedBox(
                height: 220,
                child: PieChart(PieChartData(
                  pieTouchData: PieTouchData(
                    touchCallback: (e, r) => setState(() =>
                      _touchedPieIndex = (r?.touchedSection?.touchedSectionIndex) ?? -1),
                  ),
                  sections: [
                    PieChartSectionData(
                      value: present.toDouble(),
                      color: AppTheme.success,
                      radius: _touchedPieIndex == 0 ? 90 : 80,
                      title: 'Present\n$present',
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    PieChartSectionData(
                      value: absent.toDouble(),
                      color: AppTheme.error,
                      radius: _touchedPieIndex == 1 ? 90 : 80,
                      title: 'Absent\n$absent',
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                  centerSpaceRadius: 50,
                  sectionsSpace: 3,
                )),
              ),
              const SizedBox(height: 16),
              _legend([
                {'label': 'Present ($present)', 'color': AppTheme.success},
                {'label': 'Absent ($absent)',   'color': AppTheme.error},
              ]),
              const Divider(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                _statCol('Total', '$totalStudents', AppTheme.principalColor),
                _statCol('Present', '$present', AppTheme.success),
                _statCol('Absent', '$absent', AppTheme.error),
                _statCol('Rate', '${(present/totalStudents*100).toStringAsFixed(1)}%', AppTheme.studentColor),
              ]),
            ]),
          ),
        ),

        const SizedBox(height: 12),

        // Class-wise bar chart (mock)
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const Text('Class-wise Attendance %',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              SizedBox(
                height: 220,
                child: BarChart(BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100, minY: 50,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (g, _, rod, __) {
                        const labels = ['Cl 8','Cl 9','Cl 10','Cl 11','Cl 12'];
                        return BarTooltipItem('${labels[g.x]}\n${rod.toY.toStringAsFixed(1)}%',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        const labels = ['Cl 8','Cl 9','Cl 10','Cl 11','Cl 12'];
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(labels[v.toInt()], style: const TextStyle(fontSize: 11)),
                        );
                      },
                    )),
                    leftTitles: AxisTitles(sideTitles: SideTitles(
                      showTitles: true, reservedSize: 36,
                      getTitlesWidget: (v, _) => Text('${v.toInt()}%',
                        style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
                      interval: 10,
                    )),
                    topTitles:   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    horizontalInterval: 10,
                    getDrawingHorizontalLine: (_) => FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [88.0, 91.5, 86.0, 93.0, 89.5].asMap().entries.map((e) =>
                    BarChartGroupData(x: e.key, barRods: [
                      BarChartRodData(
                        toY: e.value,
                        width: 30,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter, end: Alignment.topCenter,
                          colors: [AppTheme.principalColor.withOpacity(0.5), AppTheme.principalColor],
                        ),
                      ),
                    ])
                  ).toList(),
                )),
              ),
            ]),
          ),
        ),
      ]),
    );
  }

  // ─── Tab 2: Academic Performance ─────────────────────────────────────────
  Widget _performanceTab() {
    final subjectAvgs = {
      'Maths': 88.5, 'Science': 91.0, 'English': 79.5,
      'History': 75.0, 'Geo': 82.0, 'CS': 94.0,
    };

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const Text('Subject-wise Average Marks',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              SizedBox(
                height: 260,
                child: BarChart(BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 100,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (g, _, rod, __) {
                        final label = subjectAvgs.keys.toList()[g.x];
                        return BarTooltipItem('$label\n${rod.toY.toStringAsFixed(1)}',
                          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold));
                      },
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (v, _) {
                        final label = subjectAvgs.keys.toList()[v.toInt()];
                        return Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Text(label, style: const TextStyle(fontSize: 10)),
                        );
                      },
                    )),
                    leftTitles: AxisTitles(sideTitles: SideTitles(
                      showTitles: true, reservedSize: 30,
                      getTitlesWidget: (v, _) => Text('${v.toInt()}',
                        style: const TextStyle(fontSize: 10, color: AppTheme.textSecondary)),
                      interval: 20,
                    )),
                    topTitles:   const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    horizontalInterval: 20,
                    getDrawingHorizontalLine: (_) => FlLine(color: Colors.grey.shade200, strokeWidth: 1),
                    drawVerticalLine: false,
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: subjectAvgs.values.toList().asMap().entries.map((e) {
                    const colors = [
                      AppTheme.studentColor, AppTheme.success, AppTheme.principalColor,
                      Colors.orange, AppTheme.info, Color(0xFF00695C),
                    ];
                    final c = colors[e.key % colors.length];
                    return BarChartGroupData(x: e.key, barRods: [
                      BarChartRodData(
                        toY: e.value,
                        width: 26,
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter, end: Alignment.topCenter,
                          colors: [c.withOpacity(0.5), c],
                        ),
                      ),
                    ]);
                  }).toList(),
                )),
              ),
            ]),
          ),
        ),

        const SizedBox(height: 12),

        // Grade distribution Pie
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const Text('Grade Distribution (Mid-Term)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: PieChart(PieChartData(
                  sections: [
                    PieChartSectionData(value: 35, color: AppTheme.studentColor, title: 'A+\n35%',
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    PieChartSectionData(value: 28, color: AppTheme.success, title: 'A\n28%',
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    PieChartSectionData(value: 20, color: AppTheme.info, title: 'B+\n20%',
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    PieChartSectionData(value: 12, color: AppTheme.warning, title: 'B\n12%',
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    PieChartSectionData(value: 5,  color: AppTheme.error, title: 'C\n5%',
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                  ],
                  centerSpaceRadius: 40,
                  sectionsSpace: 3,
                )),
              ),
              const SizedBox(height: 12),
              _legend([
                {'label': 'A+ (≥90%)', 'color': AppTheme.studentColor},
                {'label': 'A (≥80%)',  'color': AppTheme.success},
                {'label': 'B+ (≥70%)', 'color': AppTheme.info},
                {'label': 'B (≥60%)',  'color': AppTheme.warning},
                {'label': 'C (<60%)',  'color': AppTheme.error},
              ]),
            ]),
          ),
        ),
      ]),
    );
  }

  // ─── Tab 3: Staff ────────────────────────────────────────────────────────
  Widget _staffTab() {
    final stats = MockData.principalStats;
    final totalStaff  = stats['total_staff']   as int;
    final staffPresent = stats['staff_present'] as int;
    final staffAbsent = totalStaff - staffPresent;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: [
              const Text('Staff Attendance Today',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              SizedBox(
                height: 200,
                child: PieChart(PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: staffPresent.toDouble(),
                      color: AppTheme.teacherColor,
                      radius: 80,
                      title: 'Present\n$staffPresent',
                      titleStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    PieChartSectionData(
                      value: staffAbsent.toDouble(),
                      color: Colors.grey.shade300,
                      radius: 80,
                      title: 'Absent\n$staffAbsent',
                      titleStyle: const TextStyle(color: Colors.black54, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ],
                  centerSpaceRadius: 50,
                  sectionsSpace: 3,
                )),
              ),
              const Divider(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                _statCol('Total Staff',  '$totalStaff',  AppTheme.principalColor),
                _statCol('Present',      '$staffPresent', AppTheme.teacherColor),
                _statCol('On Leave',     '$staffAbsent',  AppTheme.warning),
                _statCol('Rate', '${(staffPresent/totalStaff*100).toStringAsFixed(1)}%', AppTheme.success),
              ]),
            ]),
          ),
        ),

        const SizedBox(height: 12),

        // Department breakdown
        const SectionHeader(title: 'Department-wise Presence'),
        ...[
          {'dept': 'Science', 'present': 8, 'total': 9, 'color': AppTheme.success},
          {'dept': 'Mathematics', 'present': 6, 'total': 6, 'color': AppTheme.studentColor},
          {'dept': 'Languages', 'present': 7, 'total': 8, 'color': AppTheme.principalColor},
          {'dept': 'Social Studies', 'present': 5, 'total': 6, 'color': Colors.orange},
          {'dept': 'Physical Ed.', 'present': 3, 'total': 3, 'color': AppTheme.info},
          {'dept': 'Arts & Music', 'present': 4, 'total': 5, 'color': Colors.pink},
        ].map((d) {
          final p = d['present'] as int;
          final t = d['total']   as int;
          final c = d['color']   as Color;
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Text(d['dept'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  const Spacer(),
                  Text('$p / $t', style: TextStyle(fontWeight: FontWeight.bold, color: c)),
                ]),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: p / t,
                    minHeight: 8,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(c),
                  ),
                ),
              ]),
            ),
          );
        }),
        const SizedBox(height: 16),
      ]),
    );
  }

  Widget _legend(List<Map<String, dynamic>> items) {
    return Wrap(
      spacing: 16, runSpacing: 6,
      children: items.map((item) => Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(
          color: item['color'] as Color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(item['label'] as String, style: const TextStyle(fontSize: 12)),
      ])).toList(),
    );
  }

  Widget _statCol(String label, String value, Color color) => Column(children: [
    Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
    const SizedBox(height: 2),
    Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
  ]);
}
