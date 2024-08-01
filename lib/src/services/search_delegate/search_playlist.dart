import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../ui/components/components.dart';
import '../../models/models.dart';

bool seeMorePlaylist = false;
bool seeMoreSong = false;
bool noSeeMorePlaylist = false;
bool noSeeMoreSong = false;

class MainSearch extends SearchDelegate {
  final WidgetRef ref;

  MainSearch(this.ref) {
    seeMorePlaylist = false;
    seeMoreSong = false;
    noSeeMorePlaylist = false;
    noSeeMoreSong = false;
  }

  @override
  TextStyle? get searchFieldStyle => searchFieldTextStyle(ref);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Playlist> playlistSearchList = playlistArray
        .where(
          (p) => p.playlistName.toLowerCase().contains(
                query.toLowerCase(),
              ),
        )
        .toList();
    List<String> songListSearchList = playlistArray[0]
        .songNameList
        .where(
          (p) =>
              p.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
              ((playlistArray[0]
                          .songList[playlistArray[0].songNameList.indexOf(p)]
                      as UriAudioSource)
                  .tag
                  .artist
                  .toLowerCase()
                  .contains(
                    query.toLowerCase(),
                  )),
        )
        .toList();
    print(songListSearchList.length);
    int playlistCount = playlistSearchList.length;
    int songCount = songListSearchList.length;
    List<dynamic> totalSearchList = [
      ...playlistSearchList,
      ...songListSearchList
    ];
    final List<dynamic> suggestionList = query.isEmpty ? [] : totalSearchList;
    return suggestionPlaylistWidget(
        ref, suggestionList, query.isEmpty, playlistCount, songCount);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Playlist> playlistSearchList = (query.isEmpty)
        ? playlistArray.getRange(1, playlistArray.length).toList()
        : playlistArray
            .where(
              (p) => p.playlistName.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();
    List<String> songListSearchList = playlistArray[0]
        .songNameList
        .where(
          (p) =>
              p.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ||
              ((playlistArray[0]
                          .songList[playlistArray[0].songNameList.indexOf(p)]
                      as UriAudioSource)
                  .tag
                  .artist
                  .toLowerCase()
                  .contains(
                    query.toLowerCase(),
                  )),
        )
        .toList();
    List<dynamic> totalSearchList = [
      ...playlistSearchList,
      ...songListSearchList
    ];
    int playlistCount = playlistSearchList.length;
    int songCount = songListSearchList.length;
    final List<dynamic> suggestionList =
        query.isEmpty ? totalSearchList : totalSearchList;
    return suggestionPlaylistWidget(
        ref, suggestionList, query.isEmpty, playlistCount, songCount);
  }
}
