import 'package:intl/intl.dart';

class DateTimeHelper {
  static DateTime dateTimeScheduled() {
    // Mengatur waktu secara spesifik
    const timeSpecific = '11:00:00';

    // Format tanggal dan waktu
    // ex. output: 2022-04-07 11:00:00.000
    final now = DateTime.now();
    final dateFormat = DateFormat('y/M/d');
    final completeFormat = DateFormat('y/M/d H:m:s');

    // Format tanggal dan waktu hari ini
    // ex. output: 2022/4/7
    final todayDate = dateFormat.format(now);

    // ex. output: 2022/4/7 11:00:00
    final todayDateAndTime = '$todayDate $timeSpecific';

    // ex. output: 2022-04-07 11:00:00.000
    final resultToday = completeFormat.parseStrict(todayDateAndTime);

    // Format tanggal dan waktu besok
    // ex. output: 2022-04-08 11:00:00.000
    final formatted = resultToday.add(const Duration(days: 1));

    // ex. output: 2022/4/8
    final tomorrowDate = dateFormat.format(formatted);

    // ex. output: 2022/4/8 11:00:00
    final tomorrowDateAndTime = '$tomorrowDate $timeSpecific';

    // ex. output: 2022-04-08 11:00:00.000
    final resultTomorrow = completeFormat.parseStrict(tomorrowDateAndTime);

    // Jika hari ini sudah melewati jam 11 pagi, maka akan mengembalikan nilai
    // resultTomorrow, jika hari ini belum melewati jam 11 pagi, maka akan mengembalikan
    // nilai resultToday
    return now.isAfter(resultToday) ? resultTomorrow : resultToday;
  }
}
