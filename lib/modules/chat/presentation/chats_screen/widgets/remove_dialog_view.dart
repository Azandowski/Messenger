import 'package:flutter/material.dart';

import '../../../../../core/widgets/independent/dialogs/dialog_action_button.dart';
import '../../../../../core/widgets/independent/dialogs/dialog_params.dart';
import '../../../../../core/widgets/independent/dialogs/dialogs.dart';
import 'package:easy_localization/easy_localization.dart';

class DeleteDialogView extends StatelessWidget {
  final Function(bool) onDelete;

  const DeleteDialogView({
    Key key,
    @required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int currentIndex;
    return DialogsView(
      dialogViewType: DialogViewType.optionSelector,
      title: 'remove_selected_messages'.tr() + " ?",
      optionsContainer: DialogOptionsContainer(
        options: [
          'only_for_me'.tr(), 
          'for_all'.tr()
        ], 
        currentOptionIndex: null, 
        onPress: (newIndex) {
          currentIndex = newIndex;
        }
      ),
      actionButton: [
        DialogActionButton(
          buttonStyle: DialogActionButtonStyle.cancel,
          title: 'cancel'.tr(),
          onPress: () {
            Navigator.of(context).pop();
          }
        ),
        DialogActionButton(
          buttonStyle: DialogActionButtonStyle.dangerous,
          title: 'delete'.tr(),
          onPress: () {
            if(currentIndex != null){
              Navigator.pop(context);
              onDelete(false);
            }
          }
        )
      ]
    );
  }
}
