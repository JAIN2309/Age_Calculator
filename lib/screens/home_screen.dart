import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../utils/age_calculator.dart';
import '../widgets/date_input_card.dart';
import 'result_screen.dart';
import 'calendar_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  DateTime? _birthDate;
  DateTime _toDate = DateTime.now();
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  bool get _canCalculate =>
      _birthDate != null && !_toDate.isBefore(_birthDate!);

  void _calculate() {
    final result = AgeCalculatorUtil.calculate(_birthDate!, _toDate);
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (ctx, anim, sec) => ResultScreen(result: result),
        transitionsBuilder: (ctx, anim, sec, child) => FadeTransition(
          opacity: anim,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.04, 0),
              end: Offset.zero,
            ).animate(anim),
            child: child,
          ),
        ),
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
  }

  void _openCalendar() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CalendarScreen(
          birthDate: _birthDate,
          toDate: _toDate,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gradient header background
          Container(
            height: 260,
            decoration: const BoxDecoration(
              gradient: AppTheme.headerGradient,
            ),
          ),
          SafeArea(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildHeader()),
                    SliverToBoxAdapter(child: _buildInputSection()),
                    SliverToBoxAdapter(child: _buildActionButtons()),
                    SliverToBoxAdapter(child: _buildTipsCard()),
                    const SliverToBoxAdapter(child: SizedBox(height: 40)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Age Calculator',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Find your exact age instantly',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white70,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: _openCalendar,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.white.withValues(alpha: 0.3), width: 1),
                  ),
                  child: const Icon(
                    Icons.calendar_view_month_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildInputSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Row(
              children: [
                const Icon(Icons.tune_rounded,
                    color: AppTheme.primary, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Select Dates',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primary.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
          DateInputCard(
            title: 'Date of Birth',
            selectedDate: _birthDate,
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
            onDateChanged: (date) => setState(() => _birthDate = date),
            icon: Icons.cake_rounded,
            accentColor: AppTheme.primary,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.arrow_downward_rounded,
                        color: AppTheme.accent, size: 16),
                  ),
                ),
                const Expanded(child: Divider()),
              ],
            ),
          ),
          DateInputCard(
            title: 'Calculate Age At',
            selectedDate: _toDate,
            firstDate: DateTime(1900),
            lastDate: DateTime(DateTime.now().year + 1),
            onDateChanged: (date) => setState(() {
              if (date != null) _toDate = date;
            }),
            icon: Icons.today_rounded,
            accentColor: const Color(0xFF00897B),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: _canCalculate ? _calculate : null,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    _canCalculate ? AppTheme.primary : AppTheme.divider,
                foregroundColor: Colors.white,
                elevation: _canCalculate ? 4 : 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.calculate_rounded, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    _canCalculate
                        ? 'Calculate Age'
                        : 'Select Birth Date First',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _canCalculate ? Colors.white : AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          if (_birthDate != null)
            TextButton.icon(
              onPressed: () => setState(() {
                _birthDate = null;
                _toDate = DateTime.now();
              }),
              icon: const Icon(Icons.refresh_rounded, size: 16),
              label: const Text('Reset'),
              style: TextButton.styleFrom(foregroundColor: AppTheme.textMuted),
            ),
        ],
      ),
    );
  }

  Widget _buildTipsCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accent.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border:
            Border.all(color: AppTheme.accent.withValues(alpha: 0.2), width: 1),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded,
                  color: AppTheme.accent, size: 16),
              SizedBox(width: 6),
              Text(
                'What you\'ll get',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          _TipItem(text: 'Exact age: years, months & days'),
          _TipItem(text: 'Total months, weeks, days, hours'),
          _TipItem(text: 'Total minutes and seconds'),
          _TipItem(text: 'Next birthday countdown'),
          _TipItem(text: 'Visual calendar for both dates'),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  final String text;
  const _TipItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded,
              color: AppTheme.resultGreenLight, size: 14),
          const SizedBox(width: 6),
          Text(text,
              style:
                  const TextStyle(fontSize: 13, color: AppTheme.textMuted)),
        ],
      ),
    );
  }
}
