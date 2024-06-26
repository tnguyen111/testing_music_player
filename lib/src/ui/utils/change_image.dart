import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

Future<Image> changeImage(Image image) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg', 'png', 'jfif'],
  );
  if (result != null) {
    String pathInput = result.files.single.path!;
    File file = File(pathInput);
    var imageInput = file.readAsBytesSync();
    image = Image.memory(
      imageInput,
      fit: BoxFit.fill,
    );
  }
  print('bruh: $image');
  return image;
}
