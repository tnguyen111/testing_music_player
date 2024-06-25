import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

import 'models.dart';

class Playlist{
  String playlistName;
  Image playlistImage = Image.network('https://th.bing.com/th/id/OIP.D9khLX8H-gRPheV4jWHh7AHaHa?rs=1&pid=ImgDetMain');
  List<Song> songList = [];

  late Uint8List playlistImageByte;

  void initState() async{
    playlistImageByte = (await NetworkAssetBundle(Uri.parse('https://th.bing.com/th/id/OIP.D9khLX8H-gRPheV4jWHh7AHaHa?rs=1&pid=ImgDetMain'))
      .load('https://th.bing.com/th/id/OIP.D9khLX8H-gRPheV4jWHh7AHaHa?rs=1&pid=ImgDetMain'))
      .buffer
      .asUint8List();
  }


  Playlist({required this.playlistName}){initState();}

  String get _playlistName =>  playlistName;
  Image get _playListImage => playlistImage;
  Uint8List get _playlistImageByte => playlistImageByte;

  void setImage(Image newImage, Uint8List newByte){
    playlistImage = newImage;
    playlistImageByte = newByte;
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