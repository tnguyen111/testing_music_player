import 'models.dart';
import 'package:flutter/material.dart';

List<Playlist> playlistArray = [Playlist(playlistName_: '', imagePath_: '', songNameList_: [''])];
ValueNotifier<bool> importingFile = ValueNotifier<bool>(false);
bool playlistDeleteConfirmation = true;
bool songDeleteConfirmation = true;

