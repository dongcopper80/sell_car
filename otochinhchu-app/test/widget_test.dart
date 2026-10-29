import 'package:flutter_test/flutter_test.dart';
import 'package:otochinhchu_app/core/models.dart';

void main() {
  group('Vehicle model', () {
    test('fromJson parse đúng các trường', () {
      final v = Vehicle.fromJson({
        'id': 'abc-123',
        'title': 'Toyota Corolla Cross 1.8V 2023',
        'priceVnd': '820000000',  // API trả bigint dạng string
        'year': 2023,
        'odometerKm': 18000,
        'fuelType': 'petrol',
        'transmission': 'automatic',
        'location': 'Quận Cầu Giấy, Hà Nội',
        'status': 'published',
        'verified': true,
        'sellerType': 'business',
        'photos': ['https://example.com/a.jpg'],
      });
      expect(v.title, contains('Corolla'));
      expect(v.priceVnd, 820000000);
      expect(v.isPublished, isTrue);
      expect(v.verified, isTrue);
      expect(v.photos.length, 1);
    });

    test('fromJson an toàn với field thiếu', () {
      final v = Vehicle.fromJson({'id': 'x', 'priceVnd': '5000000', 'year': '2022'});
      expect(v.title, '');
      expect(v.priceVnd, 5000000);
      expect(v.year, 2022);
      expect(v.isPublished, isFalse);
      expect(v.photos, isEmpty);
    });
  });

  group('Deposit model', () {
    test('fromJson parse trạng thái', () {
      final d = Deposit.fromJson({
        'id': 'd1',
        'referenceCode': 'DEP-2026-000001',
        'amountVnd': 20000000,
        'status': 'pending_payment',
      });
      expect(d.status, 'pending_payment');
      expect(d.amountVnd, 20000000);
    });
  });

  group('CatalogItem model', () {
    test('fromJson', () {
      final c = CatalogItem.fromJson(
          {'id': 'm1', 'code': 'toyota', 'name': 'Toyota'});
      expect(c.name, 'Toyota');
      expect(c.parentId, isNull);
    });
  });
}
