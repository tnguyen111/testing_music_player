
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'models.dart';

class Playlist{
  void initState() async{
    playlistImageByte_ = (await NetworkAssetBundle(Uri.parse('https://th.bing.com/th/id/OIP.D9khLX8H-gRPheV4jWHh7AHaHa?rs=1&pid=ImgDetMain'))
        .load('https://th.bing.com/th/id/OIP.D9khLX8H-gRPheV4jWHh7AHaHa?rs=1&pid=ImgDetMain'))
        .buffer
        .asUint8List();
  }

  String playlistName_;
  Image playlistImage_ = Image.network('https://th.bing.com/th/id/OIP.D9khLX8H-gRPheV4jWHh7AHaHa?rs=1&pid=ImgDetMain');
  List<Song> songList_ = [];

  late Uint8List playlistImageByte_;


  Playlist({required this.playlistName_}){initState();}

  String get playlistName =>  playlistName_;
  Image get playlistImage => playlistImage_;
  Uint8List get playlistImageByte => playlistImageByte_;

  void setImage(Image newImage, Uint8List newByte){
    playlistImage_ = newImage;
    playlistImageByte_ = newByte;
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