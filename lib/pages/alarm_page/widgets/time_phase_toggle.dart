import 'package:flutter/material.dart';
import 'package:alarm_app/provider/alarm_configs.dart';
import 'package:provider/provider.dart';

// enum timePhase { am, pm }

class TimePhaseToggle extends StatefulWidget {
  final bool? editIsAm;

  TimePhaseToggle({this.editIsAm});
  @override
  TimePhaseToggleState createState() => TimePhaseToggleState();
}

class TimePhaseToggleState extends State<TimePhaseToggle> {
  late List<bool> timePhase;
  late bool isAm;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timePhase = widget.editIsAm == null
        ? [DateTime.now().hour < 12, DateTime.now().hour >= 12]
        : [widget.editIsAm!, !widget.editIsAm!];
    isAm = widget.editIsAm == null ? timePhase[0] : widget.editIsAm!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlarmConfig>().updateIsAm(isAm);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(top: 30, bottom: 30),
      child: Row(
        spacing: 20,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,

              onTap: () {
                print("tap on timePhase selector detected");
                timePhase[0] = true;
                timePhase[1] = false;
                setState(() {
                  isAm = true;
                  context.read<AlarmConfig>().updateIsAm(isAm);
                  print("is am: $isAm");
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: timePhase[0]
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF8E5CFF), Color(0xFF5B2DCC)],
                        )
                      : null,
                  borderRadius: BorderRadius.circular(20),
                  color: timePhase[0] ? null : Color(0xFF2E2541),
                  border: BoxBorder.fromLTRB(
                    left: BorderSide(color: Colors.white, width: .2),
                    bottom: BorderSide(color: Colors.white, width: .2),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    right: 20,
                    left: 20,
                  ),
                  child: Text(
                    "AM",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,

              onTap: () {
                print("tap on timePhase selector detected");
                timePhase[0] = false;
                timePhase[1] = true;
                setState(() {
                  isAm = false;
                  context.read<AlarmConfig>().updateIsAm(isAm);
                  print("is am: $isAm");
                });
              },
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: timePhase[1]
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF8E5CFF), Color(0xFF5B2DCC)],
                        )
                      : null,
                  color: timePhase[1] == true ? null : Color(0xFF2E2541),
                  border: BoxBorder.fromLTRB(
                    left: BorderSide(color: Colors.white, width: .2),
                    bottom: BorderSide(color: Colors.white, width: .2),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    bottom: 10,
                    right: 20,
                    left: 20,
                  ),
                  child: Text(
                    "PM",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DayToggles extends StatefulWidget {
  final int? days;

  DayToggles({this.days});

  @override
  DayTogglesState createState() => DayTogglesState();
}

class DayTogglesState extends State<DayToggles> {
  late List<String> days = ["S", "M", "T", "W", "T", "F", "S"];
  late List<int> expandedDays = [
    DateTime.sunday,
    DateTime.monday,
    DateTime.tuesday,
    DateTime.wednesday,
    DateTime.thursday,
    DateTime.friday,
    DateTime.saturday,
  ];
  late final List<bool> isSelected;
  Set<int> daysSelected = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isSelected = widget.days == null
        ? [false, false, false, false, false, false, false]
        : [
            for (int i in [
              DateTime.sunday,
              DateTime.monday,
              DateTime.tuesday,
              DateTime.wednesday,
              DateTime.thursday,
              DateTime.friday,
              DateTime.saturday,
            ])
              context.read<AlarmConfig>().isDayinBitMaskDays(widget.days!, i),
          ];

    if (widget.days != null) {
      for (int i = 0; i < 7; i++) {
        if (isSelected[i]) {
          daysSelected.add(expandedDays[i]);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(bottom: 30),
      child: Row(
        spacing: 4,
        children: [
          for (int i = 0; i < days.length; i++)
            Expanded(
              child: InkWell(
                onTap: () {
                  isSelected[i] = !isSelected[i];
                  setState(() {
                    if (isSelected[i]) {
                      daysSelected.add(expandedDays[i]);
                    } else {
                      daysSelected.remove(expandedDays[i]);
                    }
                    print(daysSelected);
                    context.read<AlarmConfig>().updateDays(daysSelected);
                  });
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: isSelected[i]
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [Color(0xFF8E5CFF), Color(0xFF5B2DCC)],
                          )
                        : null,
                    borderRadius: BorderRadius.circular(20),
                    color: isSelected[i] == true ? null : Color(0xFF2E2541),
                    border: BoxBorder.fromLTRB(
                      left: BorderSide(color: Colors.white, width: .2),
                      bottom: BorderSide(color: Colors.white, width: .2),
                    ),
                  ),
                  padding: EdgeInsets.only(
                    top: 15,
                    bottom: 15,
                    left: 5,
                    right: 5,
                  ),
                  child: Text(
                    days[i],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
