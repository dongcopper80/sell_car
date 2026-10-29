import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/api_client.dart';
import '../../core/models.dart';
import '../deposit/deposit_dialog.dart';

class VehicleDetailScreen extends StatefulWidget {
  final String id;
  const VehicleDetailScreen({super.key, required this.id});
  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  late Future<Vehicle> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<Vehicle> _load() async {
    final data = await ApiClient.get('/vehicles/${widget.id}');
    return Vehicle.fromJson(Map<String, dynamic>.from(data));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết xe')),
      body: FutureBuilder<Vehicle>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snap.hasError)
            return Center(child: Text('Lỗi: ${ApiClient.errMsg(snap.error!)}'));
          final v = snap.data!;
          final fmt = NumberFormat.currency(
            locale: 'vi_VN',
            symbol: '₫',
            decimalDigits: 0,
          );
          return Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _PhotoCarousel(photos: v.photos)),
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList.list(
                        children: [
                          Text(
                            v.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            fmt.format(v.priceVnd),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            children: [
                              Chip(
                                label: Text(
                                  v.status,
                                  style: const TextStyle(fontSize: 10),
                                ),
                                visualDensity: VisualDensity.compact,
                              ),
                              if (v.verified)
                                Chip(
                                  label: const Text(
                                    'Đã xác minh',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  backgroundColor: const Color(0xFFE4F3E9),
                                  visualDensity: VisualDensity.compact,
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Card(
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                children: [
                                  _spec('Năm sản xuất', '${v.year}'),
                                  _spec(
                                    'Đã đi',
                                    '${NumberFormat.decimalPattern('vi_VN').format(v.odometerKm)} km',
                                  ),
                                  _spec('Nhiên liệu', _fuel(v.fuelType)),
                                  _spec('Hộp số', _trans(v.transmission)),
                                  _spec('Khu vực', v.location),
                                  _spec(
                                    'Người bán',
                                    v.sellerType == 'business'
                                        ? 'Salon (đã xác minh)'
                                        : 'Cá nhân',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Mô tả',
                            style: TextStyle(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 6),
                          Text(v.description ?? 'Chưa có mô tả.'),
                          const SizedBox(height: 90),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FilledButton.icon(
                      icon: const Icon(Icons.savings),
                      label: const Text('Đặt cọc xe này'),
                      onPressed: () async {
                        final ok = await showDepositDialog(
                          context,
                          v.id,
                          v.title,
                        );
                        if (ok == true && mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Đã tạo yêu cầu đặt cọc — chờ chuyển khoản & đối soát',
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _spec(String k, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(
            k,
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
        ),
        Expanded(
          child: Text(
            v,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ),
      ],
    ),
  );

  String _fuel(String f) =>
      const {
        'petrol': 'Xăng',
        'diesel': 'Diesel',
        'electric': 'Điện',
        'hybrid': 'Hybrid',
      }[f] ??
      f;
  String _trans(String t) =>
      const {'automatic': 'Tự động', 'manual': 'Số sàn'}[t] ?? t;
}

class _PhotoCarousel extends StatelessWidget {
  final List<String> photos;
  const _PhotoCarousel({required this.photos});

  @override
  Widget build(BuildContext context) {
    if (photos.isEmpty) {
      return Container(
        height: 220,
        color: const Color(0xFFE9EFEB),
        child: const Icon(Icons.directions_car, size: 64, color: Colors.grey),
      );
    }
    return SizedBox(
      height: 240,
      child: PageView.builder(
        itemCount: photos.length,
        itemBuilder: (_, i) => Image.network(
          photos[i],
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            color: const Color(0xFFE9EFEB),
            child: const Icon(
              Icons.directions_car,
              size: 64,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
