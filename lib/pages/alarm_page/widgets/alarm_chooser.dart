import 'package:flutter/material.dart';
import "package:intl/intl.dart";
import 'package:alarm_app/provider/alarm_configs.dart';
import 'package:provider/provider.dart';
import "package:alarm_app/database/db.dart";

class AlarmChooseScrollView extends StatefulWidget {
  final int? editHour;
  final int? editMinute;
  AlarmChooseScrollView({this.editHour, this.editMinute});
  @override
  AlarmChooseScrollViewState createState() => AlarmChooseScrollViewState();
}

class AlarmChooseScrollViewState extends State<AlarmChooseScrollView> {
  final formatter = NumberFormat("00");
  late int hour;
  late int minute;
  late FixedExtentScrollController _hourController;
  late FixedExtentScrollController _minuteController;
  DatabaseHelper dbHelp = DatabaseHelper.databaseHelper;

  int to12Hour(int hour24) {
    assert(hour24 >= 0 && hour24 <= 23);

    if (hour24 == 0) return 12; // 00 → 12
    if (hour24 > 12) return hour24 - 12;
    return hour24; // 1–12 stay same
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(dbHelp.getData());
    hour = widget.editHour == null
        ? to12Hour(DateTime.now().hour)
        : to12Hour(widget.editHour!);
    // hour = widget.editHour ?? to12Hour(DateTime.now().hour);
    minute = widget.editMinute ?? DateTime.now().minute;
    print("$hour:$minute");
    _hourController = FixedExtentScrollController(initialItem: hour - 1);
    _minuteController = FixedExtentScrollController(initialItem: minute);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlarmConfig>().updateHour(hour);
      context.read<AlarmConfig>().updateMinute(minute);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _hourController.dispose();
    _minuteController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: BoxBorder.all(color: Colors.white, width: .2),
        borderRadius: BorderRadius.circular(20),
        color: Color(0xFF271D3A),
      ),
      height: 300,
      child: Row(
        children: [
          Expanded(
            child: Container(
              // height: 100,
              child: ListWheelScrollView.useDelegate(
                onSelectedItemChanged: (index) {
                  print("${index + 1} for hour");
                  hour = index + 1;
                  context.read<AlarmConfig>().updateHour(hour);
                },
                controller: _hourController,
                diameterRatio: 1.2,
                perspective: .003,
                squeeze: 1.2,
                physics: const FixedExtentScrollPhysics(),
                useMagnifier: true,
                overAndUnderCenterOpacity: .5,
                itemExtent: 100,
                childDelegate: ListWheelChildLoopingListDelegate(
                  children: [
                    for (int i = 1; i <= 12; i++)
                      Text(
                        formatter.format(i),
                        style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: Container(
              child: ListWheelScrollView.useDelegate(
                onSelectedItemChanged: (index) {
                  print("$index is on the minute");
                  minute = index;
                  context.read<AlarmConfig>().updateMinute(minute);
                },
                controller: _minuteController,
                diameterRatio: 1.2,
                perspective: .003,
                squeeze: 1.2,
                physics: const FixedExtentScrollPhysics(),
                useMagnifier: true,
                magnification: 1.2,
                overAndUnderCenterOpacity: .5,
                itemExtent: 100,
                childDelegate: ListWheelChildLoopingListDelegate(
                  children: [
                    for (int i = 0; i < 60; i++)
                      Text(
                        formatter.format(i),
                        style: TextStyle(
                          fontSize: 52,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
