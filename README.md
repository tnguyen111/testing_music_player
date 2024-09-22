# testing_music_player

![App Icon](lib/assets/launcher_icon.png)

A Music Player App developed using Flutter with Riverpod as state management system, Isar (Community Version) as database system, and just_audio (Experimenting Version with Waveform visualizer + just_audio_background) package to interact with audio files.
This app was made to learn and experiment with Flutter and different packages, systems.

App allows user to:
- Create and edit (playlist's name, image, and songs stored) playlists.
- Add and remove songs by prompting user to input songs' names, artists' names (optional), and audio files (aac, amr, flac, mp3, mp4, m4a, wav, oog, opus).
- Interact with songs (play, pause, loop, shuffle, skip, drag & drop to change positions in lists).
- Sort playlists by names, and songs (both in main song list and in playlists) by names, artists, and durations.
- Search for playlists and songs by names.
- Play and interact with songs in the background using notification bar.

Notes:
- Microphone Permission required for the application to run properly. If permission is denied, app will automatically close until permission is given.
- Only the stated file formats above are tested and working properly. Changes will needed to be made in lib/src/ui/components/dialog.dart to process/test different formats.
- Song files are saved to the database by file paths in device's storage. Songs will not be played properly if files are deleted. 
- Although much testing was conducted and many bugs were fixed, errors and bugs may still occur, especially when a playlist is interacted with (add, delete, sort, etc. songs) while a different playlist is playing. Errors SHOULDN'T occur for most of the normal usages.
- The app runs, yet the code is horrendous and very brute force-ish in many parts because of the library's capability (2nd revision, this point still stands).

# Things Learned From Making This App

1. Isar Database
2. CustomPainter
3. StreamBuilder
4. Using just_audio, permission_handler, and path_provider
5. It requires VERY extensive planning to make a large app with elegant codes 
6. Type/Function Alias (Although none was used in this project as it was known, admittedly, too late and far into the project)
7. Modify packages and use modified packages from repo urls.
8. SearchDelegate
9. ReorderableListView (For drag & drop function)
10. Sort one list depending on the sorting in another list using map (For different sorting types)


# Things Reinforced From Making This App

1. Building Project Structure
2. Making helper and util functions
3. Using Riverpod state management system
4. Creating different app screens/states and navigator
5. Learn more about Flutter and experiment with different widgets 
