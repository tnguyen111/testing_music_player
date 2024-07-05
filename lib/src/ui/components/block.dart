import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:testing_music_player/src/config/config.dart';
import 'package:testing_music_player/src/ui/ui.dart';
import 'package:testing_music_player/src/services/services.dart';
import '../../../main.dart';
import '../../models/models.dart';


Container headerBlock(String header, WidgetRef ref) => Container(
      margin: const EdgeInsets.only(
          left: kDefaultPadding, top: kSmallPadding, bottom: kSmallPadding),
      child: Row(
        children: [
          Expanded(
            child: Text(
              header,
            ),
          ),
          const SizedBox(width: 125),
          /*sortIcon(ref, header),*/
          (header == 'Your Playlist')
              ? settingListIcon(ref)
              : addIcon(ref, songArray),
        ],
      ),
    );

Container playlistBlock(WidgetRef ref, Playlist playlist) => Container(
      margin: const EdgeInsets.only(
          left: kDefaultPadding, right: kDefaultPadding, bottom: kSmallPadding),
      child: GestureDetector(
        onTap: () {
          // Change!
          Navigator.push(
            globalNavigatorKey.currentContext!,
            MaterialPageRoute(
                builder: (context) => playlistScreen(ref, playlist)),
          );
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                color: currentThemeHeader(ref),
              ),
              height: 90,
            ),
            Row(
              children: [
                SizedBox(
                  width: 90,
                  height: 90,
                  child: Container(
                    child: playlist.getImage(),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    playlist.playlistName_,
                  ),
                ),
                (playlistRemoving) ?
                removePlaylistIcon(ref, playlist):settingSongIcon(ref, playlist),
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
          Playlist playlist = Playlist(playlistName_: '', imagePath_: 'lib/assets/default_image.jpg', songNameList_: []);
          Navigator.push(
            globalNavigatorKey.currentContext!,
            MaterialPageRoute(
              builder: (context) => addPlaylistScreen(ref, playlist),
            ),
          );
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(kDefaultBorderRadius),
                color: currentThemeHeader(ref),
              ),
              height: 90,
            ),
            Row(children: [
              SizedBox(
                width: 90,
                height: 90,
                child: Container(
                  color: currentThemeSub(ref),
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

Container songBlock(
        WidgetRef ref, ConcatenatingAudioSource playlist, int index) =>
    Container(
      margin: const EdgeInsets.only(
          left: kDefaultPadding, right: kDefaultPadding, bottom: kSmallPadding),
      child: GestureDetector(
        onTap: () {
          if(player.audioSource != playlist){
            loadNewPlaylist(playlist, index);
          }
          loadNewSong(ref, playlist, index);
          playlistSwitchState(ref);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kDefaultBorderRadius),
            color: currentThemeHeader(ref),
          ),
          padding: const EdgeInsets.only(top: 9, bottom:9),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text((playlist.children[index] as UriAudioSource)
                          .tag
                          .songName),
                      Text(
                        (playlist.children[index] as UriAudioSource)
                            .tag
                            .songAuthor,
                        textScaler: const TextScaler.linear(0.6),
                      ),
                    ]),
              ),
              Text((playlist.children[index] as UriAudioSource)
                  .tag
                  .songDurationString),
              removeIcon(ref, playlist,
                  (playlist.children[index] as UriAudioSource), index),
            ],
          ),
        ),
      ),
    );

Container playlistMenuBlock(WidgetRef ref, Playlist playlist) => Container(
      margin: const EdgeInsets.only(
          left: kDefaultPadding, right: kDefaultPadding, bottom: kSmallPadding),
      child: Column(
        children: [
          const SizedBox(height: kDefaultPadding),
          GestureDetector(
            child: SizedBox(
              width: 300,
              height: 300,
              child: playlist.getImage(),
            ),
            onTap: () async {
              await changePlaylistImage(playlist);
              IsarHelper().savePlaylist(playlist);
              playlistSwitchState(ref);
            },
          ),
          TextButton(
            onPressed: () {
              editPlaylistNameDialog(
                  globalNavigatorKey.currentContext!, ref, playlist);
            },
            child: Text(
              playlist.playlistName,
              style: currentThemeHeaderText(ref),
            ),
          ),
          Row(
            children: [
              playIcon(ref, playlist.songList),
              shuffleIcon(ref),
              const Expanded(
                child: SizedBox(),
              ),
              /*sortSongIcon(
                ref,
                playlist,
              ),*/
              addSongMenuIcon(
                ref,
                playlist,
              ),
            ],
          ),
        ],
      ),
    );

Widget songIconBlock(
    WidgetRef ref, ConcatenatingAudioSource playlist, int index, bool isNotMiniplayer) {
  double scaling = 2;
  if(!isNotMiniplayer){
    scaling = 1;
  }
  songWatchState(ref);
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    (isNotMiniplayer) ?
    shuffleIcon(ref): Container(),
    skipSongIcon(ref, false, playlist, index, isNotMiniplayer),
    SizedBox(width: 9*scaling),
    Transform.scale(scale: scaling, child: playIcon(ref,playlist)),
    SizedBox(width: 9*scaling),
    skipSongIcon(ref, true, playlist, index, isNotMiniplayer),
    (isNotMiniplayer) ?
    loopIcon(ref): Container(),
  ]);
}

Widget songNameBlock(WidgetRef ref, UriAudioSource song) {
  return Column(
    children: [
      const SizedBox(height: 18),
      Text(
        song.tag.songName,
        style: currentThemeHeaderText(ref),
      ),
      Text(song.tag.songAuthor),
    ],
  );
}

Widget addSongBlock(ref, playlist, index) => Container(
      margin: const EdgeInsets.only(
          left: kDefaultPadding, right: kDefaultPadding, bottom: kSmallPadding),
      child: GestureDetector(
        onTap: () {
          loadNewSong(ref, songArray, index);
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kDefaultBorderRadius),
            color: currentThemeHeader(ref),
          ),
          padding: const EdgeInsets.only(top: 9, bottom:9),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text((songArray[index] as UriAudioSource).tag.songName),
                      Text(
                        (songArray[index] as UriAudioSource).tag.songAuthor,
                        textScaler: const TextScaler.linear(0.6),
                      ),
                    ]),
              ),
              Text((songArray[index] as UriAudioSource)
                  .tag
                  .songDurationString),
              listCheckbox(playlist, songArray[index], ref),
            ],
          ),
        ),
      ),
    );
