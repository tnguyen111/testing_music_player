import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:mime/mime.dart';

import '../../models/models.dart';

Future<File> changePlaylistImage(Playlist playlist) async {
  File file = File('');
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg', 'png', 'jfif'],
  );
  if (result != null) {
    String pathInput = result.files.single.path!;
    if (lookupMimeType(pathInput)!.startsWith("image")) {
      File file = File(pathInput);
      var imageInput = file.readAsBytesSync();
      playlist.setImage(Image.memory(imageInput, fit: BoxFit.fill));
    }
  }

  return file;
}
