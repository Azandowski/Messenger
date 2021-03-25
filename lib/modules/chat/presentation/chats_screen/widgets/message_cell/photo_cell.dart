import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class PreviewPhotoWidget extends StatelessWidget {
  const PreviewPhotoWidget({
    Key key,
    @required this.a,
    @required this.url,
  }) : super(key: key);

  final double a;
  final url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: CachedNetworkImage(
        fadeInDuration: const Duration(milliseconds: 400),
        filterQuality: FilterQuality.low,
        imageUrl: url,
        width: a,
        height: a,
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
    );
  }
}


class PreviewPhotoLarge extends StatelessWidget {
  const PreviewPhotoLarge({
    Key key,
    @required this.url,
  }) : super(key: key);

  final url;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CachedNetworkImage(
            fadeInDuration: const Duration(milliseconds: 400),
            filterQuality: FilterQuality.low,
            imageUrl: url,
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
}

class PreviewMorePhoto extends StatelessWidget {
  const PreviewMorePhoto({
    Key key,
    @required this.url,
    @required this.moreCount,
    @required this.a,
    @required this.onMore,
  }) : super(key: key);

  final url;
  final double a;
  final onMore;
  final int moreCount;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
        child: Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onTap: onMore,
              child: ClipRRect(
               borderRadius: BorderRadius.circular(10),
               child: CachedNetworkImage(
                 fadeInDuration: const Duration(milliseconds: 400),
                 filterQuality: FilterQuality.low,
                 imageUrl: url,
                 width: a,
                 colorBlendMode: BlendMode.darken,
                 color: Colors.black54,
                 height: a,
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
            Text(
              '+$moreCount',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 24,
                color: Colors.white
              ),
            )
          ],
        ),
    );
  }
}