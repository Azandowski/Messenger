import 'package:flutter/material.dart';
import '../../../../../core/widgets/independent/dialogs/dialog_action_button.dart';
import '../../../../../core/widgets/independent/dialogs/dialog_params.dart';
import '../../../../../core/widgets/independent/dialogs/dialogs.dart';

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
      title: 'Удалить выбранные сообщения?',
      optionsContainer: DialogOptionsContainer(
        options: ['Только для меня', 'Для всех'], 
        currentOptionIndex: null, 
        onPress: (newIndex) {
          currentIndex = newIndex;
        }
      ),
      actionButton: [
        DialogActionButton(
          buttonStyle: DialogActionButtonStyle.cancel,
          title: 'Отмена',
          onPress: () {
            Navigator.of(context).pop();
          }
        ),
        DialogActionButton(
          buttonStyle: DialogActionButtonStyle.dangerous,
          title: 'Удалить',
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
