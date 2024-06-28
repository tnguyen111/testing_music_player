import 'dart:io';

class SongDetails{
  String songName   = '';
  String songAuthor = '';
  String songDurationString = '';
  late Duration songDuration;

  void setDuration(Duration duration){
    songDuration = duration;
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

  void setSongName(String name){songName = name;}
  void setAuthorName(String name){songAuthor = name;}
  SongDetails({required this.songName, authorName, duration}){
    songAuthor = authorName;
    setDuration(duration);
  }
}
