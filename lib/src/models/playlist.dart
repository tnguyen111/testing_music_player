import 'dart:io';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
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

  Future<void> setAudioSource(SongDetails song) async {
    MediaItem newMediaItem = song.toMediaItem();
    await songList.add(
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
    bool changed = false;
    bool playing = false;
    AudioSource? tempConcar;
    int? tempIndex;
    Duration tempDura = Duration.zero;

    if (songList != player.audioSource && player.audioSource != null) {
      changed = true;
      playing = player.playing;
      tempConcar = player.audioSource;
      tempIndex = player.currentIndex;
      tempDura = player.position;

      await player.setAudioSource(songList);
    }

    await songList_.add(newSong);

    if (changed) {
      await player.setAudioSource(tempConcar!,
          initialIndex: tempIndex, initialPosition: tempDura);
      if (playing) player.play();
    }
  }

  Future<void> insertSong(int index, UriAudioSource insertedSong) async {
    bool changed = false;
    bool playing = false;
    AudioSource? tempConcar;
    int? tempIndex;
    Duration tempDura = Duration.zero;

    if (songList != player.audioSource && player.audioSource != null) {
      changed = true;
      playing = player.playing;
      tempConcar = player.audioSource;
      tempIndex = player.currentIndex;
      tempDura = player.position;

      await player.setAudioSource(songList);
    }

    await songList_.insert(index, insertedSong);

    if (changed) {
      await player.setAudioSource(tempConcar!,
          initialIndex: tempIndex, initialPosition: tempDura);
      if (playing) player.play();
    }
  }

  Future<void> removeSong(int index) async {
    bool switched = false;
    bool playing = false;
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
      if (playing) player.play();
    }
  }

  Future<void> moveSong(int oldIndex, int newIndex) async {
    bool switched = false;
    bool playing = false;
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

    await songList.move(oldIndex, newIndex);

    if (switched) {
      await player.setAudioSource(tempConcar!,
          initialIndex: tempIndex, initialPosition: tempDura);
      if (playing) player.play();
    }
  }

  Future<void> clearSong() async {
    bool switched = false;
    bool playing = false;
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

    await songList.clear();

    if (switched) {
      await player.setAudioSource(tempConcar!,
          initialIndex: tempIndex, initialPosition: tempDura);
      if (playing) player.play();
    }
  }

  Future<void> alterSong(int index, UriAudioSource edittedSong) async {
    bool changed = false;
    bool playing = false;
    AudioSource? tempConcar;
    int? tempIndex;
    Duration tempDura = Duration.zero;

    if (player.audioSource == songList && player.sequenceState?.currentSource == songList[index]) {
      changed = true;
      playing = player.playing;
      tempConcar = player.audioSource;
      tempIndex = songNameList.indexOf(edittedSong.tag.title);
      tempDura = player.position;
    }

    await removeSong(index);
    await insertSong(index, edittedSong);

    if (changed) {
      await player.setAudioSource(tempConcar!,
          initialIndex: tempIndex, initialPosition: tempDura);
      if (playing) player.play();
    }
  }
}

