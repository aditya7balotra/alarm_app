import "package:alarm/alarm.dart";
import "package:flutter/material.dart";
import "package:alarm_app/pages/home/pages/home_page.dart";
import "package:alarm_app/provider/edit.dart";
import "package:provider/provider.dart";
import "package:alarm_app/provider/alarm_configs.dart";
import "package:alarm_app/provider/del.dart";

// Define this outside your classes so it's globally accessible
// final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Alarm.init();
  // listenToAlarm();
  print('initialisation finished');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AlarmConfig()),
        ChangeNotifierProvider(create: (_) => Edit()),
        ChangeNotifierProvider(create: (_) => deleteProvider()),
      ],
      child: MaterialApp(
        // navigatorKey: navigatorKey,
        home: HomePage(),
        theme: ThemeData(
          // scaffoldBackgroundColor: Colors.black,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            surface: Colors.black,
          ),
        ),
      ),
    ),
  );
}

// void listenToAlarm() {
//   Alarm.ringStream.stream.listen((alarmSettings) {
//     // Navigate to the ring screen automatically
//     navigatorKey.currentState?.push(
//       MaterialPageRoute(
//         builder: (context) => AlarmRingScreen(alarmSettings: alarmSettings),
//       ),
//     );
//   });
// }

// class AlarmRingScreen extends StatelessWidget {
//   final AlarmSettings alarmSettings;

//   const AlarmRingScreen({super.key, required this.alarmSettings});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         width: double.infinity,
//         color: Colors.red.shade900, // Urgent color
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.alarm, size: 100, color: Colors.white),
//             const SizedBox(height: 20),
//             Text(
//               alarmSettings.notificationSettings.title,
//               style: const TextStyle(
//                 fontSize: 28,
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 60),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 40,
//                   vertical: 15,
//                 ),
//               ),
//               onPressed: () async {
//                 // 1. Stop the alarm sound
//                 await Alarm.stop(alarmSettings.id);
//                 // 2. Close this screen
//                 if (context.mounted) Navigator.pop(context);
//               },
//               child: const Text(
//                 "DISMISS ALARM",
//                 style: TextStyle(fontSize: 20),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
