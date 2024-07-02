import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:just_audio/just_audio.dart';

@collection
class Playlist{
  late Id id;
  String playlistName_;

  @ignore
  Image playlistImage_;

  @ignore
  ConcatenatingAudioSource songList_ = ConcatenatingAudioSource(children:[],useLazyPreparation: true,shuffleOrder: DefaultShuffleOrder());

  @ignore
  Playlist({required this.playlistName_, required this.playlistImage_});

  String get playlistName =>  playlistName_;

  @ignore
  Image get playlistImage => playlistImage_;

  @ignore
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