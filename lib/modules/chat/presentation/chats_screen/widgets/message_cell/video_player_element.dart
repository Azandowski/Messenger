
import 'dart:io';
import 'dart:ui';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoPlayerElement extends StatefulWidget {
  final url;

  const VideoPlayerElement({Key key,@required this.url}) : super(key: key);
  @override
  _VideoPlayerElementState createState() => _VideoPlayerElementState();
}

class _VideoPlayerElementState extends State<VideoPlayerElement> {

  ChewieController _chewieController;
  VideoPlayerController _videoPlayerController;

  Future<void> initializePlayer() async {
     _videoPlayerController = VideoPlayerController.network(widget.url);

    await Future.wait([
      _videoPlayerController.initialize(),
    ]);

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      allowMuting: true,
      fullScreenByDefault: true,
      showControls: true,
      autoInitialize: true,
      // Try playing around with some of these other options:

      // showControls: false,
      // materialProgressColors: ChewieProgressColors(
      //   playedColor: Colors.red,
      //   handleColor: Colors.blue,
      //   backgroundColor: Colors.grey,
      //   bufferedColor: Colors.lightGreen,
      // ),
      // placeholder: Container(
      //   color: Colors.grey,
      // ),
      // autoInitialize: true,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
    _chewieController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
          color: Colors.white,),
          onPressed: ()=> Navigator.pop(context),
        ),
      ),
      backgroundColor: Colors.black,
      body: _chewieController != null &&_chewieController.videoPlayerController.value.isInitialized
        ? SafeArea(
            child: Container(
              child: Chewie(
                controller: _chewieController,
              ),
          ),
        )
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('Loading'),
            ],
          ),
    );
  }
}

class PreviewVideo extends StatefulWidget {
  final String url;
  final Widget centerWidget;
  PreviewVideo({
    @required this.url,
    @required this.centerWidget,
  });

  @override
  _PreviewVideoState createState() => _PreviewVideoState();
}

class _PreviewVideoState extends State<PreviewVideo> with AutomaticKeepAliveClientMixin {
  var bytes;
  var screenWidth = window.physicalSize.width / window.devicePixelRatio;
  String tempPath;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant PreviewVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // if (oldWidget.url != widget.url) {
    //   print(oldWidget.url);
    //   print(widget.url);
    //   initThumnail();
    // }
  }

  @override
  void initState() {
    super.initState();
    if (widget.url != null) {
      initThumnail();
    }
  }
  
  initThumnail() async {
    var _tempPath = (await getTemporaryDirectory()).path;
    setState(() {
      tempPath = _tempPath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: widget.url != null && tempPath != null ? Stack(
        alignment: Alignment.center,
        children: [
          FutureBuilder(
            future: VideoThumbnail.thumbnailFile(
              video: widget.url,
              thumbnailPath: tempPath,
              maxWidth: ((screenWidth - 32) * 0.55).floor(), // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
              quality: 60,
            ),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                final file = File(snapshot.data);

                return Image(
                  image: MemoryImage(file.readAsBytesSync()),
                  fit: BoxFit.cover,
                  height: 200,
                );
              } else {
                return Container();
              }
            }
          ),
         widget.centerWidget,
        ],
      ) : 
      SizedBox(
        width: ((screenWidth - 32) * 0.55),
        height: 200,
          child: Container(
            color: Colors.blue
          )
      )
    );
  }

  @override
  bool get wantKeepAlive => true;
}