import 'dart:io';
import 'package:flutter/material.dart';
import '../../models/content/content.dart';
import 'package:video_player/video_player.dart';

class Video extends StatefulWidget {
  final Content content;

  Video(this.content);

  @override
  State createState() => _VideoState();
}

class _VideoState extends State<Video> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _loadVideoPlayer();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Initiliazes video player and related listeners
  void _loadVideoPlayer() {
    widget.content.isLocal()
        ? _controller = VideoPlayerController.file(
            File(widget.content.localPath!),
          )
        : _controller = VideoPlayerController.network(widget.content.path);

    _controller.addListener(() {
      setState(() {});
    });

    _controller.initialize().then((value) {
      setState(() {});
    });
  }

  void _play() {
    print('playing now');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          VideoPlayer(_controller),
        ],
      ),
    );
  }

  Widget _buildVideo() {
    return Stack(
      children: <Widget>[
        Center(
          child: IconButton(
            icon: Icon(Icons.play_arrow),
            onPressed: () => _play(),
          ),
        )
      ],
    );
  }
}
