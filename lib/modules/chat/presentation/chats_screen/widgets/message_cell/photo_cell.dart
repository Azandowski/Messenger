import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PreviewPhotoWidget extends StatefulWidget {
  const PreviewPhotoWidget({
    Key key,
    @required this.a,
    @required this.onTap,
    this.isLocal = false,
    @required this.url,
  }) : super(key: key);
  final bool isLocal;
  final double a;
  final Function onTap;
  final url;

  @override
  _PreviewPhotoWidgetState createState() => _PreviewPhotoWidgetState();
}

class _PreviewPhotoWidgetState extends State<PreviewPhotoWidget> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
        child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: widget.isLocal ? Image.memory(
          widget.url,
          fit: BoxFit.cover,
          width: widget.a,
          height: widget.a,
        ) : CachedNetworkImage(
          fadeInDuration: const Duration(milliseconds: 400),
          filterQuality: FilterQuality.low,
          imageUrl: widget.url,
          width: widget.a,
          height: widget.a,
          fit: BoxFit.cover,
          placeholder: (context, url) => Icon(
            Icons.image,
            color: Colors.white,
          ),
          errorWidget: (context, url, error) => Icon(
              Icons.error,
              color: Colors.white,
            ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}


class PreviewPhotoLarge extends StatefulWidget  {
  const PreviewPhotoLarge({
    Key key,
    @required this.url,
    @required this.onTap,
    this.isLocal = false,
  }) : super(key: key);

  final url;
  final Function onTap;
  final isLocal;

  @override
  _PreviewPhotoLargeState createState() => _PreviewPhotoLargeState() ;
}

class _PreviewPhotoLargeState extends State<PreviewPhotoLarge> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
        child: GestureDetector(
          onTap: widget.onTap,
            child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: widget.isLocal ? Image.memory(
              widget.url,
              fit: BoxFit.cover,
            ) : CachedNetworkImage(
              fadeInDuration: const Duration(milliseconds: 400),
              filterQuality: FilterQuality.low,
              imageUrl: widget.url,
              fit: BoxFit.cover,
              placeholder: (context, url) => Icon(
                Icons.image,
                color: Colors.white,
              ),
              errorWidget: (context, url, error) => Icon(
                  Icons.error,
                  color: Colors.white,
                ),
            ),
          ),
        ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class PreviewMorePhoto extends StatefulWidget {
  const PreviewMorePhoto({
    Key key,
    @required this.url,
    @required this.moreCount,
    @required this.a,
    @required this.onMore,
    this.isLocal = false,
  }) : super(key: key);

  final url;
  final double a;
  final onMore;
  final int moreCount;
  final bool isLocal;

  @override
  _PreviewMorePhotoState createState() => _PreviewMorePhotoState();
}

class _PreviewMorePhotoState extends State<PreviewMorePhoto> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
        child: GestureDetector(
          onTap: widget.onMore,
          child: Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
               borderRadius: BorderRadius.circular(10),
               child: widget.isLocal ? Image.memory(
                  widget.url,
                  fit: BoxFit.cover,
                  width: widget.a,
                  colorBlendMode: BlendMode.darken,
                  color: Colors.black54,
                  height: widget.a,
                ) :  CachedNetworkImage(
                  fadeInDuration: const Duration(milliseconds: 400),
                  filterQuality: FilterQuality.low,
                  imageUrl: widget.url,
                  width: widget.a,
                  colorBlendMode: BlendMode.darken,
                  color: Colors.black54,
                  height: widget.a,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Icon(
                    Icons.image,
                    color: Colors.white,
                  ),
                  errorWidget: (context, url, error) => Icon(
                    Icons.error,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                '+${widget.moreCount}',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                  color: Colors.white
                ),
              )
            ],
          ),
        ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}