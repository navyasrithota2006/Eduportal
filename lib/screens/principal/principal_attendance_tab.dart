import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../utils/mock_data.dart';
import '../../widgets/common_widgets.dart';

class PrincipalAttendanceTab extends StatefulWidget {
  const PrincipalAttendanceTab({super.key});

  @override
  State<PrincipalAttendanceTab> createState() => _PrincipalAttendanceTabState();
}

class _PrincipalAttendanceTabState extends State<PrincipalAttendanceTab> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() { _tabCtrl.dispose(); super.dispose(); }

  List<Map<String, dynamic>> _leaves(String status) =>
    MockData.leaveRequests.where((l) => l['status'] == status).toList();

  void _updateStatus(Map<String, dynamic> leave, String newStatus) {
    setState(() => leave['status'] = newStatus);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Leave ${newStatus.toLowerCase()} for ${leave['teacher']}'),
        backgroundColor: newStatus == 'Approved' ? AppTheme.success : AppTheme.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppTheme.principalColor,
          child: TabBar(
            controller: _tabCtrl,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white60,
            indicatorColor: Colors.white,
            tabs: [
              Tab(text: 'Pending (${_leaves('Pending').length})'),
              Tab(text: 'Approved (${_leaves('Approved').length})'),
              Tab(text: 'Rejected (${_leaves('Rejected').length})'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabCtrl,
            children: [
              _LeaveList(leaves: _leaves('Pending'), onAction: _updateStatus, showActions: true),
              _LeaveList(leaves: _leaves('Approved'), onAction: _updateStatus, showActions: false),
              _LeaveList(leaves: _leaves('Rejected'), onAction: _updateStatus, showActions: false),
            ],
          ),
        ),
      ],
    );
  }
}

class _LeaveList extends StatelessWidget {
  final List<Map<String, dynamic>> leaves;
  final Function(Map<String, dynamic>, String) onAction;
  final bool showActions;

  const _LeaveList({required this.leaves, required this.onAction, required this.showActions});

  @override
  Widget build(BuildContext context) {
    if (leaves.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_available, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            const Text('No leave requests', style: TextStyle(color: AppTheme.textSecondary)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: leaves.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (_, i) {
        final l = leaves[i];
        return Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppTheme.principalColor.withOpacity(0.15),
                    child: Text(
                      (l['teacher'] as String).split(' ').map((w) => w[0]).take(2).join(),
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.principalColor),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l['teacher'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text('ID: ${l['id']}', style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary)),
                    ],
                  )),
                  StatusChip(label: l['status'] as String),
                ]),
                const SizedBox(height: 12),
                _detail(Icons.note, 'Reason', l['reason'] as String),
                const SizedBox(height: 6),
                _detail(Icons.date_range, 'Duration', '${l['from']} → ${l['to']}'),
                if (showActions) ...[
                  const SizedBox(height: 14),
                  Row(children: [
                    Expanded(child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(foregroundColor: AppTheme.error, side: const BorderSide(color: AppTheme.error)),
                      icon: const Icon(Icons.close, size: 16),
                      label: const Text('Reject'),
                      onPressed: () => onAction(l, 'Rejected'),
                    )),
                    const SizedBox(width: 10),
                    Expanded(child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(backgroundColor: AppTheme.success),
                      icon: const Icon(Icons.check, size: 16),
                      label: const Text('Approve'),
                      onPressed: () => onAction(l, 'Approved'),
                    )),
                  ]),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _detail(IconData icon, String label, String value) => Row(children: [
    Icon(icon, size: 14, color: AppTheme.textSecondary),
    const SizedBox(width: 6),
    Text('$label: ', style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
    Expanded(child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
  ]);
}
