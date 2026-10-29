import 'package:flutter/material.dart';
import '../../core/api_client.dart';
import '../../core/models.dart';
import '../vehicle/vehicle_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _kw = TextEditingController();
  String? _fuel;
  String? _trans;
  bool _loading = true;
  String? _error;
  List<Vehicle> _items = [];

  @override
  void initState() {
    super.initState();
    _search();
  }

  Future<void> _search() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final q = <String, dynamic>{'pageSize': '30'};
      if (_kw.text.trim().isNotEmpty) q['keyword'] = _kw.text.trim();
      if (_fuel != null) q['fuelType'] = _fuel!;
      if (_trans != null) q['transmission'] = _trans!;
      final data = await ApiClient.get('/vehicles', query: q);
      final items = data is Map && data['items'] != null
          ? data['items']
          : (data as List? ?? []);
      setState(() {
        _items = (items as List)
            .map((j) => Vehicle.fromJson(Map<String, dynamic>.from(j)))
            .toList();
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = ApiClient.errMsg(e);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tìm xe')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _kw,
                    onSubmitted: (_) => _search(),
                    decoration: InputDecoration(
                      hintText: 'Tìm theo tên xe...',
                      isDense: true,
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: _search,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _fuel,
                    isDense: true,
                    decoration: const InputDecoration(
                      labelText: 'Nhiên liệu',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(value: 'petrol', child: Text('Xăng')),
                      DropdownMenuItem(value: 'diesel', child: Text('Diesel')),
                      DropdownMenuItem(value: 'electric', child: Text('Điện')),
                      DropdownMenuItem(value: 'hybrid', child: Text('Hybrid')),
                    ],
                    onChanged: (v) => setState(() {
                      _fuel = v;
                      _search();
                    }),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _trans,
                    isDense: true,
                    decoration: const InputDecoration(
                      labelText: 'Hộp số',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'automatic',
                        child: Text('Tự động'),
                      ),
                      DropdownMenuItem(value: 'manual', child: Text('Số sàn')),
                    ],
                    onChanged: (v) => setState(() {
                      _trans = v;
                      _search();
                    }),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: _buildResults()),
        ],
      ),
    );
  }

  Widget _buildResults() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text(_error!));
    if (_items.isEmpty) return const Center(child: Text('Không có xe khớp'));
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (_, i) {
        final v = _items[i];
        return Card(
          clipBehavior: Clip.antiAlias,
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => VehicleDetailScreen(id: v.id)),
            ),
            child: SizedBox(
              height: 96,
              child: Row(
                children: [
                  SizedBox(
                    width: 130,
                    child: v.photos.isNotEmpty
                        ? Image.network(
                            v.photos.first,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (_, __, ___) => Container(
                              color: const Color(0xFFE9EFEB),
                              child: const Icon(Icons.directions_car),
                            ),
                          )
                        : Container(
                            color: const Color(0xFFE9EFEB),
                            child: const Icon(Icons.directions_car),
                          ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            v.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${v.year} · ${v.odometerKm} km · ${v.location}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            _fmt(v.priceVnd),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _fmt(int n) =>
      n.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]}.',
      ) +
      ' ₫';
}
