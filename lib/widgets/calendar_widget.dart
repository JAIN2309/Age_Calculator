import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class MiniCalendarWidget extends StatelessWidget {
  final DateTime selectedDate;
  final String label;
  final bool isHighlightToday;

  const MiniCalendarWidget({
    super.key,
    required this.selectedDate,
    required this.label,
    this.isHighlightToday = false,
  });

  static const List<String> _weekdays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  static const List<String> _months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(selectedDate.year, selectedDate.month, 1);
    final daysInMonth = DateTime(selectedDate.year, selectedDate.month + 1, 0).day;
    final startWeekday = firstDay.weekday % 7; // 0=Sun

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.divider, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader(),
          _buildWeekdayRow(),
          _buildDaysGrid(startWeekday, daysInMonth),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.headerGradient,
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${_months[selectedDate.month - 1]} ${selectedDate.year}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        children: _weekdays.map((d) {
          return Expanded(
            child: Center(
              child: Text(
                d,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDaysGrid(int startWeekday, int daysInMonth) {
    final cells = <Widget>[];

    for (int i = 0; i < startWeekday; i++) {
      cells.add(const SizedBox());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final isSelected = day == selectedDate.day;
      cells.add(_DayCell(day: day, isSelected: isSelected));
    }

    final rows = <Widget>[];
    for (int i = 0; i < cells.length; i += 7) {
      final rowCells = cells.sublist(i, i + 7 > cells.length ? cells.length : i + 7);
      while (rowCells.length < 7) {
        rowCells.add(const SizedBox());
      }
      rows.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
          child: Row(
            children: rowCells.map((c) => Expanded(child: c)).toList(),
          ),
        ),
      );
    }

    return Column(children: rows);
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool isSelected;

  const _DayCell({required this.day, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(1.5),
      height: 26,
      decoration: isSelected
          ? BoxDecoration(
              color: AppTheme.highlightYellow,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.orange, width: 1.5),
            )
          : null,
      child: Center(
        child: Text(
          '$day',
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w400,
            color: isSelected ? Colors.black87 : AppTheme.textDark,
          ),
        ),
      ),
    );
  }
}
