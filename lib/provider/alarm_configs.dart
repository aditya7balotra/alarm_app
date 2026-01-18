import "package:alarm/alarm.dart";
import 'package:flutter/material.dart';
import "package:alarm_app/modules/alarm_module.dart";
import "package:alarm_app/database/db.dart";

class AlarmConfig extends ChangeNotifier {
  DatabaseHelper dbHelper = DatabaseHelper.databaseHelper;

  // here alarm is 12hrs based
  late int hour;
  late int minute;
  List<int> days = [];
  late bool isAm;
  bool isVibrate = true;
  String? tonePath;
  String? alarmTitle;
  List<Map<String, dynamic>> _alarmList = [];

  AlarmConfig() {
    getData();
  }

  Future<void> setAlarmById(int id) async {
    // set alarm form the given id reference in the database
    // supposing the alarm is already in the enabled state false
    // and the alarm exists
    print("entered");
    Map<String, dynamic> data = await dbHelper.getDataById(id);
    DateTime now = DateTime.now();

    if (data["days"] == 0) {
      // case of one time alarm

      DateTime alarmTime =
          (now.isBefore(
            DateTime(
              now.year,
              now.month,
              now.day,
              data["hour"],
              data["minute"],
            ),
          ))
          ? DateTime(
              now.year,
              now.month,
              now.day,
              data["hour"],
              data["minute"],
            ) // set for today
          : DateTime(
              now.add(Duration(hours: 24)).year,
              now.add(Duration(hours: 24)).month,
              now.add(Duration(hours: 24)).day,
              data["hour"],
              data["minute"],
            ); // set for next day
      AlarmWrapper alarmWrapper = AlarmWrapper(
        datetime: alarmTime,
        audioPath: tonePath ?? "assets/ringtones/alarm.mp3",
        vibrate: isVibrate,
      );
      alarmWrapper.setAlarm(id);
      print("Alarm time: $alarmTime");
    } else {
      // case of repeat mode
      List<int> daysList = [];
      for (int i in {
        DateTime.monday,
        DateTime.tuesday,
        DateTime.wednesday,
        DateTime.thursday,
        DateTime.friday,
        DateTime.saturday,
        DateTime.sunday,
      }) {
        if (isDayinBitMaskDays(data["days"], i)) {
          daysList.add(i);
        }
      }

      List<int> daysDiffFromToday = days
          .map((day) => ((day - DateTime.now().weekday + 7) % 7))
          .toList();

      int closestDayDiff = minValue(daysDiffFromToday);

      DateTime? alarmTime = closestDayDiff == 0
          ? now.isBefore(
                  DateTime(
                    now.year,
                    now.month,
                    now.day,
                    data["hour"],
                    data["minute"],
                  ),
                )
                ? DateTime(
                    now.year,
                    now.month,
                    now.day,
                    data["hour"],
                    data["minute"],
                  ) // can ring today
                : (daysDiffFromToday.length == 1)
                ? DateTime(
                    now.add(Duration(days: 7)).year,
                    now.add(Duration(days: 7)).month,
                    now.add(Duration(days: 7)).day,
                    data["hour"],
                    data["minute"],
                  ) // set it after 7 days exactly
                : null // case of other days too
          : DateTime(
              now.add(Duration(days: closestDayDiff)).year,
              now.add(Duration(days: closestDayDiff)).month,
              now.add(Duration(days: closestDayDiff)).day,
              data["hour"],
              data["minute"],
            ); // set it after closestdaydiff exactly

      if (alarmTime == null) {
        daysDiffFromToday.remove(0);
        closestDayDiff = minValue(daysDiffFromToday);
        alarmTime = DateTime(
          now.add(Duration(days: closestDayDiff)).year,
          now.add(Duration(days: closestDayDiff)).month,
          now.add(Duration(days: closestDayDiff)).day,
          data["hour"],
          data["minute"],
        );
      }

      print("Alarm time: $alarmTime");
      AlarmWrapper alarmWrapper = AlarmWrapper(
        datetime: alarmTime,
        audioPath: tonePath,
        vibrate: isVibrate,
      );
      alarmWrapper.setAlarm(id);
    }
    // update the database
    dbHelper.updateAlarm(id, enabled: true);
    print("data base updated for setalarmbyid");
  }

  bool isDayinBitMaskDays(int days, int day) {
    // check if the given day is in the bitmasked days
    print("$days:$day:${days & (1 << day - 1) != 0}");
    return days & (1 << day - 1) != 0;
  }

  Future<void> setAlarm({bool exists = false, int id = -1}) async {
    // sets the alarm
    // change the hour format form 24 -> 12
    hour = convert12To24(hour, isAm);
    // getting key form the db
    if (!exists) {
      // if data don't exists
      int id = await dbHelper.createAlarm(
        hour,
        minute,
        isVibrate,
        getDaysValue(days),
        tonePath ?? "assets/ringtones/alarm.mp3",
        alarmTitle,
        // setting the alarm
      );
      await setAlarmById(id);
    } else {
      // if data exists
      if (id < 0) {
        throw "valid id is required";
      }
      print(alarmTitle);
      print("new updating alarm title");
      dbHelper.updateAlarm(
        id,
        hour: hour,
        minute: minute,
        isVibrate: isVibrate,
        tonePath: tonePath,
        days: getDaysValue(days),
        title: alarmTitle,
      );

      // also we need to update the set alarm if was enabled
      var data = await dbHelper.getDataById(id);
      if (data["enabled"] == 1) {
        print('alarm was enabled, so deleting and updatng');
        if (await Alarm.stop(id)) {
          await setAlarmById(id);
        }
        print('alarm set and canceled successfully');
      }

      print("new data: ${await dbHelper.getData()}");
    }
    getData();
  }

  Future<void> enableAlarmById(int id) async {
    await setAlarmById(id);
    print("Enable: ${await dbHelper.getData()}");
    getData();
  }

  Future<void> disableAlarmById(int id) async {
    // updating the data
    await dbHelper.updateAlarm(id, enabled: false);
    print("disabling the alarm:   ${await dbHelper.getData()}");
    Alarm.stop(id);
    getData();
  }

  int minValue(Iterable<int> values) {
    if (values.isEmpty) {
      throw StateError('Cannot find min of empty iterable');
    }
    return values.reduce((a, b) => a < b ? a : b);
  }

  int convert12To24(int hour, bool isAm) {
    if (hour < 1 || hour > 12) {
      throw ArgumentError('Hour must be between 1 and 12');
    }

    if (isAm) {
      return hour == 12 ? 0 : hour;
    } else {
      return hour == 12 ? 12 : hour + 12;
    }
  }

  int getBitValueOfDay(int day) {
    /**
     * 0000001(1) => monday
     * 0000010(2) => tuesday
     * 0000100(4) => wednesday
     * 0001000(8) => thursday
     * and so on...
     * 
     */
    return (1 << (day - 1));
  }

  int getDaysValue(List<int> days) {
    int result = 0;
    for (int day in days) {
      result |= getBitValueOfDay(day);
    }
    print("days value: $result");
    return result;
  }

  List<Map<String, dynamic>> get alarmList {
    getData();
    return _alarmList;
  }

  Future<void> getData() async {
    _alarmList = await DatabaseHelper.databaseHelper.getData();
    notifyListeners();
  }

  void updateIsVibrate(bool newValue) {
    isVibrate = newValue;
    print(isVibrate);
    notifyListeners();
  }

  void updateAlarmTitle(String? title) {
    alarmTitle = title;
    print(title);
    notifyListeners();
  }

  void updateAlarmSound(String? newSoundPath) {
    tonePath = newSoundPath;
    print("get new sound path: $tonePath");
    notifyListeners();
  }

  void updateIsAm(bool newValue) {
    isAm = newValue;
    print(isAm);
    notifyListeners();
  }

  void updateDays(Set<int> newValues) {
    days = newValues.toList();
    print(days);
    notifyListeners();
  }

  void updateHour(int hour) {
    this.hour = hour;
    notifyListeners();
    print("${this.hour} : notifier");
  }

  void updateMinute(int minute) {
    this.minute = minute;
    print("${this.minute} : notifier");
    notifyListeners();
  }
}
