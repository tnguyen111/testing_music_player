
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';


class Playlist{


  String playlistName_;
  Image playlistImage_;
  ConcatenatingAudioSource songList_ = ConcatenatingAudioSource(children:[],useLazyPreparation: true,shuffleOrder: DefaultShuffleOrder());



  Playlist({required this.playlistName_, required this.playlistImage_});

  String get playlistName =>  playlistName_;
  Image get playlistImage => playlistImage_;
  ConcatenatingAudioSource get songList => songList_;

  void setImage(Image newImage){
    playlistImage_ = newImage;
    return;
  }

  void setName(String newName){
    playlistName_ = newName;
  }

  void addSong(AudioSource newSong) {
    songList_.children.add(newSong);
  }

  void removeSong(AudioSource existedSong){
    songList_.children.remove(existedSong);
  }
}