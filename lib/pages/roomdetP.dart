import 'package:flutter/material.dart';
import 'roomitem.dart';
import 'pricing_model.dart';
import 'bookingP.dart'; // update path to your BookingSummaryPage

class RoomDetailsPage extends StatefulWidget {
  const RoomDetailsPage({
    super.key,
    required this.room,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
  });

  final RoomItem room;
  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;

  int get nights {
    final d = checkOut.difference(checkIn).inDays;
    return d < 1 ? 1 : d;
  }

  @override
  State<RoomDetailsPage> createState() => _RoomDetailsPageState();
}

class _RoomDetailsPageState extends State<RoomDetailsPage> {
  static const Color kGold = Color(0xFFC9A633);
  static const Color kBg = Color(0xFFF9F8F3);

  late Future<PricingBreakdown> _pricingFuture;

  // ✅ for cancellation expand/collapse
  bool _cancelExpanded = false;

  @override
  void initState() {
    super.initState();
    _pricingFuture = _fetchPricing(); // ✅ management/auto pricing
  }

  // ✅ Replace this with your real backend/Firebase pricing logic later
  Future<PricingBreakdown> _fetchPricing() async {
    await Future.delayed(const Duration(milliseconds: 700)); // simulate loading

    final nights = widget.nights;
    final baseRate = widget.room.price.toDouble();

    // Example auto-calculation (you can change rules):
    final baseTotal = baseRate * nights;
    final taxesFees = baseTotal * 0.10; // 10% tax example
    final promoDiscount = 0.0; // management can apply promos here

    return PricingBreakdown(
      baseRatePerNight: baseRate,
      nights: nights,
      taxesFees: taxesFees,
      promoDiscount: promoDiscount,
    );
  }

  String _money(double v) => '\$${v.toStringAsFixed(0)}';

  String _fmt(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    final yy = d.year.toString();
    return '$mm/$dd/$yy';
  }

  String get _dateRange => '${_fmt(widget.checkIn)} - ${_fmt(widget.checkOut)}';

  String _roomDescription(String roomName) {
    return 'Experience the ultimate beach luxury in your $roomName suite. '
        'Wake up to a stunning ocean view, enjoy direct beach access, '
        'and unwind on your private balcony. This spacious room features modern amenities.';
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.room;

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
                'Screen 3: Room\nDetails',
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
                    _headerBar(context, title: r.name),
                    const SizedBox(height: 10),

                    _heroImage(r),
                    const SizedBox(height: 10),

                    // price / sqft / guests row like your screenshot
                    _topInfoStrip(r),
                    const SizedBox(height: 12),

                    _descriptionCard(_roomDescription(r.name)),
                    const SizedBox(height: 12),

                    _goldDivider(),
                    const SizedBox(height: 12),

                    _sectionTitle('Amenities'),
                    const SizedBox(height: 8),
                    _amenitiesGrid(),
                    const SizedBox(height: 12),

                    _infoCard(
                      title: 'Room Details',
                      child: _roomDetails(r),
                    ),
                    const SizedBox(height: 12),

                    // ✅ Price Breakdown (LOADING -> then data)
                    _infoCard(
                      title: 'Price Breakdown',
                      child: FutureBuilder<PricingBreakdown>(
                        future: _pricingFuture,
                        builder: (context, snap) {
                          if (snap.connectionState != ConnectionState.done) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 18),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          if (snap.hasError || !snap.hasData) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Failed to load pricing.',
                                  style: TextStyle(fontSize: 11.5, color: Colors.red),
                                ),
                                const SizedBox(height: 8),
                                TextButton(
                                  onPressed: () => setState(() => _pricingFuture = _fetchPricing()),
                                  child: const Text('Retry'),
                                ),
                              ],
                            );
                          }

                          final p = snap.data!;
                          return _priceBreakdown(p);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),

                    _earnPointsBox(r.points),
                    const SizedBox(height: 10),

                    _redeemBox(),
                    const SizedBox(height: 12),

                    // ✅ FIX: use cancellation policy card (your screenshot style)
                    _cancellationPolicyCard(),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),

      // ✅ Continue -> BookingSummaryPage (only when pricing is ready)
      bottomNavigationBar: FutureBuilder<PricingBreakdown>(
        future: _pricingFuture,
        builder: (context, snap) {
          final loading = snap.connectionState != ConnectionState.done || !snap.hasData;

          return _bottomBookBar(
            enabled: !loading,
            totalText: loading ? 'Loading...' : _money(snap.data!.total),
            onTap: loading
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookingSummaryPage(
                          room: widget.room,
                          checkIn: widget.checkIn,
                          checkOut: widget.checkOut,
                          guests: widget.guests,
                          pricing: snap.data!,
                        ),
                      ),
                    );
                  },
          );
        },
      ),
    );
  }

  // ---------------- UI ----------------

  Widget _goldDivider() {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: BoxDecoration(
        color: kGold,
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  Widget _headerBar(BuildContext context, {required String title}) {
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
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _heroImage(RoomItem room) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        height: 160,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(room.imageAsset, fit: BoxFit.cover),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topInfoStrip(RoomItem r) {
    // Matches your screenshot line: "$220/night | 490 Sq Ft | 2 Guests"
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
      child: Row(
        children: [
          Text(
            '${_money(r.price.toDouble())}/night',
            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: kGold),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${r.sqft} Sq Ft  |  ${widget.guests} Guests',
              style: const TextStyle(fontSize: 11.2, fontWeight: FontWeight.w800, color: Colors.black54),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _descriptionCard(String text) {
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
      child: Text(
        text,
        style: const TextStyle(fontSize: 12.5, color: Colors.black87, height: 1.3),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: kGold),
    );
  }

  Widget _amenitiesGrid() {
    final amenities = const <_Amenity>[
      _Amenity(label: 'Sea View', icon: Icons.waves_outlined),
      _Amenity(label: 'Air\nconditioning', icon: Icons.ac_unit_outlined),
      _Amenity(label: 'WiFi', icon: Icons.wifi),
      _Amenity(label: 'Beach Access', icon: Icons.beach_access_outlined),
      _Amenity(label: 'Bathroom', icon: Icons.bathtub_outlined),
      _Amenity(label: 'Safe', icon: Icons.lock_outline),
      _Amenity(label: 'Mini-bar', icon: Icons.local_bar_outlined),
      _Amenity(label: 'Balcony', icon: Icons.balcony_outlined),
      _Amenity(label: 'Premium\nToiletries', icon: Icons.spa_outlined),
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
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
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: amenities.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.05,
        ),
        itemBuilder: (context, index) {
          return _AmenityTile(amenity: amenities[index]);
        },
      ),
    );
  }

  Widget _infoCard({required String title, required Widget child}) {
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

  Widget _roomDetails(RoomItem r) {
    return Column(
      children: [
        _kv('Room Size', '${r.sqft} Sq Ft'),
        _kv('Occupancy', 'Up to ${widget.guests} guests'),
        _kv('Beds', r.bedsLabel),
        _kv('Bathroom', 'Ensuite with rainfall shower'),
        _kv('Dates', _dateRange),
      ],
    );
  }

  Widget _kv(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(k, style: const TextStyle(fontSize: 11.5, color: Colors.black54))),
          Text(v, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }

  Widget _priceBreakdown(PricingBreakdown p) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Base rate: ${_money(p.baseRatePerNight)} × ${p.nights} night',
                style: const TextStyle(fontSize: 11.5, color: Colors.black54),
              ),
            ),
            Text(_money(p.baseTotal), style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Expanded(
              child: Text('Taxes & fees', style: TextStyle(fontSize: 11.5, color: Colors.black54)),
            ),
            Text('+${_money(p.taxesFees)}', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            const Expanded(
              child: Text('Promo discount', style: TextStyle(fontSize: 11.5, color: Colors.green)),
            ),
            Text(
              '-${_money(p.promoDiscount)}',
              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: Colors.green),
            ),
          ],
        ),
        const SizedBox(height: 12),
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

  Widget _earnPointsBox(int points) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F1E3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Earn $points points on this booking',
              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800),
            ),
          ),
          const Icon(Icons.check_circle, color: kGold, size: 20),
        ],
      ),
    );
  }

  Widget _redeemBox() {
    return Row(
      children: const [
        Icon(Icons.check_box_outline_blank, color: Colors.black54, size: 18),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'I want to redeem loyalty points',
            style: TextStyle(fontSize: 11.5, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  // ✅ FIXED cancellation policy widget
  Widget _cancellationPolicyCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE7D7B2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => setState(() => _cancelExpanded = !_cancelExpanded),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Cancellation Policy',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w900,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Icon(
                    _cancelExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: kGold,
                    size: 26,
                  ),
                ],
              ),
            ),
          ),
          if (_cancelExpanded) ...[
            const Divider(height: 1, color: Color(0xFFEDEDED)),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Text(
                '• Free cancellation up to 48 hours before check-in.\n'
                '• If you cancel within 48 hours, you may be charged for 1 night.\n'
                '• No-shows will be charged the full first night.\n'
                '• Refunds (if eligible) are processed within 5–7 business days.',
                style: TextStyle(
                  fontSize: 11.8,
                  color: Colors.black54,
                  height: 1.35,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _bottomBookBar({
    required bool enabled,
    required String totalText,
    required VoidCallback? onTap,
  }) {
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
            onPressed: enabled ? onTap : null,
            child: Text(
              'Continue ($totalText)',
              style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------- Amenities ----------------

class _Amenity {
  final String label;
  final IconData icon;
  const _Amenity({required this.label, required this.icon});
}

class _AmenityTile extends StatelessWidget {
  const _AmenityTile({required this.amenity});

  static const Color kGold = Color(0xFFC9A633);
  final _Amenity amenity;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(amenity.icon, color: kGold, size: 22),
          const SizedBox(height: 8),
          Text(
            amenity.label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, height: 1.05),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
