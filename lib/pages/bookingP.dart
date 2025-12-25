import 'package:flutter/material.dart';
import 'roomitem.dart';
import 'pricing_model.dart';
import 'payP.dart'; 

class BookingSummaryPage extends StatefulWidget {
  const BookingSummaryPage({
    super.key,
    required this.room,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
    required this.pricing,
  });

  final RoomItem room;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;
  final PricingBreakdown pricing;

  @override
  State<BookingSummaryPage> createState() => _BookingSummaryPageState();
}

class _BookingSummaryPageState extends State<BookingSummaryPage> {
  static const Color kGold = Color(0xFFC9A633);
  static const Color kBg = Color(0xFFF9F8F3);

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _specialReq = TextEditingController();
  final _loyaltyId = TextEditingController(text: 'UP-12345');

  String _arrivalTime = 'Before 3 PM';
  bool _lateArrival = false;

  bool _acceptPolicy = false;
  bool _optInPromo = false;

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _specialReq.dispose();
    _loyaltyId.dispose();
    super.dispose();
  }

  String _money(double v) => '\$${v.toStringAsFixed(0)}';

  String _fmtPretty(DateTime d) {
    const months = [
      'January','February','March','April','May','June',
      'July','August','September','October','November','December'
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  InputDecoration _fieldDeco(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF6F6F6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.pricing;

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: 44,
              width: double.infinity,
              color: kGold,
              alignment: Alignment.center,
              child: const Text(
                'Screen 4: Booking\nSummary',
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
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _pageHeader(context),
                    const SizedBox(height: 12),

                    _card(title: 'Stay', child: _staySummary(p)),
                    const SizedBox(height: 12),

                    _card(title: 'Guest\nInformation', child: _guestInfo()),
                    const SizedBox(height: 12),

                    _card(title: 'Arrival Details', child: _arrivalDetails()),
                    const SizedBox(height: 12),

                    _card(title: 'Terms & Conditions', child: _terms()),
                    const SizedBox(height: 18),

                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kGold,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: _onConfirm,
                        child: Text(
                          'Confirm Booking (${_money(p.total)})',
                          style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900),
                        ),
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

  Widget _pageHeader(BuildContext context) {
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
            'Confirm Your Booking',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
          ),
        ),
      ],
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  Widget _staySummary(PricingBreakdown p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _twoCol('Check-in', _fmtPretty(widget.checkIn)),
        const SizedBox(height: 8),
        _twoCol('Check-out', _fmtPretty(widget.checkOut)),
        const SizedBox(height: 8),
        _twoCol('Room', widget.room.name),
        const SizedBox(height: 8),
        _twoCol('Guests', '${widget.guests} people'),

        const SizedBox(height: 12),
        const Divider(height: 1),
        const SizedBox(height: 10),

        _twoCol('Base rate: ${_money(p.baseRatePerNight)} × ${p.nights} night', _money(p.baseTotal)),
        const SizedBox(height: 8),
        _twoCol('Taxes & fees', '+${_money(p.taxesFees)}'),
        const SizedBox(height: 8),
        _twoCol('Promo discount', '-${_money(p.promoDiscount)}', valueColor: Colors.green, leftColor: Colors.green),

        const SizedBox(height: 10),
        const Divider(height: 1),
        const SizedBox(height: 10),

        Row(
          children: [
            const Expanded(
              child: Text('Total', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: kGold)),
            ),
            Text(_money(p.total), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: kGold)),
          ],
        ),
      ],
    );
  }

  Widget _guestInfo() {
    return Column(
      children: [
        _labeled('First Name', TextField(controller: _firstName, decoration: _fieldDeco('John'))),
        const SizedBox(height: 10),
        _labeled('Last Name', TextField(controller: _lastName, decoration: _fieldDeco('Doe'))),
        const SizedBox(height: 10),
        _labeled('Email', TextField(controller: _email, decoration: _fieldDeco('john.doe@example.com'))),
        const SizedBox(height: 10),
        _labeled('Phone Number', TextField(controller: _phone, decoration: _fieldDeco('+1 (555) 123-4567'))),
        const SizedBox(height: 10),
        _labeled(
          'Special Requests',
          TextField(
            controller: _specialReq,
            maxLines: 3,
            decoration: _fieldDeco('High floor preferred, early arrival, etc.'),
          ),
        ),
        const SizedBox(height: 10),
        _labeled('Loyalty #', TextField(controller: _loyaltyId, decoration: _fieldDeco('UP-12345'))),
      ],
    );
  }

  Widget _arrivalDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Arrival Time', style: TextStyle(fontSize: 11.5, color: Colors.black54)),
        const SizedBox(height: 6),
        Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF6F6F6),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _arrivalTime,
              isExpanded: true,
              items: const [
                DropdownMenuItem(value: 'Before 3 PM', child: Text('Before 3 PM')),
                DropdownMenuItem(value: 'After 3 PM', child: Text('After 3 PM')),
                DropdownMenuItem(value: 'After 6 PM', child: Text('After 6 PM')),
                DropdownMenuItem(value: 'After 9 PM', child: Text('After 9 PM')),
              ],
              onChanged: (v) {
                if (v == null) return;
                setState(() => _arrivalTime = v);
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Checkbox(
              value: _lateArrival,
              activeColor: kGold,
              onChanged: (v) => setState(() => _lateArrival = v ?? false),
            ),
            const Expanded(
              child: Text('Late arrival (after 11 PM)', style: TextStyle(fontSize: 11.5)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _terms() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _acceptPolicy,
              activeColor: kGold,
              onChanged: (v) => setState(() => _acceptPolicy = v ?? false),
            ),
            const Expanded(
              child: Text('I accept the cancellation policy and\nterms.', style: TextStyle(fontSize: 11.5, height: 1.25)),
            ),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Checkbox(
              value: _optInPromo,
              activeColor: kGold,
              onChanged: (v) => setState(() => _optInPromo = v ?? false),
            ),
            const Expanded(
              child: Text('Opt-in to promotional emails\n(optional)', style: TextStyle(fontSize: 11.5, height: 1.25)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _labeled(String label, Widget field) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12.0, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        field,
      ],
    );
  }

  Widget _twoCol(String left, String right, {Color? leftColor, Color? valueColor}) {
    return Row(
      children: [
        Expanded(child: Text(left, style: TextStyle(fontSize: 11.5, color: leftColor ?? Colors.black54))),
        Text(right, style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: valueColor)),
      ],
    );
  }

void _onConfirm() {
  if (_firstName.text.trim().isEmpty ||
      _lastName.text.trim().isEmpty ||
      _email.text.trim().isEmpty ||
      _phone.text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please fill all guest information fields')),
    );
    return;
  }

  if (!_acceptPolicy) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please accept Terms & Conditions')),
    );
    return;
  }

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => PaymentMethodPage(
        totalAmount: widget.pricing.total,
      ),
    ),
  );
 }
}