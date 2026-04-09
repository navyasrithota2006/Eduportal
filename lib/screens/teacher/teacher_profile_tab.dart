import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/auth_provider.dart';
import '../../utils/app_theme.dart';
import '../../utils/mock_data.dart';
import '../../widgets/common_widgets.dart';

class TeacherProfileTab extends StatefulWidget {
  const TeacherProfileTab({super.key});

  @override
  State<TeacherProfileTab> createState() => _TeacherProfileTabState();
}

class _TeacherProfileTabState extends State<TeacherProfileTab> {
  bool _showLeaveForm = false;
  final _reasonCtrl = TextEditingController();
  DateTime? _fromDate;
  DateTime? _toDate;

  @override
  void dispose() { _reasonCtrl.dispose(); super.dispose(); }

  void _submitLeave() {
    if (_reasonCtrl.text.isEmpty || _fromDate == null || _toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all leave details'), backgroundColor: AppTheme.error),
      );
      return;
    }
    final user = context.read<AuthProvider>().currentUser!;
    MockData.leaveRequests.add({
      'teacher': user.name,
      'id': user.id,
      'reason': _reasonCtrl.text,
      'from': '${_fromDate!.year}-${_fromDate!.month.toString().padLeft(2, '0')}-${_fromDate!.day.toString().padLeft(2, '0')}',
      'to': '${_toDate!.year}-${_toDate!.month.toString().padLeft(2, '0')}-${_toDate!.day.toString().padLeft(2, '0')}',
      'status': 'Pending',
    });
    setState(() {
      _showLeaveForm = false;
      _reasonCtrl.clear();
      _fromDate = null;
      _toDate = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Leave request submitted!'), backgroundColor: AppTheme.success),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().currentUser!;
    final extra = user.extraData;
    final myLeaves = MockData.leaveRequests.where((l) => l['id'] == user.id).toList();

    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Profile Header ───────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 28),
            decoration: const BoxDecoration(
              color: AppTheme.teacherColor,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Column(
              children: [
                AvatarCircle(name: user.name, radius: 45, color: Colors.white),
                const SizedBox(height: 14),
                Text(user.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                const SizedBox(height: 4),
                Text(user.email, style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
                const SizedBox(height: 10),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  _chipW(extra['subject'] ?? 'Teacher', Icons.book),
                  const SizedBox(width: 8),
                  _chipW(user.id, Icons.badge),
                ]),
              ],
            ),
          ),

          // ── Edit Button ──────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.edit_outlined, color: AppTheme.teacherColor),
                label: const Text('Edit Profile', style: TextStyle(color: AppTheme.teacherColor)),
                style: OutlinedButton.styleFrom(side: const BorderSide(color: AppTheme.teacherColor)),
                onPressed: () {},
              ),
            ),
          ),

          // ── Personal Info ────────────────────────────────────
          const SectionHeader(title: 'Personal Information'),
          _InfoSection(color: AppTheme.teacherColor, items: [
            _Row(Icons.badge, 'Teacher ID', user.id),
            _Row(Icons.email_outlined, 'Email', user.email),
            _Row(Icons.phone_outlined, 'Phone', extra['phone'] ?? '9812345678'),
            _Row(Icons.location_on_outlined, 'Address', extra['address'] ?? '45, Lake View, Pune'),
            _Row(Icons.book, 'Subject', extra['subject'] ?? 'Mathematics'),
          ]),

          // ── Salary Status ────────────────────────────────────
          const SectionHeader(title: 'Salary Status'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.account_balance_wallet, color: AppTheme.success),
                    ),
                    const SizedBox(width: 16),
                    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('April 2026 Salary', style: TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                      Text(extra['salary_amount'] ?? '₹55,000',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ]),
                    const Spacer(),
                    StatusChip(label: extra['salary_status'] ?? 'Credited'),
                  ],
                ),
              ),
            ),
          ),

          // ── Leave Management ─────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Row(children: [
              const Text('Leave Management', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.teacherColor,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                icon: Icon(_showLeaveForm ? Icons.close : Icons.add, size: 18),
                label: Text(_showLeaveForm ? 'Cancel' : 'Apply Leave', style: const TextStyle(fontSize: 13)),
                onPressed: () => setState(() => _showLeaveForm = !_showLeaveForm),
              ),
            ]),
          ),

          // ── Leave Form ───────────────────────────────────────
          if (_showLeaveForm) Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Apply for Leave', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 14),
                    TextField(
                      controller: _reasonCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(labelText: 'Reason', prefixIcon: Icon(Icons.note, color: AppTheme.teacherColor)),
                    ),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(child: OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_today, size: 16),
                        label: Text(_fromDate == null ? 'From Date' : '${_fromDate!.day}/${_fromDate!.month}/${_fromDate!.year}'),
                        onPressed: () async {
                          final d = await showDatePicker(context: context,
                            initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2027));
                          if (d != null) setState(() => _fromDate = d);
                        },
                      )),
                      const SizedBox(width: 10),
                      Expanded(child: OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_today, size: 16),
                        label: Text(_toDate == null ? 'To Date' : '${_toDate!.day}/${_toDate!.month}/${_toDate!.year}'),
                        onPressed: () async {
                          final d = await showDatePicker(context: context,
                            initialDate: _fromDate ?? DateTime.now(), firstDate: _fromDate ?? DateTime.now(), lastDate: DateTime(2027));
                          if (d != null) setState(() => _toDate = d);
                        },
                      )),
                    ]),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppTheme.teacherColor),
                        onPressed: _submitLeave,
                        child: const Text('Submit Leave Request'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Leave History ────────────────────────────────────
          if (myLeaves.isNotEmpty) ...[
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text('Leave History', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textSecondary)),
            ),
            ...myLeaves.map((l) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
              child: Card(
                margin: EdgeInsets.zero,
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppTheme.teacherColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: const Icon(Icons.event_note, color: AppTheme.teacherColor, size: 20),
                  ),
                  title: Text(l['reason'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                  subtitle: Text('${l['from']} → ${l['to']}', style: const TextStyle(fontSize: 12)),
                  trailing: StatusChip(label: l['status'] as String),
                ),
              ),
            )),
          ],

          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.error),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                onPressed: () {
                  context.read<AuthProvider>().logout();
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _chipW(String label, IconData icon) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(16)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      Icon(icon, size: 14, color: Colors.white),
      const SizedBox(width: 5),
      Text(label, style: const TextStyle(fontSize: 12, color: Colors.white)),
    ]),
  );
}

class _InfoSection extends StatelessWidget {
  final Color color;
  final List<_Row> items;
  const _InfoSection({required this.color, required this.items});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(children: items.map((r) => Column(children: [
        ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(r.icon, color: color, size: 20),
          ),
          title: Text(r.label, style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
          subtitle: Text(r.value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
        ),
        if (r != items.last) const Divider(height: 1, indent: 60),
      ])).toList()),
    );
  }
}

class _Row {
  final IconData icon;
  final String label;
  final String value;
  const _Row(this.icon, this.label, this.value);
}
