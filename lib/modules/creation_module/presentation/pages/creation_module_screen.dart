import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:messenger_mobile/app/appTheme.dart';
import 'package:messenger_mobile/core/widgets/independent/small_widgets/cell_skeleton_item.dart';
import 'package:messenger_mobile/core/widgets/independent/small_widgets/chat_count_view.dart';
import 'package:messenger_mobile/modules/creation_module/data/models/contact_model.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/helpers/creation_actions.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/widgets/actions_builder.dart';
import 'package:messenger_mobile/modules/creation_module/presentation/widgets/contact_cell.dart';

class CreationModuleScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Создать',
          style: AppFontStyles.headingTextSyle,
        ),
      ),
      body: ListView.separated(
        itemBuilder: (context, int index) {
          if (index == 0) {
            return ActionsContainer(
              onTap: (CreationActions action) async {
                if (action == CreationActions.inviteFriends) {
                  await FlutterShare.share(
                    title: 'AIO Messenger',
                    text: 'Хэй, поскорее скачай мессенджер AIO!',
                    linkUrl: 'https://messengeraio.page.link/invite'
                  );
                }
                print('Click $action');
              },
            );
          } else if (index == 1) {
            return CellHeaderView(title: 'Ваши контакты');
          } else {
            return ContactCell(contactItem: ContactModel.fromJson({}));
            // CellShimmerItem(circleSize: 35,);
          }
        }, 
        separatorBuilder: (context, int index) {
          if (index > 1) {
            return Divider();
          } else {
            return Container();
          }
        }, itemCount: 10
      ),
    );
  }


  // * * Route 
  
  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => CreationModuleScreen());
  }
}