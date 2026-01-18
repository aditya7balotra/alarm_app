import 'package:flutter/material.dart';

class Edit extends ChangeNotifier {
  Map<String, dynamic> editData = {};

  void updateData(Map<String, dynamic> newData) {
    editData = newData;
  }
}
