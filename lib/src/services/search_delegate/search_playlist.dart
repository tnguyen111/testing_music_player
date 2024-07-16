import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../ui/components/components.dart';
import '../../models/models.dart';

class PlaylistSearch extends SearchDelegate {
  final WidgetRef ref;

  PlaylistSearch(this.ref);

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
    final List<Playlist> suggestionList = query.isEmpty
        ? []
        : playlistArray
        .where(
          (p) => p.playlistName.toLowerCase().contains(
        query.toLowerCase(),
      ),
    )
        .toList();
    return suggestionPlaylistWidget(ref, suggestionList);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<Playlist> suggestionList = query.isEmpty
        ? playlistArray.getRange(1, playlistArray.length).toList()
        : playlistArray
        .where(
          (p) => p.playlistName.toLowerCase().contains(
        query.toLowerCase(),
      ),
    )
        .toList();
    return suggestionPlaylistWidget(ref, suggestionList);
  }
}
