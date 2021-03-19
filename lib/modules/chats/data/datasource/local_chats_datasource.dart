import '../../../../core/services/localdb/app_database.dart';
import '../../../category/data/models/chat_entity_model.dart';
import '../../../category/domain/entities/chat_entity.dart';
import 'package:sembast/sembast.dart';
import 'dart:async';

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
      chatSaveJobs.add(_chatsFolder.record(chat.chatId).put(await _localDb, new Map<String, dynamic>.from(chat.toJson())));
    });
    
    return Future.wait(chatSaveJobs);
  }

  @override
  Future<void> resetAll() async {
    _chatsFolder.delete(await _localDb);
  }
}