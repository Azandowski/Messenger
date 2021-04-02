import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/message_cell/video_player_element.dart';

class PlayVideoButton extends StatelessWidget {
  final url;
  const PlayVideoButton({
    @required this.url,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Icon(
        Icons.play_circle_fill_sharp,
        color: Colors.white,
        size: MediaQuery.of(context).size.width * 0.2,
      ),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => VideoPlayerElement(url: url)));
      },
    );
  }
} 