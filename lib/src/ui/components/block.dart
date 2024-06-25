import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:testing_api_twitter/src/config/config.dart';
import 'package:testing_api_twitter/src/ui/ui.dart';
import 'package:testing_api_twitter/src/services/services.dart';
import '../../../main.dart';
import '../../models/models.dart';

Container headerBlock(String header, WidgetRef ref) => Container(
      margin: const EdgeInsets.only(
          left: kDefaultPadding, top: kSmallPadding, bottom: kSmallPadding),
      child: Row(
        children: [
          Text(
            header,
          ),
          const SizedBox(width: 125),
          sortIcon(),
          (header == 'Your Playlist') ? settingListIcon(ref) : addIcon(ref),
        ],
      ),
    );

Container playlistBlock(WidgetRef ref, Playlist playlist) => Container(
      margin: const EdgeInsets.only(
          left: kDefaultPadding, right: kDefaultPadding, bottom: kSmallPadding),
      child: GestureDetector(
        onTap: () {
          // Change!
          modeSwitchState(ref);
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                color: (modeReadState(ref))
                    ? lightThemeHeader()
                    : darkThemeHeader(),
              ),
              height: 90,
            ),
            Row(
              children: [
                SizedBox(
                  width: 90,
                  height: 90,
                  child: Container(
                    child: playlist.playlistImage,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    playlist.playlistName,
                  ),
                ),
                settingSongIcon(ref, playlist),
              ],
            ),
          ],
        ),
      ),
    );

Container playlistAddBlock(WidgetRef ref) => Container(
      margin: const EdgeInsets.only(
          left: kDefaultPadding, right: kDefaultPadding, bottom: kSmallPadding),
      child: GestureDetector(
        onTap: () async {
          playlistSwitchState(ref);
          Navigator.push(
            globalNavigatorKey.currentContext!,
            MaterialPageRoute(
                builder: (context) => AddPlaylistScreen(ref: ref)),
          );
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                color: (modeReadState(ref))
                    ? lightThemeHeader()
                    : darkThemeHeader(),
              ),
              height: 90,
            ),
            Row(children: [
              SizedBox(
                width: 90,
                height: 90,
                child: Container(
                  color:
                      (modeReadState(ref)) ? lightThemeSub() : darkThemeSub(),
                  child: const Icon(Icons.add),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Add New Playlist',
                ),
              ),
            ]),
          ],
        ),
      ),
    );

Container songBlock(WidgetRef ref, Song song) => Container(
      margin: const EdgeInsets.only(
          left: kDefaultPadding, right: kDefaultPadding, bottom: kSmallPadding),
      child: GestureDetector(
        onTap: () {
          // Change!
          modeSwitchState(ref);
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                color: (modeReadState(ref))
                    ? lightThemeHeader()
                    : darkThemeHeader(),
              ),
              height: 65,
            ),
            Row(
              children: [
                const SizedBox(width: 10),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                    Text(
                      song.songName,
                    ),
                    Text('testAuthor', textScaler: TextScaler.linear(0.6),),
                  ]),
                ),
                Text(song.songDurationString),
                removeIcon(),
              ],
            ),
          ],
        ),
      ),
    );
