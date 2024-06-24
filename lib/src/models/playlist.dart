import 'package:flutter/cupertino.dart';

import 'models.dart';

class Playlist{
  String playlistName;
  Image playlistImage = Image.network('https://th.bing.com/th/id/OIP.D9khLX8H-gRPheV4jWHh7AHaHa?rs=1&pid=ImgDetMain');
  List<Song> songList = [];

  Playlist({required this.playlistName});

  String get _playlistName =>  playlistName;
  Image get _playListImage => playlistImage;

  void setImage(Image newImage){
    playlistImage = newImage;
    return;
  }

  void setName(String newName){
    playlistName = newName;
  }

  void addSong(Song newSong) {
    songList.add(newSong);
  }

  void removeSong(Song existedSong){
    songList.remove(existedSong);
  }
}