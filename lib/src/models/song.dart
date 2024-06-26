import 'dart:io';

class Song {
  String songName;
  String songAuthor = '';
  late Duration songDuration;
  File songFile;
  String songDurationString = '';

  Song({required this.songName, required this.songFile, authorName, duration}) {
    songDuration = duration;
    songAuthor = authorName;
    if(songDuration.inMinutes < 10){
      songDurationString = '0${songDuration.inMinutes}:';
    } else{
      songDurationString = '${songDuration.inMinutes}:';
    }

    if (songDuration.inSeconds % 60 < 10) {
      songDurationString += '0${songDuration.inSeconds % 60}';
    } else {
      songDurationString += '${songDuration.inSeconds % 60}';
    }
  }

  String get _songName => songName;

  String get _songAuthor => songAuthor;

  Duration get _songDuration => songDuration;

  File get _songFile => songFile;
}
