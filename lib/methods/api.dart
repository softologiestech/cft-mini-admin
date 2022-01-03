import 'dart:async';
import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

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

  Future<http.Response> getHistoricData(
      String pair, String from, String to, String timespan) {
    var url = Uri.parse(
        'https://api.polygon.io/v2/aggs/ticker/X:$pair/range/1/$timespan/$from/$to?adjusted=true&sort=asc&apiKey=3r5A4iEkMqoBUNWCRPq2xBSJf0I82WfO');
    var res = http.get(url);

    return res;
  }
}
