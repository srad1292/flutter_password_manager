import 'package:flutter/cupertino.dart';
import 'package:password_manager/common/widget/confirmation_dalog.dart';
import 'package:password_manager/common/widget/error_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

class PmPermissionService {

  PmPermissionService();

  Future<bool> checkStoragePermission(BuildContext context) async {
    var storagePermission = await Permission.manageExternalStorage.status;
    print("Storage status: $storagePermission");
    if(storagePermission == PermissionStatus.granted || storagePermission == PermissionStatus.limited) {
      return true;
    } else if (storagePermission == PermissionStatus.denied) {
      var newPermission = await Permission.manageExternalStorage.request();
      return newPermission == PermissionStatus.granted || newPermission == PermissionStatus.limited;
    } else if(storagePermission == PermissionStatus.permanentlyDenied) {
      await _androidOpenSettings(context, "Permission Denied", "Access to files has been denied. Please enable in settings to continue");
      return false;
    }

    return false;
  }

  Future<void> _androidOpenSettings(BuildContext context, String title, String content) async {
    bool openSettings = await showConfirmationDialog(context: context, body: "Open app permission settings.");
    if(openSettings) {
      bool canOpenSettings = await openAppSettings();
      if (!canOpenSettings) {
        await _openSettingsRejected(context);
      }
    }


  }

  Future<void> _openSettingsRejected(BuildContext context) async {
    await showErrorDialog(context: context, body: "Unable to open settings. Please manually enable the permission to continue.");
  }

}