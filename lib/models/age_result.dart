class AgeResult {
  final DateTime birthDate;
  final DateTime toDate;

  final int years;
  final int months;
  final int days;

  final int totalMonths;
  final int remainingDaysAfterMonths;

  final int totalWeeks;
  final int remainingDaysAfterWeeks;

  final int totalDays;
  final int totalHours;
  final int totalMinutes;
  final int totalSeconds;

  final String nextBirthdayInfo;
  final int daysUntilNextBirthday;

  const AgeResult({
    required this.birthDate,
    required this.toDate,
    required this.years,
    required this.months,
    required this.days,
    required this.totalMonths,
    required this.remainingDaysAfterMonths,
    required this.totalWeeks,
    required this.remainingDaysAfterWeeks,
    required this.totalDays,
    required this.totalHours,
    required this.totalMinutes,
    required this.totalSeconds,
    required this.nextBirthdayInfo,
    required this.daysUntilNextBirthday,
  });
}
