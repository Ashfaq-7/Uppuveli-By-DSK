import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // ✅ social media sharing

class LoyaltyDashboardPage extends StatefulWidget {
  const LoyaltyDashboardPage({
    super.key,
    required this.previousPoints,
    required this.pointsEarnedThisBooking,
    required this.pointsUsedInPayment,
    required this.lifetimeStays,
    required this.pointsThisYear,
    this.referralCode = "DSK200",
    this.memberName = "Silver Member",
  });

  // ✅ Values coming from your booking/payment flow
  final int previousPoints;
  final int pointsEarnedThisBooking;
  final int pointsUsedInPayment;
  final int lifetimeStays;
  final int pointsThisYear;

  final String referralCode;
  final String memberName;

  @override
  State<LoyaltyDashboardPage> createState() => _LoyaltyDashboardPageState();
}

class _LoyaltyDashboardPageState extends State<LoyaltyDashboardPage> {
  static const Color kGold = Color(0xFFC9A633);
  static const Color kBg = Color(0xFFF9F8F3);
  static const Color kTeal1 = Color(0xFF185E6C);
  static const Color kTeal2 = Color(0xFF0B3E4A);
  static const Color kOrange = Color(0xFFFFC38F);

  // ✅ Dashboard computed values
  late int _availablePoints;
  late int _lifetimeStays;

  // ✅ Fake recent activity list (can later come from Firebase)
  late final List<_ActivityItem> _activity;

  @override
  void initState() {
    super.initState();

    // ✅ Available points must change based on booking flow:
    _availablePoints = (widget.previousPoints + widget.pointsEarnedThisBooking - widget.pointsUsedInPayment).clamp(0, 999999);

    // ✅ Booking engagement count (lifetime stays)
    // Every completed booking => lifetime stays + 1
    _lifetimeStays = widget.lifetimeStays;

    // ✅ Create "Recent Activity" list with earned/used points
    _activity = [
      _ActivityItem(
        points: widget.pointsEarnedThisBooking,
        title: "Beach Bliss booking",
        date: "Nov 25, 2025",
        isPositive: true,
      ),
      if (widget.pointsUsedInPayment > 0)
        _ActivityItem(
          points: widget.pointsUsedInPayment,
          title: "Points used in payment",
          date: "Nov 25, 2025",
          isPositive: false,
        ),
      _ActivityItem(points: 200, title: "Spa treatment", date: "Nov 24, 2025", isPositive: true),
      _ActivityItem(points: 1000, title: "Room upgrade redemption", date: "Oct 15, 2025", isPositive: false),
      _ActivityItem(points: 100, title: "Referral bonus", date: "Oct 1, 2025", isPositive: true),
    ];
  }

  // ✅ Gold tier logic
  bool get _isGold => _availablePoints >= 2000;
  String get _status => _isGold ? "Gold" : "Silver";

  int get _pointsUntilGold => _isGold ? 0 : (2000 - _availablePoints);

  double get _progressToGold => (_availablePoints / 2000).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    final progressPercent = (_progressToGold * 100).round();

    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            // ✅ Top gold bar
            Container(
              height: 44,
              width: double.infinity,
              color: kGold,
              alignment: Alignment.center,
              child: const Text(
                'Screen 6: Loyalty\nDashboard',
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
                    const Text(
                      'Your Loyalty',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 12),

                    // ✅ Main Points Card
                    _pointsCard(),
                    const SizedBox(height: 12),

                    // ✅ Progress to Gold
                    Container(
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
                          Row(
                            children: [
                              const Text(
                                "Progress to Gold",
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                              ),
                              const Spacer(),
                              Text(
                                "$progressPercent%",
                                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: kGold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(999),
                            child: LinearProgressIndicator(
                              value: _progressToGold,
                              minHeight: 8,
                              backgroundColor: const Color(0xFFEDEDED),
                              valueColor: const AlwaysStoppedAnimation(kGold),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _isGold ? "You are Gold!" : "$_pointsUntilGold points until Gold",
                            style: const TextStyle(fontSize: 11.5, color: Colors.black54, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ✅ Lifetime stays, points this year, status
                    _statsRow(),
                    const SizedBox(height: 16),

                    // ✅ Recent Activity
                    const Text(
                      'Recent Activity',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 10),

                    ..._activity.map((a) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _activityCard(a),
                        )),

                    const SizedBox(height: 18),

                    // ✅ Rewards
                    const Text(
                      'Available Rewards',
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 10),

                    _rewardCard(
                      title: "Free Spa Massage",
                      subtitle: "300 points required",
                      requiredPoints: 300,
                    ),
                    const SizedBox(height: 10),

                    _rewardCard(
                      title: "Room Upgrade",
                      subtitle: "500 points required\nUpgrade to Beach Bliss",
                      requiredPoints: 500,
                    ),
                    const SizedBox(height: 10),

                    _rewardCard(
                      title: "Free Night",
                      subtitle: "750 points required\nNeed ${(_availablePoints >= 750) ? 0 : (750 - _availablePoints)} more points",
                      requiredPoints: 750,
                      locked: _availablePoints < 750,
                    ),

                    const SizedBox(height: 18),

                    // ✅ Referral + Share section
                    _referralSection(),

                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------------------------------------------------------
  // Main Points Card
  // ----------------------------------------------------------------------------
  Widget _pointsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [kTeal1, kTeal2],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            _availablePoints.toString(),
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Available Points',
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: kOrange,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              widget.memberName,
              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------------
  // Stats row
  // ----------------------------------------------------------------------------
  Widget _statsRow() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
          _stat("Lifetime\nStays", _lifetimeStays.toString(), valueColor: kGold),
          _divider(),
          _stat("Points This\nYear", widget.pointsThisYear.toString(), valueColor: kGold),
          _divider(),
          _stat("Status", _status, valueColor: Colors.redAccent),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 34,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      color: Colors.black12,
    );
  }

  Widget _stat(String label, String value, {required Color valueColor}) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Colors.black54, height: 1.15),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: valueColor),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------------
  // Activity Card
  // ----------------------------------------------------------------------------
  Widget _activityCard(_ActivityItem item) {
    final color = item.isPositive ? Colors.green : Colors.redAccent;
    final sign = item.isPositive ? "+" : "-";

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
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
          Text(
            "$sign${item.points} points",
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: color),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(item.date, style: const TextStyle(fontSize: 11, color: Colors.black54)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------------
  // Reward Card
  // ----------------------------------------------------------------------------
  Widget _rewardCard({
    required String title,
    required String subtitle,
    required int requiredPoints,
    bool locked = false,
  }) {
    final enabled = _availablePoints >= requiredPoints;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: locked ? const Color(0xFFE7E7E7) : Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            locked ? Icons.lock_outline : Icons.card_giftcard,
            color: locked ? Colors.black38 : kGold,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 11, color: Colors.black54, height: 1.15)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 34,
            child: ElevatedButton(
              onPressed: enabled ? () => _showSnack("Redeem $title (connect later)") : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: enabled ? kGold : const Color(0xFFBDBDBD),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text(
                locked ? "Locked" : "Redeem Now",
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------------------
  // ✅ Referral section + Social share
  // ----------------------------------------------------------------------------
  Widget _referralSection() {
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
          const Text(
            "Invite friends & earn 200 points per booking",
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),

          // ✅ Referral Code box
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFBFAF6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE6D9B0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.qr_code_rounded, color: kGold, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Your referral code: ${widget.referralCode}",
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900),
                  ),
                ),
                IconButton(
                  tooltip: "Copy",
                  onPressed: () {
                    _showSnack("Referral code copied!");
                  },
                  icon: const Icon(Icons.copy, size: 18, color: kGold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ✅ Your exact bullet details
          const Text(
            "• Share your referral code with a friend\n"
            "• Your friend books a stay using your code\n"
            "• You earn 200 points after their booking is completed\n"
            "• Your friend may also receive special perks",
            style: TextStyle(
              fontSize: 11.5,
              color: Colors.black54,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 14),

          // ✅ Share Button (Social Media)
          SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: _shareReferralCode,
              icon: const Icon(Icons.share, size: 18),
              label: const Text(
                "Share Referral Code",
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: kGold,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _shareReferralCode() {
    final text =
        "Use my DSK Resort referral code: ${widget.referralCode} 🏝️\n\n"
        "• Share your referral code with a friend\n"
        "• Your friend books a stay using your code\n"
        "• You earn 200 points after their booking is completed\n"
        "• Your friend may also receive special perks\n\n"
        "Download the DSK App and book now!";

    Share.share(text);
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

// -----------------------------------------------------------------------------
// Activity model
// -----------------------------------------------------------------------------
class _ActivityItem {
  final int points;
  final String title;
  final String date;
  final bool isPositive;

  _ActivityItem({
    required this.points,
    required this.title,
    required this.date,
    required this.isPositive,
  });
}
