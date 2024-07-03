import 'package:isar/isar.dart';
import 'package:duration/duration.dart';
part 'song.g.dart';

@collection
class SongDetails {
  Id id = Isar.autoIncrement;
  String songName = '';
  String songAuthor = '';
  String songDurationData = '';
  String songPath = '';

  @ignore
  String songDurationString = '';

  @ignore
  late Duration songDuration;

  void setDuration(String durationData) {
    songDuration = parseTime(durationData);
    if (songDuration.inMinutes < 10) {
      songDurationString = '0${songDuration.inMinutes}:';
    } else {
      songDurationString = '${songDuration.inMinutes}:';
    }

    if (songDuration.inSeconds % 60 < 10) {
      songDurationString += '0${songDuration.inSeconds % 60}';
    } else {
      songDurationString += '${songDuration.inSeconds % 60}';
    }
  }

  void setSongName(String name) {
    songName = name;
  }

  void setAuthorName(String name) {
    songAuthor = name;
  }

  SongDetails(
      {required this.songName, required this.songPath, required this.songAuthor, required this.songDurationData}) {
    setDuration(songDurationData);
  }
}
