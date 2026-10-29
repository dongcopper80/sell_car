/// Phiên người dùng: lưu token + user vào SharedPreferences, phát qua Stream cho SessionGate.
library;

import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class SessionUser {
  final String id;
  final String email;
  final String role;
  final String fullName;
  SessionUser({
    required this.id,
    required this.email,
    required this.role,
    required this.fullName,
  });

  factory SessionUser.fromJson(Map<String, dynamic> j) => SessionUser(
    id: j['id'] as String? ?? '',
    email: j['email'] as String? ?? '',
    role: j['role'] as String? ?? 'buyer',
    fullName: j['fullName'] as String? ?? '',
  );
}

class Session {
  static SharedPreferences? _prefs;
  static final _tokenCtrl = StreamController<String?>.broadcast();
  static final _userCtrl = StreamController<SessionUser?>.broadcast();

  static String? _token;
  static SessionUser? _user;

  static String? get token => _token;
  static SessionUser? get user => _user;
  static Stream<String?> get tokenStream => _tokenCtrl.stream;
  static Stream<SessionUser?> get userStream => _userCtrl.stream;
  static bool get isBusiness => _user?.role == 'business';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _token = _prefs!.getString('token');
    final u = _prefs!.getString('user');
    _user = u == null
        ? null
        : SessionUser.fromJson(Map<String, dynamic>.from(_decode(u)));
  }

  // decode user từ chuỗi demo {key: value}
  static Map<String, dynamic> _decode(String raw) {
    final cleaned = raw.replaceAll('{', '').replaceAll('}', '');
    final out = <String, dynamic>{};
    for (final pair in cleaned.split(', ')) {
      final idx = pair.indexOf(': ');
      if (idx > 0) out[pair.substring(0, idx)] = pair.substring(idx + 2);
    }
    return out;
  }

  static Future<void> save(String token, Map<String, dynamic> userJson) async {
    _token = token;
    _user = SessionUser.fromJson(userJson);
    await _prefs!.setString('token', token);
    await _prefs!.setString('user', userJson.toString()); // demo
    _tokenCtrl.add(token);
    _userCtrl.add(_user);
  }

  static Future<void> clear() async {
    _token = null;
    _user = null;
    await _prefs!.remove('token');
    await _prefs!.remove('user');
    _tokenCtrl.add(null);
    _userCtrl.add(null);
  }
}
