import 'dart:typed_data';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:easy_localization/easy_localization.dart';
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
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('loading'.tr()),
          ],
        ),
    );
  }
}

class PreviewVideo extends StatefulWidget {
  final String url;
  final Widget centerWidget;
  final String imageUrl;
  PreviewVideo({
    this.imageUrl,
    @required this.url,
    @required this.centerWidget,
  });

  @override
  _PreviewVideoState createState() => _PreviewVideoState();
}

class _PreviewVideoState extends State<PreviewVideo> with AutomaticKeepAliveClientMixin{
  Uint8List image;
  @override
  void initState() {
    super.initState();
    if(widget.imageUrl == null){
      getLocalTumnail();
    }
  }

  getLocalTumnail() async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: widget.url,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 200, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
      quality: 50,
    );
    setState(() {
      image = uint8list;
    });
  }
  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    return  ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: widget.url != null ? Stack(
        alignment: Alignment.center,
        children: [
          widget.imageUrl == null ? (image != null ? Image.memory(image,) : Container()) : CachedNetworkImage(
            fadeInDuration: const Duration(milliseconds: 400),
            filterQuality: FilterQuality.low,
            imageUrl: widget.imageUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Icon(
              Icons.image,
              color: Colors.white,
            ),
            errorWidget: (context, url, error) => Container(
              width: w/2,
              height: w/1.6,
              color: Colors.black,
            ),
          ),
         widget.centerWidget,
        ],
      ) : 
      SizedBox(
        height: 1,
        width: 1,
      )
    );
  }

  @override
  bool get wantKeepAlive => true;
}