
import 'package:flutter/material.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/modules/chat/domain/entities/chat_detailed.dart';

class ChatDetailHeader extends StatelessWidget {
  
  final ChatDetailed chatDetailed;
  
  ChatDetailHeader({
    @required this.chatDetailed,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Column(
            children: [
              Image(
                image: chatDetailed?.chat?.imageUrl == null ? AssetImage('assets/images/placeholder.png') : 
                  NetworkImage(chatDetailed?.chat?.imageUrl),
                width: MediaQuery.of(context).size.width,
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
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Чат Алматы для общения жителей города',
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
                    'Это описание группы, которое могут видеть',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
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