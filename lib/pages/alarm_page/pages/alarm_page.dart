import 'package:flutter/material.dart';
import "package:alarm_app/pages/alarm_page/widgets/alarm_chooser.dart";
import "package:alarm_app/pages/alarm_page/widgets/pick_file.dart";
import "package:alarm_app/pages/alarm_page/widgets/time_phase_toggle.dart";
import "package:alarm_app/pages/alarm_page/widgets/alarm_title.dart";
import "package:alarm_app/pages/alarm_page/widgets/vibration.dart";
import "package:alarm_app/permissions.dart";
import "package:alarm_app/provider/alarm_configs.dart";
import "package:provider/provider.dart";

enum vibration { on, off }

class AlarmPage extends StatelessWidget {
  late final bool edit;
  final Map<String, dynamic>? data;
  AlarmPage({this.data}) : edit = data != null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      backgroundColor: Color(0xFF1C142D),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1C142D)),
            onPressed: () async {
              if (!await requestNotificationPermission()) {
                await requestNotificationPermission();
              }
              print("=========");
              print("alarm saved");
              data == null
                  ? context.read<AlarmConfig>().setAlarm()
                  : context.read<AlarmConfig>().setAlarm(
                      exists: true,
                      id: data!["id"],
                    );
              Navigator.pop(context);
            },
            child: Text(
              "Done",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
        title: Text(
          "Set alarm",
          style: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color(0xFF1C142D),
      ),

      body: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          spacing: 30,
          children: [
            AlarmChooseScrollView(
              editHour: data?["hour"],
              editMinute: data?["minute"],
            ),
            TimePhaseToggle(
              editIsAm: data?["hour"] == null
                  ? null
                  : data?["hour"] >= 12
                  ? false
                  : true,
            ),
            DayToggles(days: data?["days"]),
            AlarmTitle(editTitle: data?["title"]),

            PickAlarmSound(path: data?["tone_path"]),

            Vibration(isVibrate: data?["vibrate"] == 0 ? false : true),
          ],
        ),
      ),
    );
  }
}
