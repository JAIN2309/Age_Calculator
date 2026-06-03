import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class CalendarScreen extends StatefulWidget {
  final DateTime? birthDate;
  final DateTime toDate;

  const CalendarScreen({
    super.key,
    required this.birthDate,
    required this.toDate,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DateTime _viewingMonth;
  bool _showingBirth = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _viewingMonth = DateTime(
      (widget.birthDate ?? widget.toDate).year,
      (widget.birthDate ?? widget.toDate).month,
    );
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _showingBirth = _tabController.index == 0;
          final target = _showingBirth ? widget.birthDate : widget.toDate;
          if (target != null) {
            _viewingMonth = DateTime(target.year, target.month);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _prevMonth() => setState(() {
        _viewingMonth =
            DateTime(_viewingMonth.year, _viewingMonth.month - 1);
      });

  void _nextMonth() => setState(() {
        _viewingMonth =
            DateTime(_viewingMonth.year, _viewingMonth.month + 1);
      });

  @override
  Widget build(BuildContext context) {
    final highlightDate =
        _showingBirth ? widget.birthDate : widget.toDate;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: _showingBirth
                  ? AppTheme.headerGradient
                  : AppTheme.resultGradient,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                _buildTabBar(),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 12),
                        _buildSelectedDateChip(highlightDate),
                        const SizedBox(height: 12),
                        _buildFullCalendar(highlightDate),
                        const SizedBox(height: 16),
                        _buildLegend(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_rounded,
                color: Colors.white, size: 20),
          ),
          const Expanded(
            child: Text(
              'Calendar View',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 6,
                offset: const Offset(0, 2))
          ],
        ),
        labelColor: AppTheme.primary,
        unselectedLabelColor: Colors.white,
        labelStyle:
            const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        dividerColor: Colors.transparent,
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cake_rounded, size: 15),
                const SizedBox(width: 6),
                Text(widget.birthDate != null
                    ? DateFormat('MMM d, yyyy').format(widget.birthDate!)
                    : 'Birth Date'),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.today_rounded, size: 15),
                const SizedBox(width: 6),
                Text(DateFormat('MMM d, yyyy').format(widget.toDate)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedDateChip(DateTime? date) {
    if (date == null) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, 3))
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.event_rounded, color: AppTheme.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _showingBirth ? 'Date of Birth' : 'Age Calculated At',
                  style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textMuted,
                      fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('EEEE, MMMM d, yyyy').format(date),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textDark),
                ),
              ],
            ),
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.highlightYellow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${date.day}',
              style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullCalendar(DateTime? highlight) {
    final firstDay = DateTime(_viewingMonth.year, _viewingMonth.month, 1);
    final daysInMonth =
        DateTime(_viewingMonth.year, _viewingMonth.month + 1, 0).day;
    final startWeekday = firstDay.weekday % 7;

    const weekdays = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];

    final isHighlightMonth = highlight != null &&
        highlight.year == _viewingMonth.year &&
        highlight.month == _viewingMonth.month;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          // Month nav header
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: _showingBirth
                  ? AppTheme.headerGradient
                  : AppTheme.resultGradient,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _prevMonth,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.chevron_left_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
                Expanded(
                  child: Text(
                    '${months[_viewingMonth.month - 1]} ${_viewingMonth.year}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _nextMonth,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.chevron_right_rounded,
                        color: Colors.white, size: 20),
                  ),
                ),
              ],
            ),
          ),
          // Weekday headers
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              children: weekdays
                  .map((d) => Expanded(
                        child: Center(
                          child: Text(
                            d,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const Divider(height: 1, color: AppTheme.divider),
          // Days grid
          Padding(
            padding: const EdgeInsets.all(8),
            child: _buildDaysGrid(
                startWeekday, daysInMonth, isHighlightMonth, highlight),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildDaysGrid(
      int startWeekday, int daysInMonth, bool isHighlightMonth, DateTime? highlight) {
    final cells = <Widget>[];

    for (int i = 0; i < startWeekday; i++) {
      cells.add(const SizedBox());
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final isSelected =
          isHighlightMonth && highlight != null && day == highlight.day;
      cells.add(_LargeCalendarCell(day: day, isSelected: isSelected));
    }

    final rows = <Widget>[];
    for (int i = 0; i < cells.length; i += 7) {
      final end = (i + 7 > cells.length) ? cells.length : i + 7;
      final rowCells = List<Widget>.from(cells.sublist(i, end));
      while (rowCells.length < 7) {
        rowCells.add(const SizedBox());
      }
      rows.add(
        Row(
          children: rowCells.map((c) => Expanded(child: c)).toList(),
        ),
      );
    }

    return Column(children: rows);
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: AppTheme.highlightYellow,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.orange, width: 1.5),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Selected Date',
            style: TextStyle(
                fontSize: 13,
                color: AppTheme.textMuted,
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _LargeCalendarCell extends StatelessWidget {
  final int day;
  final bool isSelected;

  const _LargeCalendarCell({required this.day, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(2),
      height: 40,
      decoration: isSelected
          ? BoxDecoration(
              color: AppTheme.highlightYellow,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.orange.shade600, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.35),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            )
          : null,
      child: Center(
        child: Text(
          '$day',
          style: TextStyle(
            fontSize: 14,
            fontWeight: isSelected ? FontWeight.w900 : FontWeight.w400,
            color: isSelected ? Colors.black87 : AppTheme.textDark,
          ),
        ),
      ),
    );
  }
}
