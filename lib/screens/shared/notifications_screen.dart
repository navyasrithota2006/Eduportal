import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';
import '../../utils/mock_data.dart';

class NotificationsScreen extends StatefulWidget {
  final String role;
  const NotificationsScreen({super.key, required this.role});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<_Notif> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = _buildNotifications();
  }

  List<_Notif> _buildNotifications() {
    final base = MockData.alerts.map((a) => _Notif(
      title: a['target'] == 'All' ? '📢 School-wide Alert'
           : a['target'] == 'Teachers' ? '👩‍🏫 Teacher Alert' : '🎓 Student Alert',
      body: a['message'] as String,
      time: a['time'] as String,
      isRead: false,
      type: a['icon'] == 'meeting' ? NotifType.meeting
          : a['icon'] == 'exam'    ? NotifType.exam
          : a['icon'] == 'sports'  ? NotifType.event : NotifType.general,
    )).toList();

    if (widget.role == 'student') {
      base.insertAll(0, [
        _Notif(title: '📝 Assignment Due',
          body: 'Mathematics assignment due on April 12. Submit before 5 PM.',
          time: '2026-04-09 08:00', isRead: true, type: NotifType.exam),
        _Notif(title: '📊 Results Available',
          body: 'Your Mid-Term exam results have been published.',
          time: '2026-04-08 14:00', isRead: true, type: NotifType.exam),
      ]);
    } else if (widget.role == 'teacher') {
      base.insertAll(0, [
        _Notif(title: '✅ Leave Approved',
          body: 'Your leave request for April 10–11 has been approved.',
          time: '2026-04-09 10:30', isRead: false, type: NotifType.general),
        _Notif(title: '📋 Attendance Reminder',
          body: 'Please mark attendance for Class 10-A by 9:15 AM.',
          time: '2026-04-09 08:45', isRead: true, type: NotifType.general),
      ]);
    } else {
      base.insertAll(0, [
        _Notif(title: '⚠️ Leave Request',
          body: 'Dr. Priya Nair submitted a leave request for April 10–11.',
          time: '2026-04-09 09:00', isRead: false, type: NotifType.general),
        _Notif(title: '📈 Attendance Report',
          body: "Today's attendance: Students 88.9% | Staff 89.7%.",
          time: '2026-04-09 09:30', isRead: false, type: NotifType.general),
      ]);
    }
    return base;
  }

  Color get _roleColor {
    switch (widget.role) {
      case 'teacher':   return AppTheme.teacherColor;
      case 'principal': return AppTheme.principalColor;
      default:          return AppTheme.studentColor;
    }
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _roleColor,
        title: const Text('Notifications'),
        actions: [
          TextButton(
            onPressed: () => setState(() { for (var n in _notifications) n.isRead = true; }),
            child: const Text('Mark all read', style: TextStyle(color: Colors.white, fontSize: 13)),
          ),
        ],
      ),
      body: Column(children: [
        if (_unreadCount > 0) Container(
          width: double.infinity,
          color: _roleColor.withOpacity(0.08),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Row(children: [
            Icon(Icons.notifications_active, color: _roleColor, size: 18),
            const SizedBox(width: 8),
            Text('$_unreadCount unread notification${_unreadCount > 1 ? "s" : ""}',
              style: TextStyle(color: _roleColor, fontWeight: FontWeight.w600, fontSize: 13)),
          ]),
        ),
        Expanded(
          child: _notifications.isEmpty
            ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.notifications_none, size: 72, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                const Text('No notifications', style: TextStyle(color: AppTheme.textSecondary)),
              ]))
            : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: _notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: 4),
                itemBuilder: (_, i) {
                  final n = _notifications[i];
                  return Dismissible(
                    key: ValueKey('$i${n.title}'),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      decoration: BoxDecoration(color: AppTheme.error, borderRadius: BorderRadius.circular(16)),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) => setState(() => _notifications.removeAt(i)),
                    child: Card(
                      margin: EdgeInsets.zero,
                      color: n.isRead ? null : _roleColor.withOpacity(0.04),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(color: n.isRead ? Colors.transparent : _roleColor.withOpacity(0.2)),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => setState(() => n.isRead = true),
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _notifColor(n.type).withOpacity(0.12),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(_notifIcon(n.type), color: _notifColor(n.type), size: 20),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Expanded(child: Text(n.title,
                                    style: TextStyle(fontWeight: n.isRead ? FontWeight.w600 : FontWeight.bold, fontSize: 14))),
                                  if (!n.isRead) Container(
                                    width: 8, height: 8,
                                    decoration: BoxDecoration(color: _roleColor, shape: BoxShape.circle),
                                  ),
                                ]),
                                const SizedBox(height: 4),
                                Text(n.body, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
                                  maxLines: 2, overflow: TextOverflow.ellipsis),
                                const SizedBox(height: 6),
                                Text(n.time, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                              ],
                            )),
                          ]),
                        ),
                      ),
                    ),
                  );
                },
              ),
        ),
      ]),
    );
  }

  IconData _notifIcon(NotifType t) {
    switch (t) {
      case NotifType.meeting: return Icons.groups;
      case NotifType.exam:    return Icons.edit_note;
      case NotifType.event:   return Icons.event;
      default:                return Icons.notifications;
    }
  }

  Color _notifColor(NotifType t) {
    switch (t) {
      case NotifType.meeting: return AppTheme.principalColor;
      case NotifType.exam:    return AppTheme.studentColor;
      case NotifType.event:   return Colors.orange;
      default:                return AppTheme.teacherColor;
    }
  }
}

enum NotifType { meeting, exam, event, general }

class _Notif {
  final String title;
  final String body;
  final String time;
  bool isRead;
  final NotifType type;
  _Notif({required this.title, required this.body, required this.time,
          required this.isRead, required this.type});
}
