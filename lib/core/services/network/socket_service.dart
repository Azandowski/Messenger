import 'package:flutter/foundation.dart';
import 'package:laravel_echo/laravel_echo.dart';
import 'package:messenger_mobile/core/config/auth_config.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


class SocketService {
  
  final AuthConfig authConfig;
  
  IO.Socket socket;
  Echo echo;

  SocketService({
    @required this.authConfig
  }) {
    
    // MARK: - Init

    Map headers = { 'Authorization': 'Bearer ${authConfig.token}' };

    socket = IO.io('https://aio-test-vps.kulenkov-group.kz:6002',
      IO.OptionBuilder().setExtraHeaders(headers)
        .setTransports(['websocket']).build());
      
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
    return 'laravel_database_messages..$id';
  } 
}