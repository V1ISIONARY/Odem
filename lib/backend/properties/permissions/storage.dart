import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';

Future<String?> chooseDownloadPath() async {
  if (kIsWeb) {
    return null; 
  }

  var status = await Permission.storage.status;
  if (!status.isGranted) {
    status = await Permission.storage.request();
  }

  if (status.isDenied || status.isPermanentlyDenied) {
    print('Storage permission denied');
    return null;
  }

  String? selectedDirectory = await FilePicker.platform.getDirectoryPath(
    dialogTitle: 'Select folder to save your SQLite file',
  );

  if (selectedDirectory != null) {
    print('User selected path: $selectedDirectory');
  } else {
    print('User canceled the folder picker');
  }

  return selectedDirectory;
}