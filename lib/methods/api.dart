import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

class API {
  final channel =
      WebSocketChannel.connect(Uri.parse('wss://socket.polygon.io/crypto'));

  getData() {
    channel.sink.add(jsonEncode(
        {"action": "auth", "params": "3r5A4iEkMqoBUNWCRPq2xBSJf0I82WfO"}));
    channel.sink.add(jsonEncode({"action": "subscribe", "params": "XQ.*"}));

    return channel.stream;
  }

  Stream<dynamic> getSpecificCoinData(String sym) {
    channel.sink.add(jsonEncode(
        {"action": "auth", "params": "3r5A4iEkMqoBUNWCRPq2xBSJf0I82WfO"}));
    channel.sink.add(jsonEncode({"action": "subscribe", "params": "XQ.$sym"}));

    return channel.stream;
  }
}
