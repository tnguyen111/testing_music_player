import 'package:just_audio/just_audio.dart';
import 'models.dart';

final player = AudioPlayer();

void playSong() async{
  
  final duration = await player.setUrl('https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3');
  await player.play();
}