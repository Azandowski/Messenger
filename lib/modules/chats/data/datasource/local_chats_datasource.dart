import 'dart:async';

import 'package:sembast/sembast.dart';

import '../../../../core/services/localdb/app_database.dart';
import '../../../category/data/models/chat_entity_model.dart';
import '../../../category/domain/entities/chat_entity.dart';

abstract class LocalChatsDataSource {
  Future<List<ChatEntity>> getCategoryChats (int categoryID);
  Future<void> setCategoryChats (List<ChatEntity> chats);
  Future<void> resetAll ();
}


class LocalChatsDataSourceImpl implements LocalChatsDataSource {
  Future<Database> get _localDb async => await AppDatabase.instance.database;
  final _chatsFolder = intMapStoreFactory.store('chats');

  Future<List<ChatEntity>> getCategoryChats (int categoryID) async {
    Finder finder = Finder(sortOrders: [
      SortOrder('last_message.id', false, false)
    ]);
    
    if (categoryID != null) {
      finder.filter = Filter.equals('category_chat.id', categoryID);
    }

    
    List<RecordSnapshot> data = await _chatsFolder.find(
      await _localDb, 
      finder: finder,
    );
    
    return data.map((e) => ChatEntityModel.fromJson(e.value)).toList();
  }

  Future<void> setCategoryChats (List<ChatEntity> chats) async {
    var chatSaveJobs = <Future>[];
    
    chats.forEach((chat) async { 
      var chatBodyJSON = chat is ChatEntityModel ? chat.toJson() :
        ChatEntityModel(
          chatId: chat.chatId,
          chatCategory: chat.chatCategory,
          title: chat.title,
          imageUrl: chat.imageUrl,
          date: chat.date,
          permissions: chat.permissions,
          lastMessage: chat.lastMessage,
          unreadCount: chat.unreadCount,
          description: chat.description,
          isPrivate: chat.isPrivate,
          isRead: chat.isRead,
          chatUpdateType: chat.chatUpdateType,
          adminID: chat.adminID
        ).toJson();
      
      chatSaveJobs.add(_chatsFolder.record(chat.chatId).put(await _localDb, new Map<String, dynamic>.from(
        chatBodyJSON
      )));
    });
    
    return Future.wait(chatSaveJobs);
  }

  @override
  Future<void> resetAll() async {
    _chatsFolder.delete(await _localDb);
  }
}