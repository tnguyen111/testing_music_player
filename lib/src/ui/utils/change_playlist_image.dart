import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import '../../models/models.dart';

Future<void> changePlaylistImage(Playlist playlist) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ['jpg', 'jpeg', 'png', 'jfif'],
  );
  if (result != null) {
    String pathInput = result.files.single.path!;
    print('imagePath: $pathInput');
    final Directory appDocumentsDir = await getApplicationDocumentsDirectory();

    if (lookupMimeType(pathInput)!.startsWith("image")) {
      String filePath = '${appDocumentsDir.path}/${basenameWithoutExtension(pathInput)}.jpg';
      print(filePath);
      if (!(await File(filePath).exists())) {
        await FlutterImageCompress.compressAndGetFile(
          pathInput,
          filePath,
          quality: 90,
        );
      }
      if (!(playlist.imagePath.contains('lib/assets/')) &&
          playlistArray
              .where((element) => element.imagePath == playlist.imagePath)
              .isEmpty) {
        await File(playlist.imagePath).delete();
      }
      playlist.setImage(filePath);
    }
  }
  FilePicker.platform.clearTemporaryFiles();
  return;
}

// String changeImage(List<String> temp) {
//   String pathInput = temp[0];
//   String directory = temp[1];
//   final dir = Directory(directory);
//   print(dir.path);
//   var files = dir.listSync(recursive: false);
//   // get the subdirectories
//   print('running');
//   for (final f in files) {
//     if (f is Directory &&
//         !f.path.contains('/storage/emulated/0/Android') &&
//         !f.path.contains('/storage/emulated/0/Music')) {
//       print(f.path);
//       var tempFile = File('${f.path}/${basename(File(pathInput).path)}');
//       if (tempFile.existsSync()) {
//         print('this: ${tempFile.path}');
//         return tempFile.path;
//         //files = f.listSync();
//       }
//       var newFiles = Directory(f.path).listSync(recursive: true);
//       for (final i in newFiles) {
//         tempFile = File('${i.path}/${basename(File(pathInput).path)}');
//         if (tempFile.existsSync()) {
//           print('this: ${tempFile.path}');
//           return tempFile.path;
//           //files = f.listSync();
//         }
//       }
//     }
//   }
//   print('done');
//   return '';
// }
