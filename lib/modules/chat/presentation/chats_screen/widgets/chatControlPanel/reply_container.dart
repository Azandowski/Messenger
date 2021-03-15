
import 'package:flutter/material.dart';

import '../../../../../../app/appTheme.dart';
import 'cubit/panel_bloc_cubit.dart';

class ReplyContainer extends StatelessWidget {
  final PanelBlocCubit cubit;
  const ReplyContainer({
    Key key,
    @required this.cubit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var messageVM = (cubit.state as PanelBlocReplyMessage).messageViewModel;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 16, bottom: 8, top: 8),
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
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
                      messageVM.isMine ? 'Вы' : 
                      messageVM.userNameText,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                        color: messageVM.color,
                      ),
                    ),
                    Container(
                      child: Text(messageVM.messageText,
                        style: AppFontStyles.black14w400.copyWith(
                          height: 1.4,
                        ),
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                        maxLines: 1,
                      ),
                    ),
                ],
          ),
            ),
          IconButton(icon: Icon(Icons.close), onPressed: (){
            cubit.detachMessage();
          })
      ],
    ),
  ),
  );
  }
}