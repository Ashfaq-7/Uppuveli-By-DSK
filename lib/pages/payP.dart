import 'package:flutter/material.dart';
import 'loyaltyP.dart';
import 'bookingSuccessP.dart'; // ✅ NEW: success page after payment

class PaymentMethodPage extends StatefulWidget {
  const PaymentMethodPage({
    super.key,
    required this.totalAmount,
  });

  final double totalAmount;

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  static const Color kGold = Color(0xFFC9A633);
  static const Color kBg = Color(0xFFF9F8F3);

  // Selected saved card index (0 or 1)
  int _selectedCardIndex = 0;

  // Loyalty points slider
  double _pointsToUse = 0; // 0..1500
  static const double _maxPoints = 1500;

  // 1500 points = $150 => 1 point = $0.10
  static const double _valuePerPoint = 0.10;

  // Fake processing state (UI only)
  bool _isPaying = false;

  String _money(double v) => '\$${v.toStringAsFixed(2)}';

  double get _pointsValue => _pointsToUse * _valuePerPoint;

  double get _payableTotal {
    final t = widget.totalAmount - _pointsValue;
    return t < 0 ? 0 : t;
  }

  String get _selectedCardLabel => _selectedCardIndex == 0 ? 'VISA' : 'MC';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            // Top gold bar (like your screens)
            Container(
              height: 44,
              width: double.infinity,
              color: kGold,
              alignment: Alignment.center,
              child: const Text(
                'Screen 5: Payment\nMethod',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  height: 1.05,
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _headerBar(),
                    const SizedBox(height: 14),

                    _totalCard(),
                    const SizedBox(height: 10),

                    // ✅ NEW: Loyalty Button (quick access)
                    _loyaltyQuickButton(),
                    const SizedBox(height: 16),

                    const Text(
                      'Saved\nCards',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),

                    _savedCard(
                      index: 0,
                      brand: 'VISA',
                      brandColor: const Color(0xFF1A3FD9),
                      last4: '4242',
                      expiry: '12/26',
                    ),
                    const SizedBox(height: 10),
                    _savedCard(
                      index: 1,
                      brand: 'MC',
                      brandColor: const Color(0xFFE43A2E),
                      last4: '8888',
                      expiry: '03/27',
                    ),
                    const SizedBox(height: 12),

                    _addNewCardButton(),
                    const SizedBox(height: 18),

                    const Text(
                      'Digital Wallets',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),

                    _walletButton(
                      label: 'Apple Pay',
                      filled: true,
                      onTap: _isPaying ? null : () => _showSnack('Apple Pay tapped (connect later)'),
                    ),
                    const SizedBox(height: 10),
                    _walletButton(
                      label: 'Google Pay',
                      filled: false,
                      onTap: _isPaying ? null : () => _showSnack('Google Pay tapped (connect later)'),
                    ),
                    const SizedBox(height: 18),

                    const Text(
                      'Other Payment',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),

                    _paypalButton(
                      onTap: _isPaying ? null : () => _showSnack('PayPal tapped (connect later)'),
                    ),
                    const SizedBox(height: 18),

                    _loyaltyPointsBox(),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomPayBar(),
    );
  }

  // ---------------- UI Parts ----------------

  Widget _headerBar() {
    return Row(
      children: [
        InkWell(
          onTap: () => Navigator.maybePop(context),
          borderRadius: BorderRadius.circular(999),
          child: Container(
            height: 34,
            width: 34,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.chevron_left, color: Colors.black54),
          ),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Text(
            'Payment Method',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }

  Widget _totalCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFBFAF6),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6D9B0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.black54,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _money(_payableTotal),
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: kGold,
                  ),
                ),
                if (_pointsToUse > 0) ...[
                  const SizedBox(height: 6),
                  Text(
                    'Applied points: -${_money(_pointsValue)}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Colors.black54,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
          TextButton(
            onPressed: () => _showSnack('Edit tapped'),
            child: const Text(
              'Edit',
              style: TextStyle(color: kGold, fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ NEW: Loyalty quick access button
  Widget _loyaltyQuickButton() {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton.icon(
        onPressed: _isPaying ? null : _goToLoyalty,
        icon: const Icon(Icons.stars_rounded, size: 18, color: kGold),
        label: const Text(
          'View Loyalty Points',
          style: TextStyle(fontWeight: FontWeight.w900, color: kGold),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: kGold, width: 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  void _goToLoyalty() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LoyaltyDashboardPage(
          previousPoints: 1200,
          pointsEarnedThisBooking: 350,
          pointsUsedInPayment: _pointsToUse.toInt(),
          lifetimeStays: 3,
          pointsThisYear: 1550,
        ),
      ),
    );
  }

  Widget _savedCard({
    required int index,
    required String brand,
    required Color brandColor,
    required String last4,
    required String expiry,
  }) {
    final isSelected = _selectedCardIndex == index;

    return InkWell(
      onTap: _isPaying ? null : () => setState(() => _selectedCardIndex = index),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? kGold : Colors.black12,
            width: isSelected ? 1.4 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 34,
              width: 52,
              decoration: BoxDecoration(
                color: brandColor,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                brand,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '•••• •••• ••••',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$last4\nExpires $expiry',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                      height: 1.15,
                    ),
                  ),
                ],
              ),
            ),
            Radio<int>(
              value: index,
              groupValue: _selectedCardIndex,
              activeColor: kGold,
              onChanged: _isPaying ? null : (v) => setState(() => _selectedCardIndex = v ?? 0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _addNewCardButton() {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: OutlinedButton.icon(
        onPressed: _isPaying ? null : () => _showSnack('Add New Card tapped'),
        icon: const Icon(Icons.add, size: 18, color: kGold),
        label: const Text(
          'Add New Card',
          style: TextStyle(fontWeight: FontWeight.w900, color: kGold),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: kGold, width: 1.2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _walletButton({
    required String label,
    required bool filled,
    required VoidCallback? onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: filled ? Colors.black : Colors.white,
          foregroundColor: filled ? Colors.white : kGold,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: filled ? null : const BorderSide(color: kGold, width: 1.2),
        ),
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
        ),
      ),
    );
  }

  Widget _paypalButton({required VoidCallback? onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0A66C2),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: const Text(
          'PayPal',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
        ),
      ),
    );
  }

  Widget _loyaltyPointsBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Loyalty Points + Cash',
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text(
            'You have 1,500 loyalty points available\n(\$150 value)',
            style: TextStyle(fontSize: 11.5, color: Colors.black54, height: 1.25),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Text('Points to use:', style: TextStyle(fontSize: 11.5, color: Colors.black54)),
              const SizedBox(width: 8),
              Text(
                _pointsToUse.toInt().toString(),
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
              ),
              const Spacer(),
              Text(
                '-${_money(_pointsValue)}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: kGold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _roundIconBtn(
                icon: Icons.remove,
                onTap: _isPaying
                    ? null
                    : () => setState(() => _pointsToUse = (_pointsToUse - 50).clamp(0, _maxPoints)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Slider(
                  value: _pointsToUse,
                  min: 0,
                  max: _maxPoints,
                  divisions: 30,
                  onChanged: _isPaying ? null : (v) => setState(() => _pointsToUse = v),
                  activeColor: kGold,
                  inactiveColor: Colors.black12,
                ),
              ),
              const SizedBox(width: 10),
              _roundIconBtn(
                icon: Icons.add,
                onTap: _isPaying
                    ? null
                    : () => setState(() => _pointsToUse = (_pointsToUse + 50).clamp(0, _maxPoints)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _bottomPayBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 48,
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kGold,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: _isPaying ? null : _onPayNow,
            child: _isPaying
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : Text(
                    'Pay Now (${_money(_payableTotal)})',
                    style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _roundIconBtn({required IconData icon, required VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 34,
        width: 34,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12),
        ),
        child: Icon(icon, size: 18, color: kGold),
      ),
    );
  }

  Future<void> _onPayNow() async {
    setState(() => _isPaying = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _isPaying = false);

    // ✅ AFTER PAYMENT: go to Booking Success Page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => BookingSuccessPage(
          totalPaid: _payableTotal,
          pointsUsed: _pointsToUse.toInt(),
          pointsEarned: 350,
        ),
      ),
    );
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
