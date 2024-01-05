extension DateTimeExt on DateTime {
  bool get isToday {
    final now = DateTime.now();
    if (year == now.year && month == now.month && day == now.day) {
      return true;
    }
    return false;
  }

  bool get isWeekend {
    return weekday == DateTime.sunday || weekday == DateTime.saturday;
  }

  DateTime get lastDateOfMonth {
    var month = this.month;
    var year = this.year;
    if (month == 12) {
      year++;
    }

    DateTime firstDateNextMonth = DateTime(year, (month % 12) + 1, 1);

    DateTime lastDayOfMonth =
        firstDateNextMonth.subtract(const Duration(days: 1));

    return lastDayOfMonth;
  }
}
