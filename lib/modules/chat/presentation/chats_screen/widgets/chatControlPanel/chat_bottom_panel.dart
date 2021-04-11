import 'package:messenger_mobile/modules/chat/presentation/chats_screen/pages/chat_screen_import.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/widgets/chatControlPanel/data/chat_bottom_panel_types.dart';

class ChatBottomPanel extends StatelessWidget {
  
  final Function(ChatBottomPanelTypes) didPressOnItem;
  final bool canSendMedia;

  const ChatBottomPanel({
    @required this.didPressOnItem,
    @required this.canSendMedia,
    Key key, 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 12),
            ..._getBody()
          ]
        ),
      ),
    );
  }

  List<Widget> _getBody () {
    List<Widget> widgets = [];
    ChatBottomPanelTypes.values.forEach((type) {
      widgets.add(_buildItem(
        type, isEnabled: 
          canSendMedia || !canSendMedia && !type.isMedia 
      ));
      widgets.add(SizedBox(width: 8));
    });

    return widgets;
  }

  Widget _buildItem (
    ChatBottomPanelTypes e,
    { bool isEnabled }
  ) {
    return InkWell(
      onTap: () {
        if (isEnabled) {
          didPressOnItem(e);
        }
      },
      child: Opacity(
        opacity: isEnabled ? 1 : 0.3,
        child: Container(
          height: 75,
          width: 75,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                e.assetPath,
                width: 55, height: 55,
                fit: BoxFit.cover,                    
              ),
              Spacer(),
              Text(
                e.title,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}