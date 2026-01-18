import 'package:flutter/material.dart';
import 'package:alarm_app/pages/alarm_page/pages/alarm_page.dart';
import 'package:alarm_app/provider/alarm_configs.dart';
import 'package:alarm_app/provider/del.dart';
import 'package:provider/provider.dart';
import "package:intl/intl.dart";

class AlarmContainer extends StatefulWidget {
  final formatter = NumberFormat("00");

  // final alarmId;
  // final hour;
  // final minute;
  // final title;
  // final phase;
  // final bool toggleOn;

  final Map<String, dynamic> data;

  int convertTo12Hour(int hour24) {
    return hour24 % 12 == 0 ? 12 : hour24 % 12;
  }

  AlarmContainer({
    required this.data,
    // required this.alarmId,
    // required this.hour,
    // required this.minute,
    // required this.title,
    // required this.phase,
    // required this.toggleOn,
  });

  AlarmContainerState createState() => AlarmContainerState();
}

class AlarmContainerState extends State<AlarmContainer> {
  late bool toggleOn;
  // bool check = true;
  @override
  initState() {
    super.initState();
    // print(widget.data);
    toggleOn = widget.data["enabled"] == 1 ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () {
        print("long press detected");
        context.read<deleteProvider>().setIsSelected(true);
        print('value updated');
      },
      onTap: () {
        print(
          "Container with id: ${widget.data["id"]} and time ${widget.data["hour"]}:${widget.data["minute"]} is pressed",
        );
        if (context.read<deleteProvider>().isSelected) {
          // if delete selected is on
          if (!context.read<deleteProvider>().isIdSelected(widget.data["id"])) {
            print("adding");
            context.read<deleteProvider>().addSelectedIds(widget.data["id"]);
          } else {
            print("removing");
            context.read<deleteProvider>().removeSelectedIds(widget.data["id"]);
          }
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AlarmPage(data: widget.data),
            ),
          );
        }
      },
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Container(
        margin: EdgeInsets.only(bottom: 30),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white, width: .2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              // mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 5,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      "${widget.formatter.format(widget.convertTo12Hour(widget.data["hour"]))}:${widget.formatter.format(widget.data["minute"])}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.data["hour"] >= 12 ? "pm" : "am",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Card(
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: Colors.white, width: .5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      color: Colors.transparent,
                      child: Padding(
                        padding: EdgeInsets.all(5),
                        child: widget.data["days"] != 0
                            ? Icon(Icons.repeat, color: Colors.white, size: 12)
                            : Icon(
                                Icons.looks_one_outlined,
                                color: Colors.white,
                                size: 12,
                              ),
                      ),
                    ),
                  ],
                ),

                Text(
                  widget.data["title"] ?? "",
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),

            Selector<deleteProvider, bool>(
              selector: (context, provider) => provider.isSelected,
              builder: (_, value, _) {
                if (!value) {
                  return Switch.adaptive(
                    value: toggleOn,
                    onChanged: (bool value) {
                      toggleOn = value;
                      if (toggleOn) {
                        context.read<AlarmConfig>().enableAlarmById(
                          widget.data["id"],
                        );
                      } else {
                        context.read<AlarmConfig>().disableAlarmById(
                          widget.data["id"],
                        );
                      }
                      print("alarm disabled");
                      print("the value is $value");
                      setState(() {});
                    },
                  );
                }

                return Selector<deleteProvider, bool>(
                  selector: (_, provider) =>
                      provider.isIdSelected(widget.data["id"]),
                  builder: (_, value, _) {
                    return Checkbox(
                      value: value,
                      onChanged: (checkStatus) {
                        // print(checkStatus);
                        checkStatus == true
                            ? context.read<deleteProvider>().addSelectedIds(
                                widget.data["id"],
                              )
                            : context.read<deleteProvider>().removeSelectedIds(
                                widget.data["id"],
                              );
                      },
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
