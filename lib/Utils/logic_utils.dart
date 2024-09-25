import 'package:persian_number_utility/persian_number_utility.dart';

class LogicUtils {
  static List<List<T>> generateChunks<T>(List<T> inList, int chunkSize) {
    List<List<T>> outList = [];
    List<T> tmpList = [];
    int counter = 0;

    for (int current = 0; current < inList.length; current++) {
      if (counter != chunkSize) {
        tmpList.add(inList[current]);
        counter++;
      }
      if (counter == chunkSize || current == inList.length - 1) {
        outList.add(tmpList.toList());
        tmpList.clear();
        counter = 0;
      }
    }

    return outList;
  }

  static String moneyFormat(
    double? price, [
    bool showText = true,
  ]) {
    price ??= 0.0;
    return price.toInt().toString().seRagham() + (showText ? " تومان" : '');
  }

  static String durationToMinHour(Duration difference) {
    int min = difference.inMinutes;
    int seconds = difference.inSeconds - (difference.inMinutes * 60);
    String second = seconds >= 10 ? seconds.toString() : "0$seconds";
    return "$min:$second";
  }
}

extension Custom on String {
  String checkMeter({int divide = 100}) {
    double? value = double.tryParse(this);
    if (value is double) {
      if (value >= 100 && (value / divide) >= 0.1){
        return "${(value / divide)} متر ${(divide / 100) == 100 ? "مربع" : ""}";
      }
      return "${(value).round()} سانتی متر ${(divide / 100) == 100 ? "مربع" : ""}";
    }
    return this;
  }
}

extension DurationExtensions on Duration {
  /// Converts the duration into a readable string
  /// 05:15
  String toHoursMinutes() {
    String twoDigitMinutes = _toTwoDigits(this.inMinutes.remainder(60));
    return "${_toTwoDigits(this.inHours)}:$twoDigitMinutes";
  }

  String toMinutesSeconds() {
    String twoDigitMinutes = _toTwoDigits(this.inMinutes.remainder(60));
    String twoDigitSeconds = _toTwoDigits(this.inSeconds.remainder(60));
    return "${twoDigitMinutes}:$twoDigitSeconds";
  }

  /// Converts the duration into a readable string
  /// 05:15:35
  String toHoursMinutesSeconds() {
    String twoDigitMinutes = _toTwoDigits(this.inMinutes.remainder(60));
    String twoDigitSeconds = _toTwoDigits(this.inSeconds.remainder(60));
    return "${_toTwoDigits(this.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  String _toTwoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }
}

extension Time on DateTime {
  String timeAgo() {
    // <-- Custom method Time Show  (Display Example  ==> 'Today 7:00 PM')     // WhatsApp Time Show Status Shimila
    Duration diff = DateTime.now().difference(this);
    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "سال" : "سال"} پیش";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "ماه" : "ماه"} پیش";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "هفته" : "هفته"} پیش";
    }
    if (diff.inDays > 0) return "${diff.inDays} روز پیش";
    if (diff.inHours > 0) return "${diff.inHours} ساعت پیش";
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "دقیقه" : "دقیقه"} پیش";
    }
    return "همین الان";
  }
  String chatTime() {
    return "${hour.toString().padLeft(2,"0")}:${minute.toString().padLeft(2,"0")}";
  }
}