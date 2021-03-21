
import 'package:flutter/material.dart';
import 'package:messenger_mobile/modules/category/data/models/chat_view_model.dart';
import 'package:messenger_mobile/modules/profile/domain/entities/user.dart';
import '../../../../../app/appTheme.dart';
import '../../../domain/entities/chat_detailed.dart';


enum CommunicationType { chat, audio, video,  }

extension CommunicationTypeUIExtension on CommunicationType {
  IconData get icon {
    switch (this) {
      case CommunicationType.chat:
        return Icons.chat;
      case CommunicationType.audio:
        return Icons.call;
      default:
        return Icons.video_call;
    }
  }
}

class ChatDetailHeader extends StatelessWidget {
  
  final ChatDetailed chatDetailed;
  final Function(CommunicationType) onCommunicationHandle;
  
  ChatDetailHeader({
    @required this.chatDetailed,
    @required this.onCommunicationHandle,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ChatViewModel chatViewModel = ChatViewModel(chatDetailed?.chat);
    List<CommunicationType> communicationTypes = chatDetailed.user != null ? 
      [CommunicationType.chat, CommunicationType.audio, CommunicationType.video] : CommunicationType.values;

    return Container(
      child: Stack(
        children: [
          Column(
            children: [
              FadeInImage(
                placeholder: AssetImage("assets/images/logo.png"),
                image: chatDetailed?.chat?.imageUrl == null || chatDetailed?.user?.profileImage == null ? 
                  AssetImage(
                    'assets/images/placeholder.png', 
                  ) : NetworkImage(chatDetailed?.user?.profileImage ?? chatViewModel?.imageURL),
                height: 286,
                fit: BoxFit.cover,
              ),
              Container(
                height: 115, 
                color: Colors.grey[200],
              )
            ],
          ),
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.all(16),
              width: MediaQuery.of(context).size.width - 32,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          chatDetailed?.user?.name ?? chatViewModel.title,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            height: 1.8
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('в сети'),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: communicationTypes.map(
                                (e) => IconButton(
                                  onPressed: () {
                                    onCommunicationHandle(e);
                                  },
                                  icon: Icon(e.icon, color: AppColors.indicatorColor)
                                )
                              ).toList(),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Divider(),
                  Text(
                    chatViewModel.description,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.left,
                  )
                ],
              )
            )
          )
        ],
      )
    );
  }
}