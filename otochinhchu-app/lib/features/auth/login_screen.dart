import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../../core/session.dart';
import '../home/home_screen.dart';

/// Đăng nhập:
/// - Cá nhân: VNeID (OAuth) — mobile chỉ mở WebView/deep-link, MVP hiển thị hướng dẫn.
/// - Doanh nghiệp/CMS: email + mật khẩu (tài khoản do CMS cấp).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _loading = false;
  String? _error;

  /// AUTO-LOGIN (test mode): tự điền + đăng nhập bằng tài khoản admin
  /// để test toàn bộ chức năng. Tắt: đặt useAutoLogin = false.
  static const useAutoLogin = true;
  static const _autoAccount = {'email': 'admin@otochinhchu.vn', 'password': 'admin123'};

  @override
  void initState() {
    super.initState();
    if (useAutoLogin) {
      _email.text = _autoAccount['email']!;
      _pass.text = _autoAccount['password']!;
      WidgetsBinding.instance.addPostFrameCallback((_) => _loginPassword());
    }
  }

  Future<void> _loginPassword() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final data =
          await ApiClient.post(
                '/auth/login',
                body: {'email': _email.text.trim(), 'password': _pass.text},
              )
              as Map<String, dynamic>;
      await Session.save(
        data['accessToken'] as String,
        (data['user'] ?? {}) as Map<String, dynamic>,
      );
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } catch (e) {
      setState(() {
        _error = ApiClient.errMsg(e);
      });
    } finally {
      if (mounted)
        setState(() {
          _loading = false;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  width: 88,
                  height: 88,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Text(
                    'A',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'OtoChinhChu',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Mua bán ô tô chính chủ — an tâm giao dịch',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // AUTO-LOGIN banner (test mode)
                if (useAutoLogin) Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE6C85A)),
                  ),
                  child: Row(children: [
                    const Text('🧪', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 10),
                    const Expanded(child: Text('Chế độ test — tự đăng nhập admin để test toàn bộ chức năng.', style: TextStyle(fontSize: 11))),
                    TextButton(
                      onPressed: () => setState(() { _email.clear(); _pass.clear(); }),
                      child: const Text('Nhập tay', style: TextStyle(fontSize: 11)),
                    ),
                  ]),
                ),

                // VNeID — cá nhân
                FilledButton.icon(
                  icon: const Icon(Icons.verified_user),
                  label: const Text('Đăng nhập bằng VNeID'),
                  onPressed: () => _showVneidNote(),
                ),
                const SizedBox(height: 12),

                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text('hoặc'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 12),

                // Doanh nghiệp / CMS — email + password
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email (doanh nghiệp / quản trị)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _pass,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mật khẩu',
                    border: OutlineInputBorder(),
                  ),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 12),
                  Text(_error!, style: const TextStyle(color: Colors.red)),
                ],
                const SizedBox(height: 16),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _loginPassword,
                    child: _loading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Đăng nhập'),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Tài khoản cá nhân bắt buộc định danh VNeID.\n'
                  'Tài khoản doanh nghiệp được Aoto tạo thủ công sau xác minh hồ sơ.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showVneidNote() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('VNeID'),
        content: const Text(
          'Prototype chưa tích hợp VNeID thật.\n\n'
          'Khi production, app sẽ mở VNeID OAuth (deep link / WebView) và nhận token từ callback.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đã hiểu'),
          ),
        ],
      ),
    );
  }
}
