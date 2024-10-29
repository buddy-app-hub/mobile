import 'package:mobile/services/auth_service.dart';
import 'package:mobile/utils/definitions.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

class WebSocketService {
  StompClient? _stompClient;

  void connect(String meetingId, Function(String) onMessageReceived) async {
    final userToken = await AuthService().currentUser?.getIdToken();

    print("Preparando suscripcion al topico /topic/meetingStarted/$meetingId");

    _stompClient = StompClient(
      config: StompConfig.sockJS(
        url: '$BACKEND_URL/meeting-websocket',
        onConnect: (StompFrame frame) {
          _stompClient?.subscribe(
            destination: '/topic/meetingStarted/$meetingId',
            callback: (StompFrame frame) {
              if (frame.body != null) {
                onMessageReceived(frame.body!);
              }
            },
          );
        },
        onWebSocketError: (dynamic error) => print('WebSocket error: $error'),
        stompConnectHeaders: {
          'Authorization': 'Bearer $userToken',
        },
        webSocketConnectHeaders: {
          'Authorization': 'Bearer $userToken',
        },
      ),
    );
    _stompClient?.activate();
  }

  void disconnect() {
    _stompClient?.deactivate();
  }
}
