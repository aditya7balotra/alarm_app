import 'package:flutter/material.dart';
import "package:alarm_app/modules/alarm_module.dart";
import "package:alarm/alarm.dart";
import "package:alarm_app/database/db.dart";

class deleteProvider extends ChangeNotifier {
  DatabaseHelper dbHelper = DatabaseHelper.databaseHelper;
  bool isSelected = false;
  Set<int> selectedIds = {};
  bool allSelected = false;
  int selected = 0;

  void selectAll() {}

  Future<void> updateAllSelected(bool newValue) async {
    allSelected = newValue;
    if (allSelected) {
      var totals = await DatabaseHelper.databaseHelper.getData();
      selected = totals.length;
    } else {
      selected = selectedIds.length;
    }
    notifyListeners();
  }

  void setIsSelected(bool newValue) {
    if (!newValue) {
      selectedIds = {};
      selected = 0;
      allSelected = false;
    }
    isSelected = newValue;
    notifyListeners();
  }

  void addSelectedIds(int id) {
    if (!isIdSelected(id)) {
      selectedIds.add(id);
      selected++;
      print(id);
      notifyListeners();
      print(selectedIds);
    }
  }

  void removeSelectedIds(int id) {
    if (isIdSelected(id) && !allSelected) {
      selectedIds.remove(id);
      selected--;
      notifyListeners();
      print(selectedIds);
    }
  }

  bool isIdSelected(int id) {
    print("in the is id selected");
    if (allSelected) {
      return true;
    }
    print(selectedIds.contains(id));
    print(id);
    return selectedIds.contains(id);
  }

  Future<void> deleteSelected() async {
    print("schedulaed alarms: before");
    print(await Alarm.getAlarms());

    if (allSelected) {
      await AlarmWrapper.stopAllAlarms();
      print("before del data");
      print(await dbHelper.getData());
      await dbHelper.delAllData();
      print("after del data");
      print(await dbHelper.getData());
    } else {
      print("before del data");
      print(await dbHelper.getData());

      for (int i in selectedIds) {
        print("stopping alarm for id $i");
        await Alarm.stop(i);
        dbHelper.delAlarm(i);
      }
      print("after del data");
      print(await dbHelper.getData());
    }
    print("scheduled alarms: after");
    print(await Alarm.getAlarms());
    updateAllSelected(false);
    setIsSelected(false);
    selected = 0;
    notifyListeners();
  }
}
