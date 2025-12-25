import 'package:flutter/material.dart';
import 'checkinSuccessP.dart'; // ✅ recommended next page after complete

class RevConPage extends StatefulWidget {
  const RevConPage({super.key});

  @override
  State<RevConPage> createState() => _RevConPageState();
}

class _RevConPageState extends State<RevConPage> {
  static const Color kGold = Color(0xFFC9A633);
  static const Color kBg = Color(0xFFF9F8F3);
  static const Color kBtn = Color(0xFF8FAFB2);
  static const Color kOrange = Color(0xFFE38A2F);

  bool _agreePolicies = false;
  bool _optInOffers = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    // ✅ Step indicator
                    _stepIndicator(),
                    const SizedBox(height: 18),

                    // ✅ Title
                    const Text(
                      "Review & Confirm",
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: kGold,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // ✅ Price Breakdown
                    _priceRow("Room Rate", "\$220"),
                    const SizedBox(height: 10),
                    _priceRow("Taxes & Fees", "\$22"),

                    const SizedBox(height: 10),
                    const Divider(thickness: 1, color: Color(0xFFE6D9BF)),
                    const SizedBox(height: 10),

                    _totalRow("Total", "\$242"),
                    const SizedBox(height: 18),

                    // ✅ Checkbox 1
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _agreePolicies,
                          activeColor: kGold,
                          onChanged: (val) => setState(() => _agreePolicies = val ?? false),
                        ),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text(
                              "I agree to the room rate and cancellation policies",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Padding(
                          padding: EdgeInsets.only(top: 12),
                          child: Text(
                            "*",
                            style: TextStyle(
                              fontSize: 14,
                              color: kOrange,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // ✅ Checkbox 2
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: _optInOffers,
                          activeColor: kGold,
                          onChanged: (val) => setState(() => _optInOffers = val ?? false),
                        ),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text(
                              "Opt-in to special offers during my stay",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black54,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ✅ Bottom Buttons Row
            Container(
              padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
              decoration: BoxDecoration(
                color: kBg,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, -6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // ✅ Back button
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.black87,
                          side: const BorderSide(color: Color(0xFFD7C79D)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Back",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // ✅ Complete Check-In
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _agreePolicies
                            ? () {
                                // ✅ Navigate to success page
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const CheckInSuccessPage()),
                                );
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kBtn,
                          disabledBackgroundColor: kBtn.withOpacity(0.55),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Complete Check-In",
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                        ),
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

  // ---------------------------------------------------------------------------
  // Step indicator widget (Step 3 of 3)
  // ---------------------------------------------------------------------------
  Widget _stepIndicator() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _StepDot(isActive: true),
            SizedBox(width: 26),
            _StepDot(isActive: true),
            SizedBox(width: 26),
            _StepDot(isActive: true),
          ],
        ),
        const SizedBox(height: 10),
        const Center(
          child: Text(
            "Step 3 of 3",
            style: TextStyle(fontSize: 11.5, color: Colors.black45, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _priceRow(String left, String right) {
    return Row(
      children: [
        Expanded(
          child: Text(
            left,
            style: const TextStyle(fontSize: 12, color: Colors.black45, fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          right,
          style: const TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }

  Widget _totalRow(String left, String right) {
    return Row(
      children: [
        Expanded(
          child: Text(
            left,
            style: const TextStyle(fontSize: 12.5, color: kGold, fontWeight: FontWeight.w800),
          ),
        ),
        Text(
          right,
          style: const TextStyle(fontSize: 12.5, color: kOrange, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// Step Dot Widget
// -----------------------------------------------------------------------------
class _StepDot extends StatelessWidget {
  const _StepDot({required this.isActive});

  final bool isActive;

  static const Color kGold = Color(0xFFC9A633);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? kGold : Colors.white,
        border: Border.all(
          color: isActive ? kGold : Colors.black26,
          width: 1.2,
        ),
      ),
    );
  }
}
