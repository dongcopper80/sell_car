import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../../core/session.dart';

/// Đăng tin (business): wizard 3 bước — thông tin cơ bản, thông số, ảnh (URL ngoài).
class NewListingScreen extends StatefulWidget {
  const NewListingScreen({super.key});
  @override
  State<NewListingScreen> createState() => _NewListingScreenState();
}

class _NewListingScreenState extends State<NewListingScreen> {
  final _title = TextEditingController();
  final _price = TextEditingController(text: '500000000');
  final _odo = TextEditingController(text: '30000');
  final _year = TextEditingController(text: '2023');
  final _location = TextEditingController();
  final _desc = TextEditingController();
  final _photosCtrl = TextEditingController();

  String? _makeId;
  String? _modelId;
  String _fuel = 'petrol';
  String _trans = 'automatic';
  String? _province;
  int _step = 0;

  List<Map<String, dynamic>> _makes = [];
  List<Map<String, dynamic>> _models = [];
  List<Map<String, dynamic>> _provinces = [];
  bool _loadingMeta = true;

  @override
  void initState() {
    super.initState();
    _loadMeta();
  }

  Future<void> _loadMeta() async {
    try {
      final mk = await ApiClient.get('/catalog/makes');
      final pv = await ApiClient.get('/catalog/provinces');
      setState(() {
        _makes = (mk as List? ?? [])
            .map((j) => Map<String, dynamic>.from(j))
            .toList();
        _provinces = (pv as List? ?? [])
            .map((j) => Map<String, dynamic>.from(j))
            .toList();
        _loadingMeta = false;
      });
    } catch (e) {
      setState(() {
        _loadingMeta = false;
      });
      if (mounted)
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(ApiClient.errMsg(e))));
    }
  }

  Future<void> _loadModels(String makeId) async {
    try {
      final md = await ApiClient.get('/catalog/models');
      setState(() {
        _models = (md as List? ?? []).map((j) => Map<String, dynamic>.from(j)).where((m) => m['parentId'] == makeId).toList();
        _modelId = null;
      });
    } catch (_) {
      /* ignore */
    }
  }

  Future<void> _submit() async {
    final photos = _photosCtrl.text
        .split(RegExp(r'[\n,]+'))
        .map((s) => s.trim())
        .where((s) => s.startsWith('http'))
        .toList();
    if (photos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cần ít nhất 1 URL ảnh'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    try {
      final v =
          await ApiClient.post(
                '/vehicles',
                body: {
                  'title': _title.text.trim(),
                  'makeId': _makeId,
                  'modelId': _modelId,
                  'year': int.tryParse(_year.text) ?? 2023,
                  'odometerKm': int.tryParse(_odo.text) ?? 0,
                  'transmission': _trans,
                  'fuelType': _fuel,
                  'priceVnd': int.tryParse(_price.text) ?? 0,
                  'location': _location.text.trim(),
                  'provinceCode': _province,
                  'description': _desc.text.trim(),
                  'photos': photos,
                },
              )
              as Map<String, dynamic>;
      final id = v['id'] as String?;
      if (id != null) {
        try {
          await ApiClient.post('/vehicles/$id/submit');
        } catch (_) {}
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã gửi tin đăng — chờ CMS duyệt')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ApiClient.errMsg(e)),
            backgroundColor: Colors.red,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingMeta)
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    if (!Session.isBusiness) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Chỉ tài khoản doanh nghiệp mới đăng tin trực tiếp.\nCá nhân cần định danh VNeID.',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng tin bán xe')),
      body: Stepper(
        currentStep: _step,
        onStepTapped: (i) => setState(() {
          _step = i;
        }),
        onStepContinue: () {
          if (_step < 2)
            setState(() {
              _step++;
            });
          else
            _submit();
        },
        onStepCancel: () {
          if (_step > 0)
            setState(() {
              _step--;
            });
        },
        controlsBuilder: (ctx, details) => Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Row(
            children: [
              FilledButton(
                onPressed: details.onStepContinue,
                child: Text(_step < 2 ? 'Tiếp tục' : 'Gửi duyệt tin'),
              ),
              const SizedBox(width: 8),
              if (_step > 0)
                TextButton(
                  onPressed: details.onStepCancel,
                  child: const Text('Quay lại'),
                ),
            ],
          ),
        ),
        steps: [
          Step(
            title: const Text('Thông tin cơ bản'),
            isActive: _step >= 0,
            content: Column(
              children: [
                TextField(
                  controller: _title,
                  decoration: const InputDecoration(
                    labelText: 'Tiêu đề *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _makeId,
                  decoration: const InputDecoration(
                    labelText: 'Hãng xe *',
                    border: OutlineInputBorder(),
                  ),
                  items: _makes
                      .map(
                        (m) => DropdownMenuItem(
                          value: m['id'] as String,
                          child: Text(m['name'].toString()),
                        ),
                      )
                      .toList(),
                  onChanged: (v) {
                    if (v != null) {
                      setState(() {
                        _makeId = v;
                      });
                      _loadModels(v);
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _modelId,
                  decoration: const InputDecoration(
                    labelText: 'Dòng xe *',
                    border: OutlineInputBorder(),
                  ),
                  items: _models
                      .map(
                        (m) => DropdownMenuItem(
                          value: m['id'] as String,
                          child: Text(m['name'].toString()),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setState(() {
                    _modelId = v;
                  }),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _year,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Năm SX *',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _province,
                        decoration: const InputDecoration(
                          labelText: 'Tỉnh/TP *',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        items: _provinces
                            .map(
                              (p) => DropdownMenuItem(
                                value: p['code'] as String,
                                child: Text(
                                  p['name'].toString(),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() {
                          _province = v;
                        }),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _location,
                  decoration: const InputDecoration(
                    labelText: 'Địa điểm chi tiết *',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Thông số'),
            isActive: _step >= 1,
            content: Column(
              children: [
                TextField(
                  controller: _odo,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Số km đã đi *',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _trans,
                  decoration: const InputDecoration(
                    labelText: 'Hộp số *',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'automatic',
                      child: Text('Tự động'),
                    ),
                    DropdownMenuItem(value: 'manual', child: Text('Số sàn')),
                  ],
                  onChanged: (v) => setState(() {
                    _trans = v ?? 'automatic';
                  }),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: _fuel,
                  decoration: const InputDecoration(
                    labelText: 'Nhiên liệu *',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'petrol', child: Text('Xăng')),
                    DropdownMenuItem(value: 'diesel', child: Text('Diesel')),
                    DropdownMenuItem(value: 'electric', child: Text('Điện')),
                    DropdownMenuItem(value: 'hybrid', child: Text('Hybrid')),
                  ],
                  onChanged: (v) => setState(() {
                    _fuel = v ?? 'petrol';
                  }),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _price,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Giá bán (VND) *',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          Step(
            title: const Text('Ảnh & mô tả'),
            isActive: _step >= 2,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _desc,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Mô tả chi tiết',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _photosCtrl,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Link ảnh bên ngoài (mỗi dòng 1 URL)',
                    hintText:
                        'https://images.unsplash.com/photo-xxx\nhttps://cdn.example.com/xe.jpg',
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Ảnh bên ngoài hiển thị trực tiếp từ URL — không tải lên server.',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
