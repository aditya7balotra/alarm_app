import 'package:flutter/material.dart';
import 'package:alarm_app/pages/alarm_page/pages/alarm_page.dart';
import "package:alarm_app/pages/home/widgets/alarm_containers.dart";
import 'package:alarm_app/provider/alarm_configs.dart';
import 'package:alarm_app/provider/del.dart';
import "package:provider/provider.dart";

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1C142D),
      appBar: AppBar(
        centerTitle: true,
        title: Selector<deleteProvider, (bool, int)>(
          selector: (context, provider) =>
              (provider.isSelected, provider.selected),
          builder: (context, value, _) {
            return Text(
              value.$1 ? "${value.$2} selected" : "Alarms",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            );
          },
        ),
        leading: Selector<deleteProvider, bool>(
          selector: (_, provider) => provider.isSelected,
          builder: (_, value, _) {
            if (!value) return SizedBox.shrink();

            return IconButton(
              icon: Icon(Icons.cancel_outlined),
              color: Colors.white,
              onPressed: () {
                context.read<deleteProvider>().setIsSelected(false);
              },
            );
          },
        ),
        actions: [
          Selector<deleteProvider, (bool, bool)>(
            selector: (_, provider) =>
                (provider.isSelected, provider.allSelected),
            builder: (_, value, _) {
              if (!value.$1) return SizedBox.shrink();
              return Checkbox(
                value: context.read<deleteProvider>().allSelected,
                onChanged: (checkStatus) async {
                  await context.read<deleteProvider>().updateAllSelected(
                    checkStatus!,
                  );
                },
              );
            },
          ),
        ],
        backgroundColor: Color(0xFF1C142D),
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF8E5CFF), Color(0xFF5B2DCC)],
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: FloatingActionButton(
          backgroundColor: Colors.transparent,
          // backgroundColor: Color(0xFF7A5AF8),
          onPressed: () {
            if (!context.read<deleteProvider>().isSelected) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AlarmPage()),
              );
            } else {
              context.read<deleteProvider>().deleteSelected();
              print("to delete");
            }
            print('floating pressed');
          },
          child: Selector<deleteProvider, bool>(
            selector: (_, provider) => provider.isSelected,
            builder: (_, value, _) {
              if (!value) return Icon(Icons.add, color: Colors.white);
              return Icon(Icons.delete, color: Colors.white);
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(20),
          height: double.infinity,
          width: double.infinity,
          alignment: Alignment.center,
          child: Selector<AlarmConfig, List<Map<String, dynamic>>>(
            selector: (context, provider) => provider.alarmList,
            builder: (context, value, _) {
              if (value.isEmpty) {
                return const Center(
                  child: Text(
                    "No alarms yet",
                    style: TextStyle(color: Colors.grey, fontSize: 18),
                  ),
                );
              }

              return ListView.builder(
                itemBuilder: (context, index) {
                  print(value[index]["id"]);
                  print("ids.....");
                  return AlarmContainer(
                    data: value[index],
                    // alarmId: value[index]["id"],
                    // hour: value[index]["hour"],
                    // minute: value[index]["minute"],
                    // phase: value[index]["hour"] >= 12 ? "pm" : "am",
                    // title: value[index]["title"] ?? "",
                    // toggleOn: value[index]["enabled"] == 1 ? true : false,
                  );
                },
                itemCount: value.length,
              );
            },
          ),
        ),
      ),
    );
  }
}
