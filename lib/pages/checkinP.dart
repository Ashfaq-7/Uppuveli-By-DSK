import 'package:flutter/material.dart';
import 'confirminfoP.dart'; // ✅ make sure file name + class name match

class CheckInPage extends StatelessWidget {
  const CheckInPage({super.key});

  static const Color kGold = Color(0xFFC9A633);
  static const Color kGoldDark = Color(0xFFB8962E);
  static const Color kBg = Color(0xFFF9F8F3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Title
              const Text(
                'Ready to Check In?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: kGold,
                ),
              ),
              const SizedBox(height: 14),

              // ✅ Black Top Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: const [
                    Icon(Icons.check_circle_outline, color: Colors.white, size: 32),
                    SizedBox(height: 12),
                    Text(
                      'Mobile check-in is now available for your stay',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12.5,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ✅ Booking Summary Card
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
                      'Beach Bliss',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: kGold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _infoRow(
                      leftLabel: 'Check-in:',
                      rightValue: 'Nov 25, 2025',
                    ),
                    const Divider(height: 18, thickness: 0.8, color: Color(0xFFEADFC8)),
                    _infoRow(
                      leftLabel: 'Check-out:',
                      rightValue: 'Nov 26, 2025',
                    ),
                    const Divider(height: 18, thickness: 0.8, color: Color(0xFFEADFC8)),
                    _infoRow(
                      leftLabel: 'Room:',
                      rightValue: '405',
                    ),
                    const Divider(height: 18, thickness: 0.8, color: Color(0xFFEADFC8)),
                    _infoRow(
                      leftLabel: 'Guests:',
                      rightValue: '2 people',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // ✅ Benefits list
              const _BenefitRow(
                icon: Icons.flash_on_outlined,
                title: 'Skip the front desk queue',
              ),
              const SizedBox(height: 14),
              const _BenefitRow(
                icon: Icons.key_outlined,
                title: 'Get instant mobile key access',
              ),
              const SizedBox(height: 14),
              const _BenefitRow(
                icon: Icons.call_outlined,
                title: 'Contact us anytime during your stay',
              ),

              const SizedBox(height: 22),

              // ✅ Start Check-In Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ConfirmInfoPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kGold,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Start Check-In',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ✅ Skip for now
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Skip for now',
                    style: TextStyle(fontSize: 11.5, color: Colors.black45),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _infoRow({
    required String leftLabel,
    required String rightValue,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            leftLabel,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black45,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          rightValue,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black54,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Benefit Row Widget
// -----------------------------------------------------------------------------
class _BenefitRow extends StatelessWidget {
  const _BenefitRow({
    required this.icon,
    required this.title,
  });

  final IconData icon;
  final String title;

  static const Color kGold = Color(0xFFC9A633);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: kGold.withOpacity(0.35)),
          ),
          child: Icon(icon, size: 18, color: kGold),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 12.5,
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
