import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_view_model.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoGalleryScreen extends StatefulWidget {

  final MessageViewModel messageViewModel;
  final List<String> urls; 

  const PhotoGalleryScreen({Key key, @required this.messageViewModel, @required this.urls}) : super(key: key);

  static Route route(MessageViewModel messageViewModel, urls) {
    return MaterialPageRoute<void>(builder: (_) => PhotoGalleryScreen(messageViewModel: messageViewModel, urls: urls,));
  }

  @override
  _PhotoGalleryScreenState createState() => _PhotoGalleryScreenState();
}

class _PhotoGalleryScreenState extends State<PhotoGalleryScreen> {

  int _current = 0;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xffFAF9FF),
        title: Column(
          children: [
            Text(widget.messageViewModel.userNameText,style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),),
            SizedBox(height: 4,),
            Text(widget.messageViewModel.fullTime, style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12,
              color: AppColors.greyColor
            ),)
          ],
        ),
        actions: [
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text('${_current+1} из ${widget.urls.length}',
                style: TextStyle(
                  color: AppColors.indicatorColor,
                  fontSize: 16
                ),
              ),
            ),
          ),
        ],
      ),
      backgroundColor: AppColors.pinkBackgroundColor,
      body: Builder(
        builder: (context) {
          return PhotoViewGallery.builder(
            scrollPhysics: const BouncingScrollPhysics(),
            builder: (BuildContext context, int index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: CachedNetworkImageProvider(widget.urls[index]),
                initialScale: PhotoViewComputedScale.contained,
              );
            },
            itemCount: widget.urls.length,
            loadingBuilder: (context, event) => Center(
              child: Container(
                width: 20.0,
                height: 20.0,
                child: CircularProgressIndicator(
                  value: event == null
                      ? 0
                      : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                ),
              ),
            ),
            backgroundDecoration: BoxDecoration(
              color: AppColors.pinkBackgroundColor
            ),
            onPageChanged: (value){
              setState(() {
              _current = value;
              });
            },
          );
        },
      ),
    );
  }
}