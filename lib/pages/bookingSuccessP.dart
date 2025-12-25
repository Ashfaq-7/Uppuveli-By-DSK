import 'package:flutter/material.dart';
import 'loyaltyP.dart';
import 'homeP.dart'; // ✅ change if your home file name differs

class BookingSuccessPage extends StatelessWidget {
  const BookingSuccessPage({
    super.key,
    required this.totalPaid,
    required this.pointsUsed,
    required this.pointsEarned,
  });

  final double totalPaid;
  final int pointsUsed;
  final int pointsEarned;

  static const Color kGold = Color(0xFFC9A633);
  static const Color kBg = Color(0xFFF9F8F3);
  static const Color kBtn = Color(0xFF8FAFB2);

  String _money(double v) => '\$${v.toStringAsFixed(2)}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          child: Column(
            children: [
              const SizedBox(height: 22),

              // ✅ Success Icon
              Container(
                height: 96,
                width: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kGold.withOpacity(0.15),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: kGold,
                  size: 56,
                ),
              ),

              const SizedBox(height: 18),

              // ✅ Title
              const Text(
                "Booking Confirmed!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: kGold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "Thank you! Your reservation has been confirmed.\nWe’ve sent a confirmation to your email.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.black54,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 20),

              // ✅ Summary Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE8DCC1)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Payment Summary",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: kGold,
                      ),
                    ),
                    const SizedBox(height: 12),

                    _twoCol("Total Paid", _money(totalPaid)),
                    const SizedBox(height: 10),
                    _twoCol("Points Used", pointsUsed.toString()),
                    const SizedBox(height: 10),
                    _twoCol("Points Earned", pointsEarned.toString()),
                  ],
                ),
              ),

              const Spacer(),

              // ✅ View Loyalty
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LoyaltyDashboardPage(
                          previousPoints: 1200,
                          pointsEarnedThisBooking: pointsEarned,
                          pointsUsedInPayment: pointsUsed,
                          lifetimeStays: 3,
                          pointsThisYear: 1550,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGold,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    "View Loyalty Points",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ✅ Go Home (clear stack)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                      (route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kBtn,
                    side: BorderSide(color: kBtn.withOpacity(0.9)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    "Go to Home",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _twoCol(String left, String right) {
    return Row(
      children: [
        Expanded(
          child: Text(
            left,
            style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w700),
          ),
        ),
        Text(
          right,
          style: const TextStyle(fontSize: 12, color: Colors.black87, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}
