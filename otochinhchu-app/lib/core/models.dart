/// Models đơn giản cho tin đăng, danh mục, đặt cọc.
library;

class Vehicle {
  final String id;
  final String title;
  final int priceVnd;
  final int year;
  final int odometerKm;
  final String fuelType;
  final String transmission;
  final String location;
  final String status;
  final bool verified;
  final String sellerType;
  final String? description;
  final List<String> photos;

  Vehicle({
    required this.id,
    required this.title,
    required this.priceVnd,
    required this.year,
    required this.odometerKm,
    required this.fuelType,
    required this.transmission,
    required this.location,
    required this.status,
    required this.verified,
    required this.sellerType,
    this.description,
    required this.photos,
  });

  /// Parse linh hoạt: API có thể trả int, num hoặc chuỗi "820000000" (bigint của Postgres).
  static int _toInt(dynamic v) {
    if (v == null) return 0;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString()) ?? 0;
  }

  static bool _toBool(dynamic v) {
    if (v == null) return false;
    if (v is bool) return v;
    return v.toString() == 'true' || v.toString() == '1';
  }

  factory Vehicle.fromJson(Map<String, dynamic> j) => Vehicle(
    id: j['id']?.toString() ?? '',
    title: j['title']?.toString() ?? '',
    priceVnd: _toInt(j['priceVnd']),
    year: _toInt(j['year']),
    odometerKm: _toInt(j['odometerKm']),
    fuelType: j['fuelType']?.toString() ?? '',
    transmission: j['transmission']?.toString() ?? '',
    location: j['location']?.toString() ?? '',
    status: j['status']?.toString() ?? '',
    verified: _toBool(j['verified']),
    sellerType: j['sellerType']?.toString() ?? 'personal',
    description: j['description']?.toString(),
    photos: ((j['photos'] as List?) ?? []).map((e) => e.toString()).toList(),
  );

  bool get isPublished => status == 'published';
}

class CatalogItem {
  final String id;
  final String code;
  final String name;
  final String? parentId;
  CatalogItem({
    required this.id,
    required this.code,
    required this.name,
    this.parentId,
  });

  factory CatalogItem.fromJson(Map<String, dynamic> j) => CatalogItem(
    id: j['id']?.toString() ?? '',
    code: j['code']?.toString() ?? '',
    name: j['name']?.toString() ?? '',
    parentId: j['parentId']?.toString(),
  );
}

class Deposit {
  final String id;
  final String referenceCode;
  final int amountVnd;
  final String status;
  Deposit({
    required this.id,
    required this.referenceCode,
    required this.amountVnd,
    required this.status,
  });

  factory Deposit.fromJson(Map<String, dynamic> j) => Deposit(
    id: j['id']?.toString() ?? '',
    referenceCode: j['referenceCode']?.toString() ?? '',
    amountVnd: Vehicle._toInt(j['amountVnd']),
    status: j['status']?.toString() ?? '',
  );
}
