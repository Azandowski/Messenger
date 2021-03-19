
import 'package:flutter/material.dart';

import '../../../../../app/appTheme.dart';
import '../../../../category/data/models/chat_view_model.dart';
import '../../../domain/entities/chat_detailed.dart';

class ChatDetailHeader extends StatelessWidget {
  
  final ChatDetailed chatDetailed;
  
  ChatDetailHeader({
    @required this.chatDetailed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    ChatViewModel chatViewModel = ChatViewModel(chatDetailed?.chat);

    return Container(
      child: Stack(
        children: [
          Column(
            children: [
              FadeInImage(
                placeholder: AssetImage("assets/images/logo.png"),
                image: chatDetailed?.chat?.imageUrl == null ? AssetImage(
                  'assets/images/placeholder.png', 
                ) : NetworkImage(chatViewModel.imageURL),
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
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chatViewModel.title,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                            height: 1.8
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('в сети'),
                            SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Icon(Icons.video_call, color: AppColors.indicatorColor,),
                                Icon(Icons.call, color: AppColors.indicatorColor)
                              ],
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