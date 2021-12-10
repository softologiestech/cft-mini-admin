import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future addType(String type) async {
    final SharedPreferences prefs = await _prefs;

    return prefs.setString('type', type);
  }

  Future getType() async {
    final SharedPreferences prefs = await _prefs;

    return prefs.getString('type');
  }

  Future clear() async {
    final SharedPreferences prefs = await _prefs;

    return prefs.clear();
  }
}
