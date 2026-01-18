import "package:permission_handler/permission_handler.dart";

Future<bool> requestNotificationPermission() async {
  var status = await Permission.notification.status;
  if (status.isDenied) {
    await Permission.notification.request();
  } else if (status.isPermanentlyDenied) {
    await openAppSettings();
  }

  return await Permission.notification.status == PermissionStatus.granted;
}
