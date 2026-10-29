import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/api_client.dart';
import '../../core/models.dart';

/// Danh sách yêu cầu đặt cọc của tôi — theo dõi trạng thái đối soát.
class DepositListScreen extends StatefulWidget {
  const DepositListScreen({super.key});
  @override
  State<DepositListScreen> createState() => _DepositListScreenState();
}

class _DepositListScreenState extends State<DepositListScreen> {
  late Future<List<Deposit>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Deposit>> _load() async {
    final data = await ApiClient.get('/deposits/mine');
    return (data as List? ?? [])
        .map((j) => Deposit.fromJson(Map<String, dynamic>.from(j)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đặt cọc của tôi')),
      body: FutureBuilder<List<Deposit>>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting)
            return const Center(child: CircularProgressIndicator());
          if (snap.hasError)
            return Center(child: Text('Lỗi: ${ApiClient.errMsg(snap.error!)}'));
          final items = snap.data ?? [];
          if (items.isEmpty)
            return const Center(child: Text('Chưa có yêu cầu đặt cọc nào'));
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _future = _load();
              });
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (_, i) {
                final d = items[i];
                return Card(
                  margin: EdgeInsets.zero,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: _statusColor(d.status),
                      child: const Icon(
                        Icons.savings,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      d.referenceCode,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      NumberFormat.currency(
                        locale: 'vi_VN',
                        symbol: '₫',
                        decimalDigits: 0,
                      ).format(d.amountVnd),
                    ),
                    trailing: Chip(
                      label: Text(
                        _statusLabel(d.status),
                        style: const TextStyle(fontSize: 11),
                      ),
                      backgroundColor: _statusColor(d.status).withValues(alpha: .15),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Color _statusColor(String s) {
    switch (s) {
      case 'paid':
        return const Color(0xFF237247);
      case 'verifying':
        return const Color(0xFF9C671C);
      case 'disputed':
      case 'refunded':
        return const Color(0xFFAF5149);
      default:
        return Colors.blueGrey;
    }
  }

  String _statusLabel(String s) =>
      const {
        'pending_payment': 'Chờ chuyển khoản',
        'verifying': 'Đang đối soát',
        'paid': 'Đã xác nhận',
        'disputed': 'Tranh chấp',
        'refunded': 'Đã hoàn',
      }[s] ??
      s;
}
