import 'package:healer_therapist/constants/constant.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket _socket;

  // Singleton pattern
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  /// Initialize the socket connection
  void initialize({required String userId}) {
    _socket = IO.io(
      serverUrl,
      IO.OptionBuilder()
          .setTransports(['websocket']) // Use WebSocket transport
          .enableAutoConnect() // Automatically connect
          .setReconnectionAttempts(5) // Retry 5 times before giving up
          .setReconnectionDelay(2000) // Wait 2 seconds between retries
          .setQuery({'userId': userId}) // Pass userId as query parameter
          .build(),
    );

    // Handle connection events
    _socket.onConnect((_) {
      print('✅ Connected to Socket.IO server as User: $userId');
      emitJoinEvent(userId);
    });

    _socket.onDisconnect((_) {
      print('⚠️ Disconnected from Socket.IO server');
    });

    _socket.onConnectError((error) {
      print('❌ Connection Error: $error');
    });

    _socket.onError((error) {
      print('❌ Socket Error: $error');
    });

    _socket.onReconnect((_) {
      print('🔄 Reconnected to Socket.IO server');
    });

    _socket.onReconnectError((error) {
      print('❌ Reconnection Error: $error');
    });

    _socket.onReconnectFailed((_) {
      print('❌ Reconnection Failed after max attempts');
    });
  }

  /// Emit a 'join' event to register the user with the server
  void emitJoinEvent(String userId) {
    emitEvent('join', {'userId': userId});
  }

  /// Emit an event with data
  void emitEvent(String event, dynamic data) {
    if (_socket.connected) {
      _socket.emit(event, data);
      print('📤 Event "$event" emitted with data: $data');
    } else {
      print('⚠️ Unable to emit event "$event": Socket is not connected.');
    }
  }

  /// Listen to a specific event
  void listenToEvent(String event, Function(dynamic) callback) {
    _socket.on(event, (data) {
      print('📥 Event "$event" received with data: $data');
      callback(data);
    });
  }

  /// Remove a specific event listener
  void removeEventListener(String event) {
    _socket.off(event);
    print('🚫 Event listener for "$event" removed');
  }

  /// Disconnect the socket and clean up resources
  void disconnect() {
    if (_socket.connected) {
      _socket.disconnect();
      print('🔌 Socket disconnected');
    }
  }

  /// Dispose of the socket instance
  void dispose() {
    _socket.dispose();
    print('🗑️ Socket instance disposed');
  }

  /// Check if the socket is connected
  bool isConnected() {
    return _socket.connected;
  }
}
