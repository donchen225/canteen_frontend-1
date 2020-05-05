import 'package:canteen_frontend/models/availability/day.dart';
import 'package:tuple/tuple.dart';

class Availability {
  final int timeZone;
  final String timeZoneName;
  final Map<Day, List<Tuple2<int, int>>> timeRangesLocal;
  final Map<String, Map<String, int>> timeRangeRaw;

  Availability(
      {this.timeZone,
      this.timeZoneName,
      this.timeRangesLocal,
      this.timeRangeRaw});

  static Availability fromMap(Map<String, Map<String, int>> map,
      {int offset = 0}) {
    Map<Day, List<Tuple2<int, int>>> timeRanges = {};
    const daySeconds = 24 * 60 * 60;
    final timeNow = DateTime.now();
    final int localOffset = timeNow.timeZoneOffset.inSeconds;
    final String timeZoneName = timeNow.timeZoneName;

    void addToTimeRange(Tuple2<int, int> entry, String day, int dayOffset) {
      final dayIndex = int.tryParse(day);

      if (dayIndex == null) {
        print('FAILED TO PARSE INT DURING AVAILABILITY CONVERSION');
        return;
      }

      var newDayIndex = dayIndex + dayOffset;
      var finalDayIndex;
      if (newDayIndex < 0) {
        finalDayIndex = 6;
      } else if (newDayIndex > 6) {
        finalDayIndex = 0;
      } else {
        finalDayIndex = newDayIndex;
      }

      final finalDay = Day.values[finalDayIndex];

      if (timeRanges.containsKey(entry.item1)) {
        timeRanges[finalDay].add(Tuple2<int, int>(entry.item1, entry.item2));
      } else {
        timeRanges[finalDay] = [Tuple2<int, int>(entry.item1, entry.item2)];
      }
    }

    map.entries.forEach((entry) {
      print(entry);
      print(entry.key);
      print(entry.value);
      print(entry.value['start_time']);
      int startTime = entry.value['start_time'] - offset + localOffset;
      int endTime = entry.value['end_time'] - offset + localOffset;

      if (startTime < 0 && endTime <= 0) {
        startTime = daySeconds + startTime;
        endTime = daySeconds + endTime;
        addToTimeRange(Tuple2<int, int>(startTime, endTime), entry.key, -1);
      } else if (startTime < 0 && endTime > 0) {
        startTime = daySeconds + startTime;
        addToTimeRange(Tuple2<int, int>(startTime, daySeconds), entry.key, -1);
        addToTimeRange(Tuple2<int, int>(0, endTime), entry.key, 0);
      } else if (startTime < daySeconds && endTime > daySeconds) {
        endTime = endTime - daySeconds;
        addToTimeRange(Tuple2<int, int>(startTime, daySeconds), entry.key, 0);
        addToTimeRange(Tuple2<int, int>(0, endTime), entry.key, 1);
      } else if (startTime >= daySeconds && endTime > daySeconds) {
        startTime = startTime - daySeconds;
        endTime = endTime - daySeconds;
        addToTimeRange(Tuple2<int, int>(startTime, endTime), entry.key, 1);
      } else if (startTime >= 0 &&
          startTime <= daySeconds &&
          endTime >= 0 &&
          endTime <= daySeconds) {
        addToTimeRange(Tuple2<int, int>(startTime, endTime), entry.key, 0);
      } else {
        print('ERROR DURING AVAILABILITY CONVERSION');
      }
    });

    return Availability(
        timeZone: localOffset,
        timeZoneName: timeZoneName,
        timeRangesLocal: timeRanges,
        timeRangeRaw: map);
  }
}
