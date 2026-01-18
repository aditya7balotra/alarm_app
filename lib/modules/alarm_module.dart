import "package:alarm/alarm.dart";
import "package:alarm_app/database/db.dart";
import "package:intl/intl.dart";

class AlarmWrapper {
  DatabaseHelper dbHelper = DatabaseHelper.databaseHelper;
  final formatter = NumberFormat("00");

  DateTime datetime;
  String? audioPath;
  bool loopAudio;
  bool vibrate;
  double? volume;
  bool enforceVolume;
  List<VolumeFadeStep> fadeSteps;
  String? title;

  // This holds the actual configuration the package needs
  late AlarmSettings alarmSettings;

  AlarmWrapper({
    required this.datetime,
    this.audioPath = "assets/ringtones/alarm.mp3",
    this.title,
    this.loopAudio = false, // to loop the ringtone till the alarm is off
    this.vibrate = true,
    this.volume = 0.9,
    this.enforceVolume = false,
    List<VolumeFadeStep>? fadeSteps,
  }) : // Initialize the list in the constructor body to avoid 'const' errors
       fadeSteps =
           fadeSteps ??
           [
             VolumeFadeStep(const Duration(seconds: 0), 0.1),
             VolumeFadeStep(const Duration(seconds: 20), 0.3),
             VolumeFadeStep(const Duration(seconds: 50), 0.5),
             VolumeFadeStep(const Duration(seconds: 70), 0.7),
             VolumeFadeStep(const Duration(seconds: 100), 0.9),
           ];

  int to12Hour(int hour24) {
    assert(hour24 >= 0 && hour24 <= 23);

    if (hour24 == 0) return 12; // 00 → 12
    if (hour24 > 12) return hour24 - 12;
    return hour24; // 1–12 stay same
  }

  /// Sets the alarm using the generated settings
  Future<void> setAlarm(int id) async {
    // save to database
    // int id = await dbHelper.createAlarm(
    //   datetime.hour,
    //   datetime.minute,
    //   vibrate,
    //   datetime.day,
    //   audioPath,
    //   title,
    // );

    alarmSettings = AlarmSettings(
      id: id,
      dateTime: datetime,
      assetAudioPath: audioPath ?? "assets/ringtones/alarm.mp3",
      loopAudio: loopAudio,
      vibrate: vibrate,
      // For 2026, use staircaseFade for stepped volume jumps
      volumeSettings: VolumeSettings.staircaseFade(
        fadeSteps: fadeSteps,
        volume: volume,
        volumeEnforced: enforceVolume,
      ),
      notificationSettings: NotificationSettings(
        title:
            "${formatter.format(to12Hour(datetime.hour))}:${formatter.format(datetime.minute)} ${datetime.hour < 12 ? "am" : "pm"}",
        body: title ?? "",
        stopButton: "Stop", // Recommended for 2026
      ),
      androidFullScreenIntent: true, // Recommended to wake the screen
    );

    await Alarm.set(alarmSettings: alarmSettings);
    // print(await dbHelper.getData());
  }

  /// Helper to stop this specific alarm
  Future<void> stopAlarm(int id) async {
    await Alarm.stop(id);
  }

  static Future<void> stopAllAlarms() async {
    List<Map<String, dynamic>> allAlarms = await DatabaseHelper.databaseHelper
        .getData();
    for (Map<String, dynamic> alarm in allAlarms) {
      print("stopping alarm by id : ${alarm['id']}");
      await Alarm.stop(alarm["id"]);
    }
  }
}
