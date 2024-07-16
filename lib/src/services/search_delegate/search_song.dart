import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ui/components/components.dart';
import '../../models/models.dart';

class PlaylistSongSearch extends SearchDelegate {
  final WidgetRef ref;
  final Playlist playlist;

  PlaylistSongSearch(this.ref, this.playlist);

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
    final List<String> suggestionList = query.isEmpty
        ? []
        : playlist.songNameList
            .where(
              (p) => p.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();
    return suggestionListWidget(ref, suggestionList);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<String> suggestionList = query.isEmpty
        ? playlist.songNameList
        : playlist.songNameList
            .where(
              (p) => p.toLowerCase().contains(
                    query.toLowerCase(),
                  ),
            )
            .toList();
    return suggestionListWidget(ref, suggestionList);
  }
}
