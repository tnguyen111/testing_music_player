
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'models.dart';

class Playlist{


  String playlistName_;
  Image playlistImage_;
  List<Song> songList_ = [];



  Playlist({required this.playlistName_, required this.playlistImage_});

  String get playlistName =>  playlistName_;
  Image get playlistImage => playlistImage_;
  List<Song> get songList => songList_;

  void setImage(Image newImage){
    playlistImage_ = newImage;
    return;
  }

  void setName(String newName){
    playlistName_ = newName;
  }

  void addSong(Song newSong) {
    songList_.add(newSong);
  }

  void removeSong(Song existedSong){
    songList_.remove(existedSong);
  }
}