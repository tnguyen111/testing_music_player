import 'models.dart';
import 'package:flutter/material.dart';

List<Playlist> playlistArray = [];
ValueNotifier<bool> importingFile = ValueNotifier<bool>(false);
bool playlistDeleteConfirmation = true;
bool songDeleteConfirmation = true;

