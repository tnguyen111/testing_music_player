import 'dart:io';
import 'package:flutter/material.dart';


class Song{
  String songName;
  String songAuthor = '';
  Durations songDuration;
  File songFile;

  Song({required this.songName, required this.songFile, required this.songDuration});

  String get _songName =>  songName;
  String get _songAuthor =>  songAuthor;
  Durations get _songDuration => songDuration;
  File get _songFile =>  songFile;
}