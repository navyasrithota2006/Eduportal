import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/auth_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/mock_data.dart';
import '../../widgets/common_widgets.dart';

class PrincipalHomeTab extends StatefulWidget {
  const PrincipalHomeTab({super.key});

  @override
  State<PrincipalHomeTab> createState() => _PrincipalHomeTabState();
}

class _PrincipalHomeTabState extends State<PrincipalHomeTab> {
  late Map<String, dynamic> _meal;
  bool _editingMeal = false;
  final _primaryDishCtrl = TextEditingController();
  final _sideDishCtrl    = TextEditingController();
  final _quantityCtrl    = TextEditingController();
  DateTime _mealDate     = DateTime.now();

  @override
  void initState() {
    super.initState();
    _meal = Map<String, dynamic>.from(MockData.principalStats['today_menu']);
    _primaryDishCtrl.text = _meal['primary_dish'] as String;
    _sideDishCtrl.text    = _meal['side_dish'] as String;
    _quantityCtrl.text    = _meal['quantity'] as String;
  }

  @override
  void dispose() {
    _primaryDishCtrl.dispose();
    _sideDishCtrl.dispose();
    _quantityCtrl.dispose();
    super.dispose();
  }

  void _updateMeal() {
    setState(() {
      _meal = {
        'date': '${_mealDate.day} ${_monthName(_mealDate.month)}, ${_mealDate.year}',
        'primary_dish': _primaryDishCtrl.text,
        'side_dish': _sideDishCtrl.text,
        'quantity': _quantityCtrl.text,
      };
      _editingMeal = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Midday meal menu updated!'), backgroundColor: AppTheme.success),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser!;
    final stats = MockData.principalStats;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ───────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
            decoration: const BoxDecoration(
              color: AppTheme.principalColor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  AvatarCircle(name: user.name, radius: 26, color: Colors.white),
                  const SizedBox(width: 14),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome,', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
                      Text(user.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  )),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
                    child: const Text('Principal', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                ]),
                const SizedBox(height: 16),
                Text(
                  'Today is ${_todayFull()}',
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                ),
              ],
            ),
          ),

          // ── Stats Grid ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 1.6,
              children: [
                _StatCard('Students Present',
                  '${stats['students_present']} / ${stats['total_students']}',
                  Icons.school, AppTheme.studentColor,
                  sub: '${((stats['students_present'] / stats['total_students']) * 100).toStringAsFixed(1)}%'),
                _StatCard('Staff Present',
                  '${stats['staff_present']} / ${stats['total_staff']}',
                  Icons.people, AppTheme.teacherColor,
                  sub: '${((stats['staff_present'] / stats['total_staff']) * 100).toStringAsFixed(1)}%'),
                _StatCard('Total Classes', '${stats['classes']}',
                  Icons.class_, AppTheme.principalColor, sub: 'Active'),
                _StatCard('Pending Leaves', '${MockData.leaveRequests.where((l) => l['status'] == 'Pending').length}',
                  Icons.pending_actions, AppTheme.warning, sub: 'Awaiting approval'),
              ],
            ),
          ),

          // ── Midday Meal ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Row(children: [
              const Text("Midday Meal Update", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.principalColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                icon: Icon(_editingMeal ? Icons.close : Icons.edit, size: 16),
                label: Text(_editingMeal ? 'Cancel' : 'Update Menu', style: const TextStyle(fontSize: 12)),
                onPressed: () => setState(() => _editingMeal = !_editingMeal),
              ),
            ]),
          ),

          if (_editingMeal)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(children: [
                    OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_month, size: 16),
                      label: Text('Date: ${_mealDate.day}/${_mealDate.month}/${_mealDate.year}'),
                      onPressed: () async {
                        final d = await showDatePicker(context: context,
                          initialDate: _mealDate, firstDate: DateTime.now(), lastDate: DateTime(2027));
                        if (d != null) setState(() => _mealDate = d);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _primaryDishCtrl,
                      decoration: const InputDecoration(labelText: 'Primary Dish', prefixIcon: Icon(Icons.restaurant)),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _sideDishCtrl,
                      decoration: const InputDecoration(labelText: 'Side Dish', prefixIcon: Icon(Icons.dining)),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _quantityCtrl,
                      decoration: const InputDecoration(labelText: 'Estimated Quantity', prefixIcon: Icon(Icons.scale)),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.principalColor),
                        icon: const Icon(Icons.save),
                        label: const Text('Update Daily Menu'),
                        onPressed: _updateMeal,
                      ),
                    ),
                  ]),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Colors.orange.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                          child: const Icon(Icons.restaurant, color: Colors.orange, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(_meal['date'] as String, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                          const Text("Today's Menu", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                        ]),
                      ]),
                      const Divider(height: 20),
                      _mealRow('Primary Dish', _meal['primary_dish'] as String, Icons.lunch_dining),
                      const SizedBox(height: 8),
                      _mealRow('Side Dish', _meal['side_dish'] as String, Icons.dining),
                      const SizedBox(height: 8),
                      _mealRow('Quantity', _meal['quantity'] as String, Icons.scale),
                    ],
                  ),
                ),
              ),
            ),

          // ── Recent Alerts ────────────────────────────────────
          const SectionHeader(title: 'Recent Alerts'),
          ...MockData.alerts.take(3).map((a) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
            child: Card(
              margin: EdgeInsets.zero,
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.principalColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(a['icon'] == 'meeting' ? Icons.groups : Icons.campaign,
                    color: AppTheme.principalColor, size: 20),
                ),
                title: Text(a['message'] as String, style: const TextStyle(fontSize: 13), maxLines: 2, overflow: TextOverflow.ellipsis),
                subtitle: Text('To: ${a['target']}  •  ${(a['time'] as String).substring(11)}',
                  style: const TextStyle(fontSize: 11)),
              ),
            ),
          )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _mealRow(String label, String value, IconData icon) => Row(children: [
    Icon(icon, size: 16, color: AppTheme.textSecondary),
    const SizedBox(width: 8),
    Text('$label: ', style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
    Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
  ]);

  String _todayFull() {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    const days = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
    final now = DateTime.now();
    return '${days[now.weekday-1]}, ${now.day} ${months[now.month-1]} ${now.year}';
  }

  String _monthName(int m) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    return months[m-1];
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String sub;

  const _StatCard(this.title, this.value, this.icon, this.color, {this.sub = ''});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 3))],
        border: Border.all(color: color.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: color, size: 20),
            const Spacer(),
            if (sub.isNotEmpty) Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
              child: Text(sub, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
            ),
          ]),
          const Spacer(),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text(title, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}
