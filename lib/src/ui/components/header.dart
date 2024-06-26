import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_api_twitter/src/ui/themes/text_theme.dart';
import '../../services/services.dart';
import 'components.dart';


AppBar headerBar(WidgetRef ref){
  return AppBar(
    leading: Builder(
      builder: (context) {
        return menuIcon(context);
      },
    ),
    actions: [searchIcon(ref)],
  );
}

AppBar playlistAppBar(WidgetRef ref, String playlistName){
  return AppBar(
    leading: Builder(
      builder: (context) {
        return backIcon(context);
      },
    ),
    actions: [searchIcon(ref)],
    title: Text(playlistName, style: modeReadState(ref)? lightThemeHeaderText():darkThemeHeaderText(),),
  );
}

AppBar songAppBar(WidgetRef ref){
  return AppBar(
    leading: Builder(
      builder: (context) {
        return backIcon(context);
      },
    ),
    actions: [searchIcon(ref)],
    title: Text('Now Playing',style: modeReadState(ref)? lightThemeHeaderText():darkThemeHeaderText()),
  );
}



