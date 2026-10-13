import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class MenuListPage extends StatefulWidget {
  const MenuListPage({super.key});

  @override
  State<MenuListPage> createState() => _MenuListPageState();
}

class _MenuListPageState extends State<MenuListPage> {
  String _selectedCategory = 'Semua';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _categories = ['Semua', 'Makanan', 'Minuman', 'Snack'];

  List<MenuItem> get _filteredMenu {
    return MenuItem.dummyMenu.where((item) {
      final matchCategory =
          _selectedCategory == 'Semua' || item.category == _selectedCategory;
      final matchSearch = item.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      return matchCategory && matchSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      // ───── WIDGET 1: AppBar dengan gradient ─────
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.storefront_rounded, size: 28),
            SizedBox(width: 10),
            Text(
              'Kantin Bu Sari',
              style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
          ],
        ),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // ───── WIDGET 2: IconButton notifikasi ─────
          IconButton(
            icon: Badge(
              label: const Text('3'),
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('🔔 Belum ada notifikasi baru'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // ───── Header section dengan gradient ─────
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepOrange, Color(0xFFFF7043)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Mau makan apa hari ini? 🍽️',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 14),
                  // ───── WIDGET 3: TextField pencarian ─────
                  TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Cari menu favorit...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 20),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // ───── WIDGET 4: Chip kategori (horizontal scroll) ─────
          SizedBox(
            height: 42,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: Colors.deepOrange,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey[700],
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  backgroundColor: Colors.grey[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide.none,
                  showCheckmark: false,
                  onSelected: (_) {
                    setState(() => _selectedCategory = cat);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // ───── Label jumlah menu ─────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Menu Tersedia',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // ───── WIDGET 5: Chip jumlah item ─────
                Chip(
                  label: Text(
                    '${_filteredMenu.length} item',
                    style: const TextStyle(fontSize: 12),
                  ),
                  backgroundColor: Colors.deepOrange.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  side: BorderSide.none,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // ───── WIDGET 6: ListView menu cards ─────
          Expanded(
            child: _filteredMenu.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Menu tidak ditemukan',
                          style: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                    itemCount: _filteredMenu.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final item = _filteredMenu[index];
                      return _MenuCard(
                        item: item,
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/detail',
                            arguments: item,
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),

      // ───── WIDGET 7: FloatingActionButton keranjang ─────
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (ctx) => Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 56,
                    color: Colors.deepOrange,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Keranjang Masih Kosong',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Yuk, pilih menu favoritmu terlebih dahulu!',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: FilledButton.styleFrom(
                        backgroundColor: Colors.deepOrange,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Mulai Pilih Menu'),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.shopping_cart_rounded),
        label: const Text('Keranjang'),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════
//  Widget: Card untuk setiap menu item
// ═══════════════════════════════════════════════════════════
class _MenuCard extends StatelessWidget {
  final MenuItem item;
  final VoidCallback onTap;
  const _MenuCard({required this.item, required this.onTap});

  String _formatRupiah(int price) {
    final str = price.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write('.');
      buffer.write(str[i]);
    }
    return 'Rp ${buffer.toString()}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: item.isAvailable ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Opacity(
          opacity: item.isAvailable ? 1.0 : 0.5,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                // ── Ikon menu ──
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange.shade50,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(item.icon, color: Colors.deepOrange, size: 28),
                ),
                const SizedBox(width: 14),
                // ── Detail ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              item.name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (item.isPopular)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.amber.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.local_fire_department,
                                    size: 14,
                                    color: Colors.orange,
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    'Populer',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          if (!item.isAvailable)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Habis',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            _formatRupiah(item.price),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.deepOrange,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.star_rounded,
                            size: 16,
                            color: Colors.amber[600],
                          ),
                          const SizedBox(width: 3),
                          Text(
                            item.rating.toString(),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                // ── Arrow ──
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
