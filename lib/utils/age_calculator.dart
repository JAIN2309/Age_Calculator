import 'package:intl/intl.dart';
import '../models/age_result.dart';

class AgeCalculatorUtil {
  static AgeResult calculate(DateTime birthDate, DateTime toDate) {
    // Normalize to midnight
    final birth = DateTime(birthDate.year, birthDate.month, birthDate.day);
    final to = DateTime(toDate.year, toDate.month, toDate.day);

    // Years, months, days
    int years = to.year - birth.year;
    int months = to.month - birth.month;
    int days = to.day - birth.day;

    if (days < 0) {
      months--;
      final prevMonth = DateTime(to.year, to.month, 0);
      days += prevMonth.day;
    }
    if (months < 0) {
      years--;
      months += 12;
    }

    // Total months
    final totalMonths = (to.year - birth.year) * 12 + (to.month - birth.month) +
        (to.day < birth.day ? -1 : 0);
    final tempAfterMonths = DateTime(
      birth.year + totalMonths ~/ 12,
      birth.month + totalMonths % 12,
      birth.day,
    );
    final remainingDaysAfterMonths = to.difference(tempAfterMonths).inDays;

    // Total days
    final totalDays = to.difference(birth).inDays;

    // Total weeks
    final totalWeeks = totalDays ~/ 7;
    final remainingDaysAfterWeeks = totalDays % 7;

    // Total hours, minutes, seconds
    final totalHours = totalDays * 24;
    final totalMinutes = totalHours * 60;
    final totalSeconds = totalMinutes * 60;

    // Next birthday
    final nextBdInfo = _nextBirthdayInfo(birth, to);

    return AgeResult(
      birthDate: birth,
      toDate: to,
      years: years,
      months: months,
      days: days,
      totalMonths: totalMonths,
      remainingDaysAfterMonths: remainingDaysAfterMonths,
      totalWeeks: totalWeeks,
      remainingDaysAfterWeeks: remainingDaysAfterWeeks,
      totalDays: totalDays,
      totalHours: totalHours,
      totalMinutes: totalMinutes,
      totalSeconds: totalSeconds,
      nextBirthdayInfo: nextBdInfo.$1,
      daysUntilNextBirthday: nextBdInfo.$2,
    );
  }

  static (String, int) _nextBirthdayInfo(DateTime birth, DateTime today) {
    var nextBirthday = DateTime(today.year, birth.month, birth.day);
    if (!nextBirthday.isAfter(today)) {
      nextBirthday = DateTime(today.year + 1, birth.month, birth.day);
    }
    final daysLeft = nextBirthday.difference(today).inDays;
    final formatted = DateFormat('MMMM d, yyyy').format(nextBirthday);
    return ('$formatted ($daysLeft days away)', daysLeft);
  }

  static String formatNumber(int n) {
    return NumberFormat('#,###').format(n);
  }
}
