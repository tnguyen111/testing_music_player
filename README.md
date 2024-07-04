# testing_music_player

A Music Player App developed using Flutter with Riverpod as state management system, Isar (Community Version) as database system, and just_audio (Experimenting Version with Waveform visualizer) package to interact with audio files.
This app was made to learn and experiment with Flutter and different packages, systems.

App allows user to:
- Create and edit (playlist's name, image, and songs stored) playlists.
- Add and remove songs by prompting user to input songs' names, authors/singers' names (optional), and audio files (in most audio file formats).
- Interact with songs (play, pause, loop, shuffle, skip).

Notes:
- Microphone Permission required for the application to run properly. If permission is denied, app will automatically close until permission is given.
- Although different audio file types work normally, it is not a guarantee for all audio file types to do so as it is entirely dependent on just_audio package that interacts with the audio files.
- The app runs, yet the code is horrendous and very brute force-ish in many parts.

# Things Learned From Making This App

1. Isar Database
2. CustomPainter
3. StreamBuilder
4. Using just_audio, permission_handler, and path_provider
5. It requires VERY extensive planning to make a large app with elegant codes 
6. Type/Function Alias (Although none was used in this project as it was known, admittedly, too late and far into the project)

# Things Reinforced From Making This App

1. Building Project Structure
2. Making helper and util functions
3. Using Riverpod state management system
4. Creating different app screens/states and navigator
5. Learn more about Flutter and experiment with different widgets 

