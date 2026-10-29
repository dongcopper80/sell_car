import 'package:flutter/material.dart';
import '../../core/api_client.dart';

/// Hộp thoại đặt cọc: nhập số tiền + phương thức → POST /deposits.
/// Trả về true nếu tạo thành công.
Future<bool?> showDepositDialog(
  BuildContext context,
  String vehicleId,
  String vehicleTitle,
) {
  final amountCtrl = TextEditingController(text: '20000000');
  String method = 'transfer';
  return showDialog<bool>(
    context: context,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setState) => AlertDialog(
        title: const Text('Đặt cọc'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              vehicleTitle,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Số tiền (VND)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: method,
              decoration: const InputDecoration(
                labelText: 'Phương thức',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'transfer',
                  child: Text('Chuyển khoản ngân hàng'),
                ),
                DropdownMenuItem(value: 'qr', child: Text('QR code')),
              ],
              onChanged: (v) => setState(() {
                method = v ?? 'transfer';
              }),
            ),
            const SizedBox(height: 10),
            const Text(
              'Sau khi chuyển khoản, Aoto sẽ đối soát và xác nhận. Bạn sẽ nhận thông báo trong app.',
              style: TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () async {
              final amount = int.tryParse(amountCtrl.text) ?? 0;
              if (amount <= 0) return;
              try {
                final res = await ApiClient.post(
                  '/deposits',
                  body: {
                    'vehicleId': vehicleId,
                    'amountVnd': amount,
                    'method': method,
                  },
                );
                final ref = res is Map ? (res['referenceCode'] ?? '') : '';
                if (ctx.mounted) Navigator.pop(ctx, true);
                if (ref.toString().isNotEmpty) {
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Mã tham chiếu: $ref')),
                  );
                }
              } catch (e) {
                if (ctx.mounted) {
                  Navigator.pop(ctx, false);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(ApiClient.errMsg(e)),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Xác nhận đặt cọc'),
          ),
        ],
      ),
    ),
  );
}
