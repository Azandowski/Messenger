import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chat/data/models/message_view_model.dart';
import 'package:messenger_mobile/modules/chat/presentation/chats_screen/helpers/messageCellAction.dart';

import '../../../../variables.dart';

void main() {
  group('MessageViewModel with text', () {
    final tMessageViewModel = MessageViewModel(tMessage);
    test('should return expected list when replyMode is enabled', () {
      final List<MessageCellActions> expected = [
        MessageCellActions.copyMessage,
        MessageCellActions.attachMessage,
        MessageCellActions.replyMessage,
        MessageCellActions.replyMore,
        MessageCellActions.openProfile,
        MessageCellActions.deleteMessage,
        MessageCellActions.translateMessage,
      ];
      final actual = tMessageViewModel.getActionsList(isReplyEnabled: true);
      expect(actual, equals(expected));
    });
    test('should return expected list when replyMode is disabled', () {
      final List<MessageCellActions> expected = [
        MessageCellActions.copyMessage,
        MessageCellActions.attachMessage,
        MessageCellActions.openProfile,
        MessageCellActions.deleteMessage,
        MessageCellActions.translateMessage,
      ];
      final actual = tMessageViewModel.getActionsList(isReplyEnabled: false);
      expect(actual, equals(expected));
    });
  });

  group('MessageViewModel with empty text', () {
    final tMessageViewModel = MessageViewModel(tMessageWithNoText);
    test('should return expected list when replyMode is enabled', () {
      final List<MessageCellActions> expected = [
        MessageCellActions.attachMessage,
        MessageCellActions.replyMessage,
        MessageCellActions.replyMore,
        MessageCellActions.openProfile,
        MessageCellActions.deleteMessage,
      ];
      final actual = tMessageViewModel.getActionsList(isReplyEnabled: true);
      expect(actual, equals(expected));
    });
    test('should return expected list when replyMode is disabled', () {
      final List<MessageCellActions> expected = [
        MessageCellActions.attachMessage,
        MessageCellActions.openProfile,
        MessageCellActions.deleteMessage,
      ];
      final actual = tMessageViewModel.getActionsList(isReplyEnabled: false);
      expect(actual, equals(expected));
    });
  });
}
