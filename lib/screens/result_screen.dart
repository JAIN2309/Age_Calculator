import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/age_result.dart';
import '../theme/app_theme.dart';
import '../utils/age_calculator.dart';
import '../widgets/result_card.dart';
import '../widgets/calendar_widget.dart';
import 'calendar_screen.dart';

class ResultScreen extends StatelessWidget {
  final AgeResult result;

  const ResultScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(height: 220, decoration: const BoxDecoration(gradient: AppTheme.resultGradient)),
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _buildAppBar(context)),
                SliverToBoxAdapter(child: _buildAgeBanner()),
                SliverToBoxAdapter(child: _buildCalendarRow(context)),
                SliverToBoxAdapter(child: _buildBreakdownCard()),
                SliverToBoxAdapter(child: _buildTotalsCard()),
                SliverToBoxAdapter(child: _buildTimeCard()),
                SliverToBoxAdapter(child: _buildNextBirthdayCard()),
                const SliverToBoxAdapter(child: SizedBox(height: 40)),
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
            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white, size: 20),
          ),
          const Expanded(
            child: Text(
              'Your Age Result',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctx) => CalendarScreen(
                  birthDate: result.birthDate,
                  toDate: result.toDate,
                ),
              ),
            ),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.calendar_view_month_rounded, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAgeBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.cake_rounded, color: AppTheme.resultGreen, size: 20),
              SizedBox(width: 8),
              Text(
                'Age',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.resultGreen,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _BigAgeRow(
            value: '${result.years}',
            unit: result.years == 1 ? 'year' : 'years',
            sub: '${result.months} ${result.months == 1 ? "month" : "months"}  ${result.days} ${result.days == 1 ? "day" : "days"}',
          ),
          const Divider(height: 20, color: AppTheme.divider),
          _AgeOrRow(
              label: 'or',
              value:
                  '${AgeCalculatorUtil.formatNumber(result.totalMonths)} months ${result.remainingDaysAfterMonths} days'),
          _AgeOrRow(
              label: 'or',
              value:
                  '${AgeCalculatorUtil.formatNumber(result.totalWeeks)} weeks ${result.remainingDaysAfterWeeks} days'),
          _AgeOrRow(
              label: 'or',
              value: '${AgeCalculatorUtil.formatNumber(result.totalDays)} days'),
          _AgeOrRow(
              label: 'or',
              value: '${AgeCalculatorUtil.formatNumber(result.totalHours)} hours'),
          _AgeOrRow(
              label: 'or',
              value:
                  '${AgeCalculatorUtil.formatNumber(result.totalMinutes)} minutes'),
          _AgeOrRow(
              label: 'or',
              value:
                  '${AgeCalculatorUtil.formatNumber(result.totalSeconds)} seconds'),
        ],
      ),
    );
  }

  Widget _buildCalendarRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                const Text('Birth Date',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textMuted)),
                const SizedBox(height: 6),
                MiniCalendarWidget(selectedDate: result.birthDate, label: 'Birth'),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                SizedBox(height: 22),
                Icon(Icons.arrow_forward_rounded, color: AppTheme.textMuted, size: 20),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const Text('Age At',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textMuted)),
                const SizedBox(height: 6),
                MiniCalendarWidget(selectedDate: result.toDate, label: 'Today'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownCard() {
    return ResultCard(
      title: 'Age Breakdown',
      icon: Icons.bar_chart_rounded,
      iconColor: AppTheme.primary,
      rows: [
        ResultRow(label: 'Years', value: '${result.years}', isBold: true),
        ResultRow(label: 'Months', value: '${result.months}'),
        ResultRow(label: 'Days', value: '${result.days}'),
        ResultRow(
          label: 'Born on',
          value: DateFormat('EEEE').format(result.birthDate),
        ),
      ],
    );
  }

  Widget _buildTotalsCard() {
    return ResultCard(
      title: 'Total Time Elapsed',
      icon: Icons.access_time_filled_rounded,
      iconColor: const Color(0xFF7B1FA2),
      rows: [
        ResultRow(
          label: 'Total Months',
          value: '${AgeCalculatorUtil.formatNumber(result.totalMonths)} mo  +${result.remainingDaysAfterMonths}d',
          isBold: true,
        ),
        ResultRow(
          label: 'Total Weeks',
          value: '${AgeCalculatorUtil.formatNumber(result.totalWeeks)} wk  +${result.remainingDaysAfterWeeks}d',
        ),
        ResultRow(
          label: 'Total Days',
          value: AgeCalculatorUtil.formatNumber(result.totalDays),
        ),
      ],
    );
  }

  Widget _buildTimeCard() {
    return ResultCard(
      title: 'In Hours / Minutes / Seconds',
      icon: Icons.timer_rounded,
      iconColor: const Color(0xFFE65100),
      rows: [
        ResultRow(
          label: 'Hours',
          value: AgeCalculatorUtil.formatNumber(result.totalHours),
          isBold: true,
        ),
        ResultRow(
          label: 'Minutes',
          value: AgeCalculatorUtil.formatNumber(result.totalMinutes),
        ),
        ResultRow(
          label: 'Seconds',
          value: AgeCalculatorUtil.formatNumber(result.totalSeconds),
        ),
      ],
    );
  }

  Widget _buildNextBirthdayCard() {
    final isToday = result.daysUntilNextBirthday == 0;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: isToday
            ? const LinearGradient(
                colors: [Color(0xFFFDD835), Color(0xFFFBC02D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : LinearGradient(
                colors: [
                  AppTheme.primary.withValues(alpha: 0.08),
                  AppTheme.accent.withValues(alpha: 0.06),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isToday
              ? const Color(0xFFF9A825)
              : AppTheme.accent.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isToday ? Colors.white.withValues(alpha: 0.5) : AppTheme.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isToday ? Icons.celebration_rounded : Icons.cake_rounded,
              color: isToday ? Colors.orange.shade800 : AppTheme.primary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isToday ? '🎂 Happy Birthday!' : 'Next Birthday',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isToday ? Colors.orange.shade900 : AppTheme.primary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  result.nextBirthdayInfo,
                  style: TextStyle(
                    fontSize: 13,
                    color: isToday ? Colors.brown.shade700 : AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BigAgeRow extends StatelessWidget {
  final String value;
  final String unit;
  final String sub;

  const _BigAgeRow({required this.value, required this.unit, required this.sub});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.w900,
                color: AppTheme.resultGreen,
                height: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10, left: 6),
              child: Text(
                unit,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.resultGreen,
                ),
              ),
            ),
          ],
        ),
        Text(
          sub,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppTheme.textMuted,
          ),
        ),
      ],
    );
  }
}

class _AgeOrRow extends StatelessWidget {
  final String label;
  final String value;

  const _AgeOrRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textMuted,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.textDark,
            ),
          ),
        ],
      ),
    );
  }
}
