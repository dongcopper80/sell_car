import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/api_client.dart';
import '../../core/session.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _me;
  List<Map<String, dynamic>> _myVehicles = [];
  List<Map<String, dynamic>> _notifications = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      Map<String, dynamic> me = {};
      List<Map<String, dynamic>> myV = [];
      List<Map<String, dynamic>> notis = [];
      try { me = Map<String, dynamic>.from(await ApiClient.get('/auth/me')); } catch (_) {}
      try { final r = await ApiClient.get('/vehicles/mine/listings'); myV = (r as List? ?? []).map((j) => Map<String, dynamic>.from(j)).toList(); } catch (_) {}
      try { final r = await ApiClient.get('/notifications'); notis = (r as List? ?? []).map((j) => Map<String, dynamic>.from(j)).toList(); } catch (_) {}
      setState(() {
        _me = me;
        _myVehicles = myV;
        _notifications = notis;
        _loading = false;
      });
    } catch (e) {
      setState(() { _error = ApiClient.errMsg(e); _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (_error != null) return Scaffold(body: Center(child: Text(_error!)));
    final me = _me ?? {};
    final fmt = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);
    return Scaffold(
      appBar: AppBar(title: const Text('Tài khoản')),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: Padding(padding: const EdgeInsets.all(16), child: Row(children: [
          CircleAvatar(radius: 28, backgroundColor: Theme.of(context).colorScheme.primary, child: Text(_initial(me['fullName']?.toString() ?? me['email']?.toString() ?? '?'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(me['fullName']?.toString() ?? '', style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
            Text(me['email']?.toString() ?? '', style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 6),
            Wrap(spacing: 6, children: [
              Chip(label: Text(me['role']?.toString() ?? '', style: const TextStyle(fontSize: 10)), visualDensity: VisualDensity.compact, padding: EdgeInsets.zero),
              Chip(label: Text((me['identityVerified'] == true || me['identityVerified'] == 'true') ? 'Đã VNeID' : 'Chưa định danh', style: const TextStyle(fontSize: 10)), backgroundColor: (me['identityVerified'] == true || me['identityVerified'] == 'true') ? const Color(0xFFE4F3E9) : const Color(0xFFFFF3DF), visualDensity: VisualDensity.compact, padding: EdgeInsets.zero),
            ]),
          ])),
        ]))),
        const SizedBox(height: 12),
        const Text('Tin đăng của tôi', style: TextStyle(fontWeight: FontWeight.w800)),
        ..._myVehicles.map((v) => Card(margin: const EdgeInsets.only(top: 8), child: ListTile(
          title: Text(v['title']?.toString() ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          subtitle: Text(fmt.format(int.tryParse(v['priceVnd'].toString()) ?? 0), style: const TextStyle(fontSize: 12)),
          trailing: Chip(label: Text((v['status']?.toString() ?? '').replaceAll('_', ' '), style: const TextStyle(fontSize: 10)), visualDensity: VisualDensity.compact, padding: EdgeInsets.zero),
        ))),
        if (_myVehicles.isEmpty) const Padding(padding: EdgeInsets.all(8), child: Text('Chưa có tin đăng', style: TextStyle(color: Colors.grey))),
        const SizedBox(height: 16),
        const Text('Thông báo', style: TextStyle(fontWeight: FontWeight.w800)),
        ..._notifications.take(10).map((n) => Card(margin: const EdgeInsets.only(top: 8), child: ListTile(
          dense: true,
          title: Text(n['title']?.toString() ?? '', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          subtitle: Text(n['body']?.toString() ?? '', style: const TextStyle(fontSize: 11)),
          trailing: n['isRead'] == true ? null : Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
        ))),
        if (_notifications.isEmpty) const Padding(padding: EdgeInsets.all(8), child: Text('Chưa có thông báo', style: TextStyle(color: Colors.grey))),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          icon: const Icon(Icons.logout),
          label: const Text('Đăng xuất'),
          onPressed: () async {
            await Session.clear();
            if (context.mounted) Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const LoginScreen()), (_) => false);
          },
        ),
      ]),
    );
  }

  String _initial(String s) {
    final parts = s.trim().split(RegExp(r'\s+'))..removeWhere((p) => p.isEmpty);
    return parts.isEmpty ? '?' : parts.sublist(parts.length >= 2 ? parts.length - 2 : 0).map((p) => p[0]).join().toUpperCase();
  }
}
