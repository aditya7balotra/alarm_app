import 'package:flutter/material.dart';
import "package:alarm_app/provider/alarm_configs.dart";
import "dart:io";
import "package:path/path.dart" as path;
import "package:file_picker/file_picker.dart";
import "package:path_provider/path_provider.dart";
import "package:provider/provider.dart";

class PickAlarmSound extends StatefulWidget {
  final soundPath;

  PickAlarmSound({String? path}) : soundPath = path;

  @override
  PickAlarmSoundState createState() => PickAlarmSoundState();
}

class PickAlarmSoundState extends State<PickAlarmSound> {
  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AlarmConfig>().updateAlarmSound(widget.soundPath);
    });
  }

  Future<File> saveToAppStorage(File file) async {
    // first get the app's document directory
    // somthing like .../com.app_name/files
    Directory appStorageDir = await getApplicationDocumentsDirectory();
    // now get the basename of the file
    String fileName = path.basename(file.path);
    // now the new path
    String newPath = path.join(appStorageDir.path, fileName);
    // now save the file
    File newFile = await file.copy(newPath);
    // delete the cache
    await file.delete();
    return newFile;
  }

  Future<String?> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: <String>["mp3"],
    );

    if (result != null) {
      print(result);
      print(result.files);
      print("=============");
      await saveToAppStorage(File(result.files.first.path!));
      return result.files.first.name;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        AlarmConfig ctx = context.read<AlarmConfig>();
        String? name = await pickFile();
        if (name != null) {
          print(name);
          ctx.updateAlarmSound(name);
        }
      },
      child: Selector<AlarmConfig, String?>(
        selector: (context, provider) => provider.tonePath,
        builder: (context, value, _) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value ?? "default",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
              Icon(Icons.music_note, color: Colors.white),
            ],
          );
        },
      ),
    );
  }
}
