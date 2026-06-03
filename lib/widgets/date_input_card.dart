import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';

class DateInputCard extends StatefulWidget {
  final String title;
  final DateTime? selectedDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final Function(DateTime?) onDateChanged;
  final IconData icon;
  final Color accentColor;

  const DateInputCard({
    super.key,
    required this.title,
    required this.selectedDate,
    required this.firstDate,
    required this.lastDate,
    required this.onDateChanged,
    required this.icon,
    required this.accentColor,
  });

  @override
  State<DateInputCard> createState() => _DateInputCardState();
}

class _DateInputCardState extends State<DateInputCard> {
  late final TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  String? _errorText;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.selectedDate != null
          ? DateFormat('dd/MM/yyyy').format(widget.selectedDate!)
          : '',
    );
    _focusNode.addListener(() {
      setState(() => _hasFocus = _focusNode.hasFocus);
    });
  }

  @override
  void didUpdateWidget(DateInputCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Sync text when parent resets date to null
    if (widget.selectedDate == null && oldWidget.selectedDate != null) {
      _controller.clear();
      setState(() => _errorText = null);
    }
    // Sync text when picker updates date from outside
    if (widget.selectedDate != null &&
        widget.selectedDate != oldWidget.selectedDate) {
      final formatted = DateFormat('dd/MM/yyyy').format(widget.selectedDate!);
      if (_controller.text != formatted) {
        _controller.text = formatted;
        _controller.selection =
            TextSelection.collapsed(offset: formatted.length);
        setState(() => _errorText = null);
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged(String raw) {
    // Strip non-digits, re-insert slashes at positions 2 and 4
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    final buf = StringBuffer();
    for (int i = 0; i < digits.length && i < 8; i++) {
      if (i == 2 || i == 4) buf.write('/');
      buf.write(digits[i]);
    }
    final formatted = buf.toString();

    if (formatted != raw) {
      _controller.value = TextEditingValue(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    if (digits.length < 8) {
      // Incomplete — clear error and notify null
      if (_errorText != null) setState(() => _errorText = null);
      if (digits.isEmpty) widget.onDateChanged(null);
      return;
    }

    // Full 8 digits — try to parse
    try {
      final date = DateFormat('dd/MM/yyyy').parseStrict(formatted);
      final afterFirst =
          date.isAfter(widget.firstDate.subtract(const Duration(days: 1)));
      final beforeLast =
          date.isBefore(widget.lastDate.add(const Duration(days: 1)));
      if (afterFirst && beforeLast) {
        setState(() => _errorText = null);
        widget.onDateChanged(date);
      } else {
        setState(() => _errorText = 'Date out of allowed range');
        widget.onDateChanged(null);
      }
    } catch (_) {
      setState(() => _errorText = 'Invalid date — use DD/MM/YYYY');
      widget.onDateChanged(null);
    }
  }

  Future<void> _openPicker() async {
    _focusNode.unfocus();
    final now = DateTime.now();
    final initial = widget.selectedDate ??
        (widget.lastDate.isBefore(now)
            ? DateTime(now.year - 25, now.month, now.day)
            : widget.lastDate);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(widget.firstDate)
          ? widget.firstDate
          : initial.isAfter(widget.lastDate)
              ? widget.lastDate
              : initial,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: AppTheme.primary),
        ),
        child: child!,
      ),
    );

    if (picked == null) return;
    final formatted = DateFormat('dd/MM/yyyy').format(picked);
    _controller.text = formatted;
    setState(() => _errorText = null);
    widget.onDateChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    final hasDate = widget.selectedDate != null;
    final hasError = _errorText != null;
    final borderColor = hasError
        ? Colors.red.shade400
        : (_hasFocus || hasDate)
            ? widget.accentColor
            : AppTheme.divider;
    final borderWidth = (_hasFocus || hasDate || hasError) ? 1.5 : 1.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      decoration: BoxDecoration(
        color: AppTheme.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: hasError
                ? Colors.red.withValues(alpha: 0.08)
                : hasDate
                    ? widget.accentColor.withValues(alpha: 0.1)
                    : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Left icon
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: widget.accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(widget.icon, color: widget.accentColor, size: 20),
              ),
              const SizedBox(width: 12),
              // Label + text field
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textMuted,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      onChanged: _onTextChanged,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[\d/]')),
                        LengthLimitingTextInputFormatter(10),
                      ],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textDark,
                      ),
                      decoration: InputDecoration(
                        hintText: 'DD/MM/YYYY',
                        hintStyle: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: AppTheme.textMuted.withValues(alpha: 0.6),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        isDense: true,
                      ),
                    ),
                    if (hasDate && !_hasFocus) ...[
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('EEEE, MMMM d yyyy')
                            .format(widget.selectedDate!),
                        style: TextStyle(
                          fontSize: 11,
                          color: widget.accentColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Calendar picker button
              GestureDetector(
                onTap: _openPicker,
                child: Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: widget.accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: widget.accentColor.withValues(alpha: 0.25),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.calendar_month_rounded,
                    color: widget.accentColor,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
          // Error message
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 6, left: 54),
              child: Row(
                children: [
                  Icon(Icons.error_outline_rounded,
                      size: 13, color: Colors.red.shade400),
                  const SizedBox(width: 4),
                  Text(
                    _errorText!,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.red.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          // Format hint when focused and empty
          if (_hasFocus && _controller.text.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 54),
              child: Text(
                'Type day, month, year  e.g. 03/06/2004',
                style: TextStyle(
                  fontSize: 11,
                  color: widget.accentColor.withValues(alpha: 0.7),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
