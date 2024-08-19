import 'package:intl/intl.dart';

class CommonHelper {
  static String convertToPriceFormat(num value) {
    final format = NumberFormat("#,##0.00", "en_US");
    return format.format(value);
  }

  static String convertToPriceFormatWithoutCents(int value) {
    final format = NumberFormat("#,##0", "en_US");
    return format.format(value);
  }

  static String? convertDateStringToDateAndTime(DateTime? value) {
    if (value != null) {
      String formattedDate = DateFormat('dd/MM/yyyy, h:00a').format(value);
      return formattedDate;
    } else {
      return null;
    }
  }

  static String? getDate(DateTime? value) {
    if (value != null) {
      String formattedDate = DateFormat('dd/MM/yyyy').format(value);
      return formattedDate;
    } else {
      return null;
    }
  }

  static String? getDateStartWithYear(DateTime? value) {
    if (value != null) {
      String formattedDate = DateFormat('yyyy/MM/dd').format(value);
      return formattedDate;
    } else {
      return null;
    }
  }

  static String? getTime(DateTime? value) {
    if (value != null) {
      String formattedDate = DateFormat('h:mma').format(value);
      return formattedDate;
    } else {
      return null;
    }
  }

  static String getDayOfMonthSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  static String getOrdinalSuffix(int number) {
    if (number >= 11 && number <= 13) {
      return '${number}th';
    }

    switch (number % 10) {
      case 1:
        return '${number}st';
      case 2:
        return '${number}nd';
      case 3:
        return '${number}rd';
      default:
        return '${number}th';
    }
  }

  static bool isYouTubeUrl(String url) {
    final RegExp youtubeRegex = RegExp(
      r'^(https?\:\/\/)?(www\.youtube\.com|youtu\.?be)\/.+$',
      caseSensitive: false,
      multiLine: false,
    );
    return youtubeRegex.hasMatch(url);
  }
}
