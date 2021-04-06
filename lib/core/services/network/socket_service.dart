import 'package:flutter/foundation.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../config/auth_config.dart';


class SocketService {
  
  final AuthConfig authConfig;
  
  IO.Socket socket;
  Echo echo;

  SocketService({
    @required this.authConfig
  });

  void init () {
    Map headers = { 'Authorization': 'Bearer ${authConfig.token}' };

    socket = IO.io('https://api.aiocorp.kz:6001',
      IO.OptionBuilder().setExtraHeaders(new Map<String, dynamic>.from(headers))
        .setTransports(['websocket']).build());

    socket.connect();

    socket.onConnect((data) {});

    echo = new Echo({
      'broadcaster': 'socket.io',
      'client': socket,
      'auth': {
        'headers': headers
      }
    });
    
    echo.connect();
  }
}


abstract class SocketChannels {
  /// New changes in chat room 
  /// [id] - id of the chat
  static String getChatByID (int id) {
    return 'messages.$id';
  } 

  static String getChatsUpdates (int id) {
    return 'get.index.$id';
  }

  static String getChatDeleteById (int id) {
    return 'deleted.message.$id';
  } 
}