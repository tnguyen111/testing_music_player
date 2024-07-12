import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testing_music_player/src/services/services.dart';
import '../../models/models.dart';
import '../../ui/ui.dart';

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
    final SongDetails? song;
    song = await isar.songDetails.filter().songNameEqualTo(name).findFirst();
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

  Future<void> savePlaylistList(List<Playlist> playlistList) async{
    final isar = await db;
    await isar.writeTxn(() => isar.playlists.clear());
    playlistArray.clear();
    isar.writeTxnSync<List<int>>(() => isar.playlists.putAllSync(playlistList));
  }

  Future<void> saveSongList(List<SongDetails> songList) async{
    final isar = await db;
    await isar.writeTxn(() => isar.songDetails.clear());
    isar.writeTxnSync<List<int>>(() => isar.songDetails.putAllSync(songList));
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

  Future<void> sortPlaylist(WidgetRef ref) async {
    final isar = await db;
    List<Playlist> newPlaylist = await isar.playlists.where().sortByPlaylistName().findAll();
    for(int i = 0; i < newPlaylist.length; i++){
      newPlaylist[i].id = i;
    }
    await savePlaylistList(newPlaylist);
    await setPlaylistList(ref);
  }

  Future<void> sortSongList(WidgetRef ref) async {
    final isar = await db;
    List<SongDetails> newSongList =  await isar.songDetails.where().sortBySongName().findAll();
    for(int i = 0; i < newSongList.length; i++){
      newSongList[i].id = i;
    }

    await saveSongList(newSongList);

    Playlist? playlist = await getPlaylistFor('');
    await sortingPlaylist(playlist!);
    await savePlaylist(playlist);
    songArray = playlist.songList;
    return;
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
    playlistArray = await getAllPlaylist();
    for(int i = 0; i < playlistArray.length; i++){
      for(int j = 0; j < playlistArray[i].songNameList.length; j++){
        var existingSong = await IsarHelper().getSongFor(playlistArray[i].songNameList[j]);
        playlistArray[i].setAudioSource(existingSong!);
      }
    }
    playlistSwitchState(ref);
    return true;
  }

  Future<bool> setSongList() async {
    if(!await IsarHelper().playlistExisted('')) {
      savePlaylist(
          Playlist(playlistName_: '', imagePath_: '', songNameList_: []));
    }
    Playlist? playlist = await getPlaylistFor('');
    playlist?.songNameList.clear();
    final songList = await getSongList();
    for (int i = 0; i < songList.length; i++) {
      MediaItem newMediaItem = songList[i].toMediaItem();
      AudioSource newSong =
          AudioSource.uri(Uri.parse(songList[i].songPath), tag: newMediaItem);
      songArray.add(newSong);
      if(playlist!.songNameList.length < songList.length){
        playlist.songNameList.add(newMediaItem.title);
        savePlaylist(playlist);
      }
    }
    playlist?.songList_ = songArray;
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
