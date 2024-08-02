import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:just_audio/just_audio.dart';
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

  Future<void> savePlaylistList(List<Playlist> playlistList) async {
    final isar = await db;
    await isar.writeTxn(() => isar.playlists.clear());
    isar.writeTxnSync<List<int>>(() => isar.playlists.putAllSync(playlistList));
  }

  Future<void> clearPlaylistList() async {
    final isar = await db;
    await isar.writeTxn(() => isar.playlists.clear());
    isar.writeTxnSync<int>(() => isar.playlists.putSync(playlistArray[0]));
  }

  Future<void> saveSongList(List<SongDetails> songList) async {
    final isar = await db;
    await isar.writeTxn(() => isar.songDetails.clear());
    isar.writeTxnSync<List<int>>(() => isar.songDetails.putAllSync(songList));
  }

  Future<void> editSong(String oldSongName, String newSongName, String newArtist) async {
    final isar = await db;
    SongDetails? editedSong = await isar.songDetails.filter().songNameEqualTo(oldSongName).findFirst();
    editedSong?.songName = newSongName;
    editedSong?.songAuthor = newArtist;
    await saveSong(editedSong!);
    return;
  }

  Future<void> clearSongList() async {
    final isar = await db;
    await isar.writeTxn(() => isar.songDetails.clear());
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

  Future<void> sortPlaylistList(WidgetRef ref) async {
    final isar = await db;
    List<Playlist> newPlaylist =
        await isar.playlists.where().sortByPlaylistName().findAll();
    for (int i = 0; i < newPlaylist.length; i++) {
      newPlaylist[i].id = i;
    }
    playlistArray.sort((a, b) => a.playlistName.compareTo(b.playlistName));
    await savePlaylistList(newPlaylist);
  }

  Future<void> sortSongList(WidgetRef ref, String sortType) async {
    final isar = await db;
    List<SongDetails> newSongList = [];
    if (sortType == 'Sort By Duration') {
      newSongList = await isar.songDetails.where().sortBySongDurationData().findAll();
    } else if (sortType == 'Sort By Artist') {
      newSongList = await isar.songDetails.where().sortBySongAuthor().findAll();
    } else {
      newSongList = await isar.songDetails.where().sortBySongName().findAll();
    }

    for (int i = 0; i < newSongList.length; i++) {
      newSongList[i].id = i;
    }

    await saveSongList(newSongList);

    Playlist? playlist = playlistArray[0];

    await sortingPlaylist(ref, playlist, sortType);

    playlistSwitchState(ref);
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

  Future<bool> setPlaylistList() async {
    playlistArray = await getAllPlaylist();
    for (int i = 0; i < playlistArray.length; i++) {
      setPlaylist(playlistArray[i]);
    }
    return true;
  }

  Future<Playlist> setPlaylist(Playlist playlist) async {
    bool changed = false;
    bool playing = false;
    AudioSource? tempConcar;
    int? tempIndex;
    Duration tempDura = Duration.zero;

    if (playlist.songList != player.audioSource && player.audioSource != null) {
      changed = true;
      playing = player.playing;
      tempConcar = player.audioSource;
      tempIndex = player.currentIndex;
      tempDura = player.position;

      await player.setAudioSource(playlist.songList);
    }

    for (int i = 0; i < playlist.songNameList.length; i++) {
      var existingSong =
      await IsarHelper().getSongFor(playlist.songNameList[i]);
      try {
        await playlist.setAudioSource(existingSong!);
      } on PlayerInterruptedException {
        // do nothing
        print('expected throw');
      }
    }

    if (changed) {
      await player.setAudioSource(tempConcar!,
          initialIndex: tempIndex, initialPosition: tempDura);
      if (playing) player.play();
    }

    return playlist;
  }

  Future<bool> setSongList(WidgetRef ref) async {
    if (!await IsarHelper().playlistExisted('')) {
      savePlaylist(
          Playlist(playlistName_: '', imagePath_: '', songNameList_: []));
    }
    await IsarHelper().setPlaylistList();
    FlutterNativeSplash.remove();
    playlistSwitchState(ref);
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
