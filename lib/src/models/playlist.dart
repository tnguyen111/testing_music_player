import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:just_audio/just_audio.dart';

import 'models.dart';

part 'playlist.g.dart';

@collection
class Playlist {
  Id id = Isar.autoIncrement;
  String playlistName_;

  String imagePath_;
  List<String> songNameList_ = [];

  @ignore
  ConcatenatingAudioSource songList_ = ConcatenatingAudioSource(
      children: [],
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder());

  Playlist({required this.playlistName_, required this.imagePath_});

  String get playlistName => playlistName_;

  String get imagePath => imagePath_;

  List<String> get songNameList => songNameList_;

  @ignore
  ConcatenatingAudioSource get songList => songList_;

  void setAudioSource(SongDetails song) {
    songList.add(
      AudioSource.uri(
        Uri.parse(song.songPath),
        tag: song,
      ),
    );
  }

  Image getImage() {
    if (imagePath.startsWith("lib/assets/")) {
      return Image.asset(
        imagePath,
        fit: BoxFit.fill,
      );
    }
    return Image.file(
      File(imagePath),
      fit: BoxFit.fill,
    );
  }

  void setImage(String newImagePath) {
    imagePath_ = newImagePath;
    return;
  }

  void setName(String newName) {
    playlistName_ = newName;
  }

  void addSong(AudioSource newSong) {
    songList_.children.add(newSong);
  }

  void removeSong(AudioSource existedSong) {
    songList_.children.remove(existedSong);
  }
}
