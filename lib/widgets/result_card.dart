import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ResultCard extends StatelessWidget {
  final String title;
  final List<ResultRow> rows;
  final IconData icon;
  final Color? iconColor;

  const ResultCard({
    super.key,
    required this.title,
    required this.rows,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: (iconColor ?? AppTheme.primary).withValues(alpha: 0.08),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Icon(icon, color: iconColor ?? AppTheme.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: iconColor ?? AppTheme.primary,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: rows.asMap().entries.map((e) {
                final isLast = e.key == rows.length - 1;
                return Column(
                  children: [
                    _ResultRowWidget(row: e.value),
                    if (!isLast)
                      const Divider(height: 1, color: AppTheme.divider),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ResultRow {
  final String label;
  final String value;
  final bool isBold;

  const ResultRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });
}

class _ResultRowWidget extends StatelessWidget {
  final ResultRow row;

  const _ResultRowWidget({required this.row});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            row.label,
            style: TextStyle(
              fontSize: 14,
              color: row.isBold ? AppTheme.textDark : AppTheme.textMuted,
              fontWeight: row.isBold ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          Text(
            row.value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: row.isBold ? FontWeight.w800 : FontWeight.w600,
              color: row.isBold ? AppTheme.primary : AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
