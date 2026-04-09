import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

// ─── Info Card ────────────────────────────────────────────────────────────────
class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color? color;

  const InfoCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.primary;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: c.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: c, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                  const SizedBox(height: 4),
                  Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? trailing;

  const SectionHeader({super.key, required this.title, this.trailing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textPrimary)),
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

// ─── Status Chip ──────────────────────────────────────────────────────────────
class StatusChip extends StatelessWidget {
  final String label;

  const StatusChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    Color bg, fg;
    switch (label.toLowerCase()) {
      case 'approved':
        bg = AppTheme.success.withOpacity(0.15); fg = AppTheme.success; break;
      case 'rejected':
        bg = AppTheme.error.withOpacity(0.15); fg = AppTheme.error; break;
      case 'credited':
        bg = AppTheme.success.withOpacity(0.15); fg = AppTheme.success; break;
      default:
        bg = AppTheme.warning.withOpacity(0.15); fg = AppTheme.warning;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

// ─── Avatar Circle ────────────────────────────────────────────────────────────
class AvatarCircle extends StatelessWidget {
  final String name;
  final double radius;
  final Color? color;

  const AvatarCircle({super.key, required this.name, this.radius = 40, this.color});

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.primary;
    final initials = name.trim().split(' ').take(2).map((w) => w.isNotEmpty ? w[0] : '').join().toUpperCase();
    return CircleAvatar(
      radius: radius,
      backgroundColor: c.withOpacity(0.15),
      child: Text(
        initials,
        style: TextStyle(fontSize: radius * 0.55, fontWeight: FontWeight.bold, color: c),
      ),
    );
  }
}

// ─── Grade Badge ──────────────────────────────────────────────────────────────
class GradeBadge extends StatelessWidget {
  final String grade;

  const GradeBadge({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    Color bg;
    switch (grade) {
      case 'A+': bg = const Color(0xFF1565C0); break;
      case 'A':  bg = const Color(0xFF2E7D32); break;
      case 'B+': bg = const Color(0xFF00838F); break;
      case 'B':  bg = const Color(0xFF6A1B9A); break;
      default:   bg = Colors.orange;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(grade, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }
}

// ─── Empty State ──────────────────────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;

  const EmptyState({super.key, required this.message, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 72, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(message, style: TextStyle(fontSize: 15, color: Colors.grey[500])),
        ],
      ),
    );
  }
}
