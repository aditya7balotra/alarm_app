import 'package:flutter/material.dart';
import 'package:alarm_app/provider/alarm_configs.dart';
import 'package:provider/provider.dart';

class Vibration extends StatefulWidget {
  final bool isVibrate;

  Vibration({this.isVibrate = true});
  @override
  VibrationState createState() => VibrationState();
}

class VibrationState extends State<Vibration> {
  // bool isOn = true;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlarmConfig>().updateIsVibrate(widget.isVibrate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Vibration",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        Selector<AlarmConfig, bool>(
          selector: (context, provider) => provider.isVibrate,
          builder: (context, value, _) {
            print(value);
            return Switch.adaptive(
              value: value,
              onChanged: (newState) {
                print("Updating the vibration state");
                context.read<AlarmConfig>().updateIsVibrate(newState);
              },
            );
          },
        ),
      ],
    );
  }
}
