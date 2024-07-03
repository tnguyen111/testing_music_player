import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testing_music_player/src/services/services.dart';
import '../../models/models.dart';

class IsarHelper {
  late Future<Isar> db;

  IsarHelper() {
    db = openDB();
  }

  Future<Playlist?> getPlaylistFor(String name) async {
    final isar = await db;
    final playlist =
        await isar.playlists.filter().playlistName_EqualTo(name).findFirst();

    return playlist;
  }

  Future<SongDetails?> getSongFor(String name) async {
    final isar = await db;
    final song =
        await isar.songDetails.filter().songNameEqualTo(name).findFirst();

    return song;
  }

  Future<bool> playlistExisted(String name) async {
    final isar = await db;
    final playlist =
        await isar.playlists.filter().playlistName_EqualTo(name).findFirst();

    if (playlist == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<bool> songExisted(String name) async {
    final isar = await db;
    final song =
        await isar.songDetails.filter().songNameEqualTo(name).findFirst();

    if (song == null) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> savePlaylist(Playlist newPlaylist) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.playlists.putSync(newPlaylist));
  }

  Future<void> saveSong(SongDetails newSong) async {
    final isar = await db;
    isar.writeTxnSync<int>(() => isar.songDetails.putSync(newSong));
  }

  void deletePlaylistFor(String name) async {
    final isar = await db;
    await isar.writeTxn(
        () => isar.playlists.filter().playlistName_EqualTo(name).deleteFirst());
  }

  Future<void> deleteSongFor(String name) async {
    final isar = await db;
    await isar.writeTxn(
        () => isar.songDetails.filter().songNameEqualTo(name).deleteFirst());
  }

  Future<List<Playlist>> getAllPlaylist() async {
    final isar = await db;
    return await isar.playlists.where().findAll();
  }

  Future<List<SongDetails>> getSongList() async {
    final isar = await db;
    return await isar.songDetails.where().findAll();
  }

  Future<bool> setPlaylistList(WidgetRef ref) async {
    await setSongList();
    playlistArray = await getAllPlaylist();
    playlistSwitchState(ref);
    return true;
  }

  Future<bool> setSongList() async {
    print("hi");
    final songList = await getSongList();
    print("what");
    for (int i = 0; i < songList.length; i++) {
      AudioSource newSong =
          AudioSource.uri(Uri.parse(songList[i].songPath), tag: songList[i]);
      songArray.add(newSong);
    }
    print("hello");
    return true;
  }

  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [PlaylistSchema, SongDetailsSchema],
        inspector: true,
        directory: dir.path,
      );
    }
    return Future.value(Isar.getInstance());
  }
}
