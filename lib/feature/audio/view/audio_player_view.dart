import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioPlayerView extends StatefulWidget {
  const AudioPlayerView({super.key});

  @override
  State<AudioPlayerView> createState() => _AudioPlayerViewState();
}

class _AudioPlayerViewState extends State<AudioPlayerView> {
  AudioPlayer audioPlayer = AudioPlayer();
  String url = "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3";
  String songTitle = "Super Shy";
  String artist = "New Jeans";
  PlayerState playerState = PlayerState.paused;
  int timeProgress = 0;
  int audioDuration = 0;

  Widget slider() {
    return Container(
      width: 350,
      child: Slider.adaptive(
        activeColor: Colors.green,
        value: (timeProgress / 1000).floorToDouble(),
        max: (audioDuration / 1000).floorToDouble(),
        onChanged: (value) {
          seekToSec(value.toInt());
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    audioPlayer.onPlayerStateChanged.listen((PlayerState s) {
      setState(() {
        playerState = s;
      });
    });

    audioPlayer.setSourceUrl(url);
    audioPlayer.onDurationChanged.listen((Duration d) {
      setState(() {
        audioDuration = d.inMilliseconds;
      });
    });

    audioPlayer.onPositionChanged.listen((Duration d) {
      setState(() {
        timeProgress = d.inMilliseconds;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    audioPlayer.release();
    audioPlayer.dispose();
  }

  // Play audio
  onPlay() async {
    await audioPlayer.play(UrlSource(url));
  }

  // Pause audio
  onPause() async {
    await audioPlayer.pause();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/core/resources/images/bg.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          children: [
             SizedBox(height: 60),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 20),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 80, 101, 131),
                  ),
                  child: Icon(
                    Icons.arrow_circle_left_outlined,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 10),
                Text("Sound",
                    style: TextStyle(fontSize: 30, color: Colors.white))
              ],
            ),

            SizedBox(
              height: 30
            ),
            Text(
              songTitle,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 70),
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image:
                          AssetImage('lib/core/resources/images/newjean.jpg'),
                      fit: BoxFit.cover)),
            ),
      
            slider(),
             Container(
              width: 300,
               child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text(
                        getTimeString(timeProgress),
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                    getTimeString(audioDuration),
                    style: TextStyle(color: Colors.white),
                  ),
                 ],
               ),
             ),
                 
            SizedBox(height: 20),
            // Play/Pause Button
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                  IconButton(onPressed: (){},
                 icon: Icon(Icons.square, color: Colors.white), iconSize: 30.0,),
                IconButton(onPressed: (){},
                 icon: Icon(Icons.skip_previous,color: Colors.white), iconSize: 30.0,),
                IconButton(
                  onPressed: () {
                    playerState == PlayerState.playing ? onPause() : onPlay();
                  },
                  icon: Icon(
                    playerState == PlayerState.playing
                        ? Icons.pause
                        : Icons.play_arrow,
                  ),
                  iconSize: 50.0,
                  color: Colors.white,
                ),
                             IconButton(onPressed: (){},
                 icon: Icon(Icons.skip_next, color: Colors.white), iconSize: 30.0,),
                   IconButton(onPressed: (){},
                 icon: Icon(Icons.favorite_border_outlined, color: Colors.white), iconSize: 30.0,),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getTimeString(int milliSeconds) {
    String minutes =
        "${(milliSeconds / 60000).floor() < 10 ? 0 : ''} ${(milliSeconds / 60000).floor()}";
    String seconds =
        "${(milliSeconds / 1000).floor() % 60 < 10 ? 0 : ''} ${(milliSeconds / 1000).floor() % 60}";

    return "$minutes:$seconds";
  }

  void seekToSec(int sec) {
    Duration newPosition = Duration(seconds: sec);
    audioPlayer.seek(newPosition);
  }
}
