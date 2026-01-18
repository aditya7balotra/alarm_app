import 'package:flutter/material.dart';
import 'package:alarm_app/provider/alarm_configs.dart';
import "package:provider/provider.dart";

class AlarmTitleInput extends StatefulWidget {
  @override
  AlarmTitleInputState createState() => AlarmTitleInputState();
}

class AlarmTitleInputState extends State<AlarmTitleInput> {
  final TextEditingController _titleController = TextEditingController();
  String? errorText = null;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFF2E2541),
      title: Text(
        "title",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      content: TextField(
        style: TextStyle(color: Colors.white),

        controller: _titleController,
        decoration: InputDecoration(
          errorText: errorText,
          // fillColor: Colors.yellow,
          hintText: "morning alarm...",
          hintStyle: TextStyle(color: Colors.white24),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (_titleController.text.toString().length > 20) {
              errorText = "must be <= 20";
              setState(() {});
              return;
            } else {
              errorText = null;
              setState(() {});
            }
            // print(_titleController.text.toString());
            Navigator.pop(
              context,
              (_titleController.text.toString().replaceAll(" ", "") == "")
                  ? null
                  : _titleController.text.toString(),
            );
          },
          child: Text(
            'done',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class AlarmTitle extends StatefulWidget {
  final editTitle;
  AlarmTitle({this.editTitle});
  @override
  AlarmTitleState createState() => AlarmTitleState();
}

class AlarmTitleState extends State<AlarmTitle> {
  String? title;

  @override
  void initState() {
    super.initState();
    if (widget.editTitle != null) {
      title = widget.editTitle;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlarmConfig>().updateAlarmTitle(title);
    });
    print(title);
    print(widget.editTitle);
  }

  Future<void> showTitleDialogue(BuildContext context) async {
    title = await showDialog<String?>(
      context: context,
      builder: (context) {
        return AlarmTitleInput();
      },
    );

    context.read<AlarmConfig>().updateAlarmTitle(title);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.all(5),
      // margin: EdgeInsets.only(bottom:s 20),
      width: double.infinity,
      // alignment: Alignment.topLeft,
      child: InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        onTap: () {
          showTitleDialogue(context);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Alarm title", style: TextStyle(color: Colors.white)),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Selector<AlarmConfig, String?>(
                  selector: (context, provider) => provider.alarmTitle,
                  builder: (context, value, _) {
                    return Text(
                      value ?? "click to set...",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    );
                  },
                ),
                Icon(Icons.circle, color: Colors.white, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
