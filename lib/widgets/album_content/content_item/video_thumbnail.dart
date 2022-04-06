import 'dart:io';

import 'package:cloud_chest/widgets/misc/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../../models/content/content.dart';

class VideoThumbnail extends StatefulWidget {
  final Content content;

  VideoThumbnail(this.content);

  @override
  State createState() => _VideoThumbnailState();
}

class _VideoThumbnailState extends State<VideoThumbnail> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    _initPlayer();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Loads video in
  void _initPlayer() {
    widget.content.isLocal()
        ? _controller = VideoPlayerController.file(
            File(widget.content.localPath!),
          )
        : _controller = VideoPlayerController.network(widget.content.path);
    _controller.initialize().then(
      (value) {
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: !_controller.value.isInitialized
          ? LoadingWidget()
          : VideoPlayer(_controller),
    );
  }
}
