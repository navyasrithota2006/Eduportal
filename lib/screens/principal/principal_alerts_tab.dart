import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../utils/mock_data.dart';

class PrincipalAlertsTab extends StatefulWidget {
  const PrincipalAlertsTab({super.key});

  @override
  State<PrincipalAlertsTab> createState() => _PrincipalAlertsTabState();
}

class _PrincipalAlertsTabState extends State<PrincipalAlertsTab> {
  final _msgCtrl = TextEditingController();
  String _target = 'All';
  bool _showCompose = false;

  static const _targets = ['All', 'Teachers', 'Students'];

  @override
  void dispose() { _msgCtrl.dispose(); super.dispose(); }

  void _sendAlert() {
    if (_msgCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a message'), backgroundColor: AppTheme.error),
      );
      return;
    }
    final now = DateTime.now();
    setState(() {
      MockData.alerts.insert(0, {
        'message': _msgCtrl.text.trim(),
        'target': _target,
        'time': '${now.year}-${now.month.toString().padLeft(2,'0')}-${now.day.toString().padLeft(2,'0')} ${now.hour.toString().padLeft(2,'0')}:${now.minute.toString().padLeft(2,'0')}',
        'icon': 'meeting',
      });
      _msgCtrl.clear();
      _showCompose = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alert broadcast successfully!'), backgroundColor: AppTheme.success),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── Header ───────────────────────────────────────────
        Container(
          color: AppTheme.principalColor,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
          child: Column(
            children: [
              Row(children: [
                const Icon(Icons.campaign, color: Colors.white, size: 22),
                const SizedBox(width: 10),
                const Text('Broadcast Alerts', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white)),
                const Spacer(),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppTheme.principalColor,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  icon: Icon(_showCompose ? Icons.close : Icons.add_comment, size: 16),
                  label: Text(_showCompose ? 'Cancel' : 'New Alert', style: const TextStyle(fontSize: 12)),
                  onPressed: () => setState(() => _showCompose = !_showCompose),
                ),
              ]),
              if (_showCompose) ...[
                const SizedBox(height: 14),
                TextField(
                  controller: _msgCtrl,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Type your message here...',
                    hintStyle: const TextStyle(color: Colors.white60),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.15),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    prefixIcon: const Icon(Icons.message, color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 10),
                Row(children: [
                  const Text('Broadcast to:', style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(width: 10),
                  ..._targets.map((t) => Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: GestureDetector(
                      onTap: () => setState(() => _target = t),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _target == t ? Colors.white : Colors.white.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(t, style: TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w600,
                          color: _target == t ? AppTheme.principalColor : Colors.white,
                        )),
                      ),
                    ),
                  )),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.principalColor,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                    onPressed: _sendAlert,
                    child: const Text('Send', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ]),
              ],
            ],
          ),
        ),

        // ── Alert List ───────────────────────────────────────
        Expanded(
          child: MockData.alerts.isEmpty
            ? const Center(child: Text('No alerts yet', style: TextStyle(color: AppTheme.textSecondary)))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: MockData.alerts.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final a = MockData.alerts[i];
                  final target = a['target'] as String;
                  Color targetColor;
                  switch (target) {
                    case 'Teachers': targetColor = AppTheme.teacherColor; break;
                    case 'Students': targetColor = AppTheme.studentColor; break;
                    default:         targetColor = AppTheme.principalColor;
                  }
                  return Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppTheme.principalColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              a['icon'] == 'meeting' ? Icons.groups :
                              a['icon'] == 'sports'  ? Icons.sports  :
                              a['icon'] == 'exam'    ? Icons.edit_note : Icons.campaign,
                              color: AppTheme.principalColor, size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(a['message'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                Row(children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: targetColor.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(target, style: TextStyle(fontSize: 11, color: targetColor, fontWeight: FontWeight.w600)),
                                  ),
                                  const SizedBox(width: 8),
                                  Icon(Icons.access_time, size: 12, color: Colors.grey.shade400),
                                  const SizedBox(width: 3),
                                  Text((a['time'] as String).substring(0, 10),
                                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                                ]),
                              ],
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: Icon(Icons.more_vert, color: Colors.grey.shade400, size: 18),
                            itemBuilder: (_) => [
                              const PopupMenuItem(value: 'delete', child: ListTile(
                                leading: Icon(Icons.delete, color: Colors.red),
                                title: Text('Delete', style: TextStyle(color: Colors.red)),
                                dense: true,
                              )),
                            ],
                            onSelected: (v) {
                              if (v == 'delete') setState(() => MockData.alerts.removeAt(i));
                            },
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
}
