import 'package:flutter/material.dart';
import '../models/menu_item.dart';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  int _selectedPayment = 0;

  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'Tunai', 'icon': Icons.money_rounded, 'desc': 'Bayar di kasir'},
    {'name': 'QRIS', 'icon': Icons.qr_code_2_rounded, 'desc': 'Scan QR code'},
    {
      'name': 'E-Wallet',
      'icon': Icons.account_balance_wallet_rounded,
      'desc': 'GoPay / OVO / Dana',
    },
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

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
    // Ambil data dari arguments
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    final item = args?['item'] as MenuItem? ?? MenuItem.dummyMenu[0];
    final quantity = args?['quantity'] as int? ?? 1;
    final spiceLevel = args?['spiceLevel'] as int? ?? 1;
    final extraSambal = args?['extraSambal'] as bool? ?? false;
    final extraKerupuk = args?['extraKerupuk'] as bool? ?? false;
    final noVegetable = args?['noVegetable'] as bool? ?? false;
    final totalPrice = args?['totalPrice'] as int? ?? item.price;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      // ───── WIDGET 1: AppBar ─────
      appBar: AppBar(
        title: const Text(
          'Konfirmasi Pesanan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ───── WIDGET 2: Animasi centang sukses ─────
            Center(
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Pesanan Siap Diproses! 🎉',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 4),
            Center(
              child: Text(
                'Silakan pilih metode pembayaran',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
              ),
            ),
            const SizedBox(height: 28),

            // ───── WIDGET 3: Card ringkasan pesanan ─────
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.receipt_long_rounded,
                          color: Colors.deepOrange,
                          size: 22,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Ringkasan Pesanan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '#${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // ── Item detail ──
                    Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.deepOrange.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(item.icon, color: Colors.deepOrange),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${_formatRupiah(item.price)} × $quantity',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // ───── WIDGET 4: Wrap chips catatan ─────
                    Divider(color: Colors.grey[200]),
                    const SizedBox(height: 10),
                    const Text(
                      'Catatan:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (spiceLevel > 0)
                          _infoChip(
                            '🌶️ Pedas Lv.$spiceLevel',
                            Colors.red.shade50,
                            Colors.red,
                          ),
                        if (spiceLevel == 0)
                          _infoChip(
                            '🙂 Tidak Pedas',
                            Colors.green.shade50,
                            Colors.green,
                          ),
                        if (extraSambal)
                          _infoChip(
                            '+ Sambal',
                            Colors.orange.shade50,
                            Colors.orange,
                          ),
                        if (extraKerupuk)
                          _infoChip(
                            '+ Kerupuk',
                            Colors.amber.shade50,
                            Colors.amber.shade700,
                          ),
                        if (noVegetable)
                          _infoChip(
                            '🚫 Tanpa Sayur',
                            Colors.grey.shade100,
                            Colors.grey.shade700,
                          ),
                        _infoChip(
                          'Qty: $quantity',
                          Colors.blue.shade50,
                          Colors.blue,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ───── WIDGET 5: RadioListTile metode pembayaran ─────
            const Text(
              '💳 Metode Pembayaran',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            RadioGroup<int>(
              groupValue: _selectedPayment,
              onChanged: (v) =>
                  setState(() => _selectedPayment = v ?? _selectedPayment),
              child: Column(
                children: List.generate(_paymentMethods.length, (index) {
                  final method = _paymentMethods[index];
                  final isSelected = _selectedPayment == index;
                  return Card(
                    elevation: 0,
                    color: isSelected
                        ? Colors.deepOrange.shade50
                        : Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                      side: BorderSide(
                        color: isSelected
                            ? Colors.deepOrange
                            : Colors.grey.shade200,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: RadioListTile<int>(
                      value: index,
                      toggleable: false,
                      activeColor: Colors.deepOrange,
                      title: Text(
                        method['name'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      subtitle: Text(
                        method['desc'] as String,
                        style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                      ),
                      secondary: Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.deepOrange.shade100
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          method['icon'] as IconData,
                          color: isSelected
                              ? Colors.deepOrange
                              : Colors.grey[600],
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      controlAffinity: ListTileControlAffinity.trailing,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),

            // ───── WIDGET 6: Card total pembayaran ─────
            Card(
              elevation: 0,
              color: Colors.deepOrange.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    _priceRow('Subtotal', _formatRupiah(item.price * quantity)),
                    const SizedBox(height: 8),
                    _priceRow(
                      'Extra Kerupuk',
                      extraKerupuk ? _formatRupiah(2000 * quantity) : '-',
                    ),
                    const SizedBox(height: 8),
                    _priceRow('Biaya Layanan', 'Gratis'),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Divider(color: Colors.deepOrange),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Pembayaran',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _formatRupiah(totalPrice),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // ───── WIDGET 7: LinearProgressIndicator estimasi ─────
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 20,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Estimasi Waktu: 10-15 menit',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: const LinearProgressIndicator(
                        value: 0.15,
                        minHeight: 8,
                        backgroundColor: Color(0xFFE0E0E0),
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Colors.deepOrange,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Menunggu pembayaran...',
                      style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ───── WIDGET 8: Tombol konfirmasi ─────
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: () {
                  // Show konfirmasi dialog
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: const Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 28,
                          ),
                          SizedBox(width: 10),
                          Text('Pesanan Dikonfirmasi!'),
                        ],
                      ),
                      content: Text(
                        'Pesanan ${item.name} (×$quantity) telah berhasil! '
                        'Silakan tunggu di meja Anda.\n\n'
                        'Pembayaran: ${_paymentMethods[_selectedPayment]['name']}\n'
                        'Total: ${_formatRupiah(totalPrice)}',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                          },
                          child: const Text('Tutup'),
                        ),
                        FilledButton.icon(
                          onPressed: () {
                            Navigator.pop(ctx);
                            Navigator.popUntil(
                              context,
                              (route) => route.isFirst,
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                          ),
                          icon: const Icon(Icons.home_rounded),
                          label: const Text('Ke Beranda'),
                        ),
                      ],
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.payment_rounded),
                label: Text(
                  'Bayar ${_formatRupiah(totalPrice)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ───── WIDGET 9: OutlinedButton batalkan ─────
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey[600],
                  side: BorderSide(color: Colors.grey.shade300),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                icon: const Icon(Icons.arrow_back_rounded),
                label: const Text(
                  'Ubah Pesanan',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(String label, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }

  Widget _priceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
