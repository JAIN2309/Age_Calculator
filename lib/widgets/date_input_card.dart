import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class DateInputCard extends StatelessWidget {
  final String title;
  final DateTime? selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final VoidCallback onTap;
  final IconData icon;
  final Color accentColor;

  const DateInputCard({
    super.key,
    required this.title,
    required this.selectedDate,
    required this.firstDate,
    required this.lastDate,
    required this.onTap,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final hasDate = selectedDate != null;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: hasDate ? accentColor : AppTheme.divider,
            width: hasDate ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: hasDate
                  ? accentColor.withValues(alpha: 0.12)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: accentColor, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    hasDate
                        ? DateFormat('MMMM d, yyyy').format(selectedDate!)
                        : 'Tap to select date',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: hasDate ? AppTheme.textDark : AppTheme.textMuted,
                    ),
                  ),
                  if (hasDate) ...[
                    const SizedBox(height: 2),
                    Text(
                      DateFormat('EEEE').format(selectedDate!),
                      style: TextStyle(
                        fontSize: 12,
                        color: accentColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.calendar_month_rounded,
              color: accentColor,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
