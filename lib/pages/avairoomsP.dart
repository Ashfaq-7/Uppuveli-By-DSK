import 'package:flutter/material.dart';
import 'roomdetP.dart';
import 'roomitem.dart';

class AvailableRoomsPage extends StatelessWidget {
  const AvailableRoomsPage({
    super.key,
    required this.checkIn,
    required this.checkOut,
    required this.guests,
  });

  final DateTime checkIn;
  final DateTime checkOut;
  final int guests;

  static const Color kGold = Color(0xFFC9A633);
  static const Color kBg = Color(0xFFF9F8F3);
  static const Color kTagOrange = Color(0xFFF0A46A);
  static const Color kRefundGreen = Color(0xFF57B88A);

  @override
  Widget build(BuildContext context) {
    final rooms = <RoomItem>[
      const RoomItem(
        name: 'Beach Bliss',
        imageAsset: 'assets/images/beach.png',
        sqft: 490,
        guests: 2,
        bedsLabel: '1 Bed',
        price: 220,
        points: 500,
        refundable: true,
      ),
      const RoomItem(
        name: 'Breeze Bliss',
        imageAsset: 'assets/images/breeze.png',
        sqft: 580,
        guests: 3,
        bedsLabel: '1 Bed',
        price: 200,
        points: 500,
        refundable: true,
      ),
      const RoomItem(
        name: 'Garden Bliss',
        imageAsset: 'assets/images/garden.png',
        sqft: 560,
        guests: 3,
        bedsLabel: '2 Beds',
        price: 180,
        points: 450,
        refundable: true,
      ),
    ];

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
                'Screen 2: Room\nResults',
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
              child: ListView(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
                children: [
                  _HeaderBar(
                    title: 'Available Rooms',
                    subtitle: '${_fmtRange(checkIn, checkOut)} | $guests Guests',
                    onBack: () => Navigator.maybePop(context),
                  ),
                  const SizedBox(height: 12),

                  // ✅ each room goes to RoomDetailsPage
                  ...rooms.map(
                    (r) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _RoomCard(
                        item: r,
                        onViewBook: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RoomDetailsPage(
                                room: r,
                                checkIn: checkIn,
                                checkOut: checkOut,
                                guests: guests,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Helpers for header date ----------
  static String _fmtRange(DateTime inDate, DateTime outDate) {
    String md(DateTime d) => '${_mon(d.month)} ${d.day.toString().padLeft(2, '0')}';
    return '${md(inDate)}-${md(outDate)}';
  }

  static String _mon(int m) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[m - 1];
  }
}

// ===================== Header =====================

class _HeaderBar extends StatelessWidget {
  const _HeaderBar({
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  final String title;
  final String subtitle;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onBack,
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 11, color: Colors.black54),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ===================== Card =====================

class _RoomCard extends StatelessWidget {
  const _RoomCard({required this.item, required this.onViewBook});

  static const Color kGold = Color(0xFFC9A633);
  static const Color kTagOrange = Color(0xFFF0A46A);
  static const Color kRefundGreen = Color(0xFF57B88A);

  final RoomItem item;
  final VoidCallback onViewBook;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 150,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(item.imageAsset, fit: BoxFit.cover),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.12),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: kTagOrange,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
            child: Row(
              children: [
                _MiniInfo(icon: Icons.crop_square, text: '${item.sqft} Sq Ft'),
                const SizedBox(width: 14),
                _MiniInfo(icon: Icons.people_alt_outlined, text: '${item.guests} Guests'),
                const SizedBox(width: 14),
                _MiniInfo(icon: Icons.bed_outlined, text: item.bedsLabel),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${item.price}',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w900,
                        color: kGold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 3),
                      child: Text(
                        '/ per night',
                        style: TextStyle(fontSize: 11.5, color: Colors.black54),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Earn ${item.points} points',
                  style: TextStyle(fontSize: 11, color: kGold.withOpacity(0.9)),
                ),
                const SizedBox(height: 8),
                if (item.refundable)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: kRefundGreen,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: const Text(
                      'Refundable',
                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Colors.white),
                    ),
                  ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: onViewBook,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGold,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'View & Book',
                      style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12.5),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniInfo extends StatelessWidget {
  const _MiniInfo({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.black54),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 11, color: Colors.black54)),
      ],
    );
  }
}
