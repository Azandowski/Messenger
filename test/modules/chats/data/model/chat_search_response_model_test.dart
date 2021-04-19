import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:messenger_mobile/modules/chats/data/model/chat_search_response_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import '../../../../variables.dart';

void main() {
  test(
      'should return valid ChatSearchResponseModel when according json was given',
      () {
    final actual = ChatSearchResponseModel.fromJson(
        jsonDecode(fixture('chat_search_response_model.json')));

    print(actual.messages.paginationData.nextPageUrl ==
        tChatSearchResponseModel.messages.paginationData.nextPageUrl);
    print(actual.messages.paginationData.total ==
        tChatSearchResponseModel.messages.paginationData.total);
    print(actual.messages.paginationData.isFirstPage ==
        tChatSearchResponseModel.messages.paginationData.isFirstPage);

    print(actual.messages.paginationData);
    print(tChatSearchResponseModel.messages.paginationData);

    expect(actual, equals(tChatSearchResponseModel));
  });
}
