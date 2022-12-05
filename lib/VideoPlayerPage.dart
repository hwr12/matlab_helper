import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerPage extends StatefulWidget {
  const VideoPlayerPage({Key? key}) : super(key: key);

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;
  late ChewieController chewieController;

  late VideoPlayerController _controller2;
  late ChewieController chewieController2;

  late VideoPlayerController _controller3;
  late ChewieController chewieController3;
  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('assets/goodgun1.mp4');
    _controller.setPlaybackSpeed(3);
    _controller.initialize();
    chewieController = ChewieController(
      aspectRatio: 1.3333,
      videoPlayerController: _controller,
      autoPlay: true,
      looping: true,
      hideControlsTimer: const Duration(seconds: 1),
    );

    _controller2 = VideoPlayerController.asset('assets/goodgun2.mp4');
    _controller2.setPlaybackSpeed(3);
    _controller2.initialize();
    chewieController2 = ChewieController(
      aspectRatio: 1.3333,
      videoPlayerController: _controller2,
      autoPlay: true,
      looping: true,
      hideControlsTimer: const Duration(seconds: 1),
    );

    _controller3 = VideoPlayerController.asset('assets/goodgun3.mp4');
    _controller3.setPlaybackSpeed(3);
    _controller3.initialize();
    chewieController3 = ChewieController(
      aspectRatio: 1.3333,
      videoPlayerController: _controller3,
      autoPlay: true,
      looping: true,
      hideControlsTimer: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    chewieController.dispose();
    _controller2.dispose();
    chewieController2.dispose();
    _controller3.dispose();
    chewieController3.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 20.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 400,
                  width: 400 * 1.3333,
                  padding: const EdgeInsets.all(20),
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Chewie(
                          controller: chewieController,
                        ),
                        //_ControlsOverlay(controller: _controller),
                        VideoProgressIndicator(
                          _controller,
                          allowScrubbing: true,
                          colors: const VideoProgressColors(
                            playedColor: Colors.blue,
                            bufferedColor: Colors.grey,
                            backgroundColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 400,
                  width: 400 * 1.3333,
                  padding: const EdgeInsets.all(20),
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Chewie(
                          controller: chewieController2,
                        ),
                        //_ControlsOverlay(controller: _controller),
                        VideoProgressIndicator(
                          _controller,
                          allowScrubbing: true,
                          colors: const VideoProgressColors(
                            playedColor: Colors.blue,
                            bufferedColor: Colors.grey,
                            backgroundColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 400,
                  width: 400 * 1.3333,
                  padding: const EdgeInsets.all(20),
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: <Widget>[
                        Chewie(
                          controller: chewieController3,
                        ),
                        //_ControlsOverlay(controller: _controller),
                        VideoProgressIndicator(
                          _controller,
                          allowScrubbing: true,
                          colors: const VideoProgressColors(
                            playedColor: Colors.blue,
                            bufferedColor: Colors.grey,
                            backgroundColor: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text(
                  'max: 308.16K',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'max: 305.93K',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'max: 307.93K ',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text(
                  'mean: 290.84K',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'mean: 290.87K',
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  'mean: 290.88K',
                  style: TextStyle(fontSize: 20),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                Text(
                  'accumulated standard deviation: 148.22',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'accumulated standard deviation: 148.26',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  'accumulated standard deviation: 148.18',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  static const List<Duration> _exampleCaptionOffsets = <Duration>[
    Duration(seconds: -10),
    Duration(seconds: -3),
    Duration(seconds: -1, milliseconds: -500),
    Duration(milliseconds: -250),
    Duration.zero,
    Duration(milliseconds: 250),
    Duration(seconds: 1, milliseconds: 500),
    Duration(seconds: 3),
    Duration(seconds: 10),
  ];
  static const List<double> _examplePlaybackRates = <double>[
    0.25,
    0.5,
    1.0,
    1.5,
    2.0,
    3.0,
    5.0,
    10.0,
  ];

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 50),
          reverseDuration: const Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? const SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: const Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                      semanticLabel: 'Play',
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
        Align(
          alignment: Alignment.topLeft,
          child: PopupMenuButton<Duration>(
            initialValue: controller.value.captionOffset,
            tooltip: 'Caption Offset',
            onSelected: (Duration delay) {
              controller.setCaptionOffset(delay);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<Duration>>[
                for (final Duration offsetDuration in _exampleCaptionOffsets)
                  PopupMenuItem<Duration>(
                    value: offsetDuration,
                    child: Text('${offsetDuration.inMilliseconds}ms'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.captionOffset.inMilliseconds}ms'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: PopupMenuButton<double>(
            initialValue: controller.value.playbackSpeed,
            tooltip: 'Playback speed',
            onSelected: (double speed) {
              controller.setPlaybackSpeed(speed);
            },
            itemBuilder: (BuildContext context) {
              return <PopupMenuItem<double>>[
                for (final double speed in _examplePlaybackRates)
                  PopupMenuItem<double>(
                    value: speed,
                    child: Text('${speed}x'),
                  )
              ];
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                // Using less vertical padding as the text is also longer
                // horizontally, so it feels like it would need more spacing
                // horizontally (matching the aspect ratio of the video).
                vertical: 12,
                horizontal: 16,
              ),
              child: Text('${controller.value.playbackSpeed}x'),
            ),
          ),
        ),
      ],
    );
  }
}
