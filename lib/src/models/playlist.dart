import 'dart:io';

import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:testing_music_player/src/services/services.dart';

import '../services/database/database.dart';
import 'models.dart';

part 'playlist.g.dart';

@collection
class Playlist {
  Id id = Isar.autoIncrement;
  String playlistName_;

  String imagePath_;
  List<String> songNameList_;

  @ignore
  ConcatenatingAudioSource songList_ = ConcatenatingAudioSource(
      children: [],
      useLazyPreparation: true,
      shuffleOrder: DefaultShuffleOrder());

  Playlist(
      {required this.playlistName_,
      required this.imagePath_,
      required this.songNameList_}) {
    songNameList_ = songNameList_.toList(growable: true);
  }

  String get playlistName => playlistName_;

  String get imagePath => imagePath_;

  List<String> get songNameList => songNameList_;

  @ignore
  ConcatenatingAudioSource get songList => songList_;

  void getSongFromList() async {
    for (int i = 0; i < songNameList.length; i++) {
      var existingSong = await IsarHelper().getSongFor(songNameList[i]);
      setAudioSource(existingSong!);

    }
  }

  void setAudioSource(SongDetails song) {
    MediaItem newMediaItem = song.toMediaItem();
    songList.add(
      AudioSource.uri(
        Uri.parse(song.songPath),
        tag: newMediaItem,
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

  Future<void> addSong(UriAudioSource newSong) async {
    bool switched = false;
    bool playing = player.playing;
    AudioSource? tempConcar;
    int? tempIndex;
    Duration tempDura = Duration.zero;

    if (songList != player.audioSource && player.audioSource != null) {
      switched = true;
      playing = player.playing;
      tempConcar = player.audioSource;
      tempIndex = player.currentIndex;
      tempDura = player.position;
      await player.setAudioSource(songList);
    }

    await songList_.add(newSong);

    if (switched) {
      await player.setAudioSource(tempConcar!,
            initialIndex: tempIndex, initialPosition: tempDura);
      if(playing) player.play();
    }
  }

  Future<void> removeSong(int index) async {
    bool switched = false;
    bool playing = player.playing;
    AudioSource? tempConcar;
    int? tempIndex;
    Duration tempDura = Duration.zero;

    if (songList != player.audioSource && player.audioSource != null) {
      switched = true;
      playing = player.playing;
      tempConcar = player.audioSource;
      tempIndex = player.currentIndex;
      tempDura = player.position;
      await player.setAudioSource(songList);

    }

    await songList_.removeAt(index);

    if (switched) {
      await player.setAudioSource(tempConcar!,
            initialIndex: tempIndex, initialPosition: tempDura);
      if(playing) player.play();
    }

  }
}
