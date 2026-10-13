import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class MenuDetailPage extends StatefulWidget {
  const MenuDetailPage({super.key});

  @override
  State<MenuDetailPage> createState() => _MenuDetailPageState();
}

class _MenuDetailPageState extends State<MenuDetailPage> {
  int _quantity = 1;
  int _spiceLevel = 1;
  bool _extraSambal = false;
  bool _extraKerupuk = false;
  bool _noVegetable = false;
  bool _isFavorite = false;

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
    // Ambil data menu dari arguments
    final item =
        ModalRoute.of(context)?.settings.arguments as MenuItem? ??
        MenuItem.dummyMenu[0];

    final totalPrice = item.price * _quantity;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          // ───── WIDGET 1: SliverAppBar dengan gambar ─────
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFE64A19), Color(0xFFFF7043)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Icon(item.icon, size: 56, color: Colors.white),
                      ),
                      const SizedBox(height: 12),
                      if (item.isPopular)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber.shade400,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.local_fire_department,
                                size: 16,
                                color: Colors.white,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Menu Populer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            actions: [
              // ───── WIDGET 2: IconButton favorit ─────
              IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, anim) =>
                      ScaleTransition(scale: anim, child: child),
                  child: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    key: ValueKey<bool>(_isFavorite),
                    color: _isFavorite ? Colors.red[300] : Colors.white,
                  ),
                ),
                onPressed: () {
                  setState(() => _isFavorite = !_isFavorite);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isFavorite
                            ? '❤️ Ditambahkan ke favorit'
                            : 'Dihapus dari favorit',
                      ),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              ),
              // ───── WIDGET 3: IconButton share ─────
              IconButton(
                icon: const Icon(Icons.share_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('🔗 Link menu disalin!'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),

          // ───── Konten utama ─────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Nama & Harga ──
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // ───── WIDGET 4: Container harga ─────
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          _formatRupiah(item.price),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // ── Rating & Kategori ──
                  Row(
                    children: [
                      // ───── WIDGET 5: Rating row ─────
                      ...List.generate(5, (index) {
                        return Icon(
                          index < item.rating.floor()
                              ? Icons.star_rounded
                              : (index < item.rating
                                    ? Icons.star_half_rounded
                                    : Icons.star_border_rounded),
                          color: Colors.amber,
                          size: 22,
                        );
                      }),
                      const SizedBox(width: 8),
                      Text(
                        item.rating.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const Spacer(),
                      Chip(
                        avatar: Icon(
                          item.category == 'Makanan'
                              ? Icons.restaurant
                              : item.category == 'Minuman'
                              ? Icons.local_cafe
                              : Icons.cake,
                          size: 16,
                          color: Colors.deepOrange,
                        ),
                        label: Text(
                          item.category,
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: Colors.deepOrange.shade50,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Deskripsi ──
                  const Text(
                    'Deskripsi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Divider ──
                  Divider(color: Colors.grey[200]),
                  const SizedBox(height: 16),

                  // ───── WIDGET 6: Slider level pedas ─────
                  if (item.category == 'Makanan') ...[
                    const Text(
                      '🌶️ Level Pedas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Slider(
                            value: _spiceLevel.toDouble(),
                            min: 0,
                            max: 5,
                            divisions: 5,
                            activeColor: Colors.deepOrange,
                            label: _spiceLevel == 0
                                ? 'Tidak Pedas'
                                : 'Level $_spiceLevel',
                            onChanged: (value) {
                              setState(() => _spiceLevel = value.toInt());
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _spiceLevel > 3
                                ? Colors.red.shade50
                                : Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            _spiceLevel == 0
                                ? '🙂'
                                : List.generate(
                                    _spiceLevel,
                                    (_) => '🌶️',
                                  ).join(),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // ───── WIDGET 7: Switch / Checkbox tambahan ─────
                  const Text(
                    '✏️ Catatan Tambahan',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  _buildSwitchTile(
                    'Tambah Sambal',
                    'Extra sambal di piring terpisah',
                    Icons.local_fire_department,
                    _extraSambal,
                    (v) => setState(() => _extraSambal = v),
                  ),
                  _buildSwitchTile(
                    'Tambah Kerupuk',
                    'Kerupuk udang 3 pcs (+Rp 2.000)',
                    Icons.cookie_outlined,
                    _extraKerupuk,
                    (v) => setState(() => _extraKerupuk = v),
                  ),
                  _buildSwitchTile(
                    'Tanpa Sayuran',
                    'Tidak pakai sayur / lalapan',
                    Icons.eco_outlined,
                    _noVegetable,
                    (v) => setState(() => _noVegetable = v),
                  ),
                  const SizedBox(height: 24),

                  Divider(color: Colors.grey[200]),
                  const SizedBox(height: 16),

                  // ───── WIDGET 8: Stepper jumlah pesanan ─────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Jumlah Pesanan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_rounded),
                              onPressed: _quantity > 1
                                  ? () => setState(() => _quantity--)
                                  : null,
                              color: Colors.deepOrange,
                              iconSize: 22,
                            ),
                            SizedBox(
                              width: 40,
                              child: Text(
                                _quantity.toString(),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_rounded),
                              onPressed: _quantity < 10
                                  ? () => setState(() => _quantity++)
                                  : null,
                              color: Colors.deepOrange,
                              iconSize: 22,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),

      // ───── WIDGET 9: Bottom bar pesan ─────
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Harga',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
                Text(
                  _formatRupiah(
                    totalPrice + (_extraKerupuk ? 2000 * _quantity : 0),
                  ),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Expanded(
              // ───── WIDGET 10: Tombol pesan ─────
              child: FilledButton.icon(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    '/pesan',
                    arguments: {
                      'item': item,
                      'quantity': _quantity,
                      'spiceLevel': _spiceLevel,
                      'extraSambal': _extraSambal,
                      'extraKerupuk': _extraKerupuk,
                      'noVegetable': _noVegetable,
                      'totalPrice':
                          totalPrice + (_extraKerupuk ? 2000 * _quantity : 0),
                    },
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.shopping_cart_checkout_rounded),
                label: const Text(
                  'Pesan Sekarang',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Card(
      elevation: 0,
      color: value ? Colors.deepOrange.shade50 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: value ? Colors.deepOrange.shade200 : Colors.grey.shade200,
        ),
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: SwitchListTile(
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
        secondary: Icon(
          icon,
          color: value ? Colors.deepOrange : Colors.grey[400],
        ),
        value: value,
        activeTrackColor: Colors.deepOrange,
        onChanged: onChanged,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }
}
