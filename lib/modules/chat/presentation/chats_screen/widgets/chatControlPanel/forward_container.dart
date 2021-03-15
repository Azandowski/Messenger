import 'package:flutter/material.dart';
import '../../../../../../app/appTheme.dart';
import '../../../../data/models/message_view_model.dart';

class ForwardContainer extends StatelessWidget {
  final MessageViewModel messageViewModel;

  const ForwardContainer({Key key, @required this.messageViewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                color: AppColors.indicatorColor,
                width: 2,
                height: 55,
              ),
              SizedBox(width: 8,),
              Expanded(
                  child: Column( 
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        messageViewModel.isMine ? 'Вы' : 
                        messageViewModel.userNameText,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          height: 1.4,
                          color: messageViewModel.color,
                        ),
                      ),
                      Container(
                        child: Text(messageViewModel.messageText,
                          style: AppFontStyles.black14w400,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true,
                        ),
                      ),
                  ],
            ),
          ),
        ],
      ),
      ),
    );
  }
}