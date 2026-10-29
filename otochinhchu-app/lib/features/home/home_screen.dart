import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/api_client.dart';
import '../../core/models.dart';
import '../../core/session.dart';
import '../search/search_screen.dart';
import '../vehicle/vehicle_detail_screen.dart';
import '../listing/new_listing_screen.dart';
import '../deposit/deposit_list_screen.dart';
import '../profile/profile_screen.dart';

final _vnd = NumberFormat.currency(
  locale: 'vi_VN',
  symbol: '₫',
  decimalDigits: 0,
);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;
  late Future<List<Vehicle>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Vehicle>> _load() async {
    final data = await ApiClient.get('/vehicles', query: {'pageSize': '20'});
    final items = data is Map && data['items'] != null
        ? data['items']
        : (data as List? ?? []);
    return (items as List)
        .map((j) => Vehicle.fromJson(Map<String, dynamic>.from(j)))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _HomeTab(
        future: _future,
        onRetry: () => setState(() {
          _future = _load();
        }),
      ),
      const SearchScreen(),
      if (Session.isBusiness)
        const NewListingScreen()
      else
        const DepositListScreen(),
      const ProfileScreen(),
    ];
    return Scaffold(
      body: screens[_tab],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() {
          _tab = i;
        }),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          const NavigationDestination(
            icon: Icon(Icons.search_outlined),
            selectedIcon: Icon(Icons.search),
            label: 'Tìm xe',
          ),
          NavigationDestination(
            icon: Icon(
              Session.isBusiness
                  ? Icons.add_circle_outline
                  : Icons.savings_outlined,
            ),
            selectedIcon: Icon(
              Session.isBusiness ? Icons.add_circle : Icons.savings,
            ),
            label: Session.isBusiness ? 'Đăng tin' : 'Đặt cọc',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  final Future<List<Vehicle>> future;
  final VoidCallback onRetry;
  const _HomeTab({required this.future, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            title: const Text(
              'OtoChinhChu',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(child: _HeroBanner()),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: FutureBuilder<List<Vehicle>>(
              future: future,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );
                }
                if (snap.hasError) {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Column(
                        children: [
                          Text('Lỗi: ${ApiClient.errMsg(snap.error!)}'),
                          TextButton(
                            onPressed: onRetry,
                            child: const Text('Thử lại'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                final items = snap.data ?? [];
                if (items.isEmpty)
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40),
                        child: Text('Chưa có tin đăng'),
                      ),
                    ),
                  );
                return SliverGrid.builder(
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 260,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: items.length,
                  itemBuilder: (_, i) => _VehicleCard(v: items[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF123D2F),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'MUA BÁN XE CHÍNH CHỦ',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: const Color(0xFFCBE776),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Tìm chiếc xe phù hợp,\ngiao dịch an tâm',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tin đăng được kiểm duyệt · Đặt cọc có đối soát',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _VehicleCard extends StatelessWidget {
  final Vehicle v;
  const _VehicleCard({required this.v});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE4EAE6)),
      ),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => VehicleDetailScreen(id: v.id)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  v.photos.isNotEmpty
                      ? Image.network(
                          v.photos.first,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: const Color(0xFFE9EFEB),
                            child: const Icon(
                              Icons.directions_car,
                              size: 48,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : Container(
                          color: const Color(0xFFE9EFEB),
                          child: const Icon(
                            Icons.directions_car,
                            size: 48,
                            color: Colors.grey,
                          ),
                        ),
                  Positioned(
                    left: 8,
                    top: 8,
                    child: Chip(
                      label: Text(
                        v.verified
                            ? 'Đã xác minh'
                            : (v.sellerType == 'business'
                                  ? 'Salon'
                                  : 'Cá nhân'),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      backgroundColor: v.verified
                          ? const Color(0xFFE4F3E9)
                          : Colors.white,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      v.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _vnd.format(v.priceVnd),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${v.year} · ${NumberFormat.decimalPattern('vi_VN').format(v.odometerKm)} km',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
