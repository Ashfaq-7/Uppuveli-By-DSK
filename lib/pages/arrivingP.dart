import 'package:flutter/material.dart';
import 'revconP.dart'; // ✅ make sure file name + class name match

class ArrivingPage extends StatefulWidget {
  const ArrivingPage({super.key});

  @override
  State<ArrivingPage> createState() => _ArrivingPageState();
}

class _ArrivingPageState extends State<ArrivingPage> {
  static const Color kGold = Color(0xFFC9A633);
  static const Color kBg = Color(0xFFF9F8F3);
  static const Color kFieldBg = Color(0xFFF7F5EF);
  static const Color kFieldBorder = Color(0xFFE4D8BF);
  static const Color kBtn = Color(0xFF8FAFB2);
  static const Color kOrange = Color(0xFFE38A2F);

  String? _arrivalTime; // dropdown selection
  bool _lateArrival = false;

  final TextEditingController _requestsCtrl = TextEditingController();

  final List<String> _times = const [
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "1:00 PM",
    "2:00 PM",
    "3:00 PM",
    "4:00 PM",
    "5:00 PM",
    "6:00 PM",
    "7:00 PM",
    "8:00 PM",
    "9:00 PM",
    "10:00 PM",
    "11:00 PM",
    "After 11:00 PM",
  ];

  @override
  void dispose() {
    _requestsCtrl.dispose();
    super.dispose();
  }

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
                      "When are you arriving?",
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: kGold,
                      ),
                    ),
                    const SizedBox(height: 18),

                    // ✅ Arrival Time label
                    const Text(
                      "Arrival Time",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ✅ Dropdown field
                    _arrivalDropdown(),
                    const SizedBox(height: 18),

                    // ✅ Special Requests label
                    const Text(
                      "Special Requests",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // ✅ Special Requests text box
                    _specialRequestsBox(),
                    const SizedBox(height: 14),

                    // ✅ Late arrival row
                    Row(
                      children: [
                        Checkbox(
                          value: _lateArrival,
                          activeColor: kGold,
                          onChanged: (val) => setState(() => _lateArrival = val ?? false),
                        ),
                        const SizedBox(width: 6),
                        const Expanded(
                          child: Text(
                            "Late arrival (arriving after 11:00 PM)",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.info_outline, size: 18, color: kOrange),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ✅ Bottom Next Button (fixed)
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
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const RevConPage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kBtn,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Next Step →",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Step indicator widget (3 dots + "Step 2 of 3")
  // ---------------------------------------------------------------------------
  Widget _stepIndicator() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _StepDot(isActive: true),  // Step 1 completed
            SizedBox(width: 26),
            _StepDot(isActive: true),  // Step 2 active
            SizedBox(width: 26),
            _StepDot(isActive: false), // Step 3 not active
          ],
        ),
        const SizedBox(height: 10),
        const Center(
          child: Text(
            "Step 2 of 3",
            style: TextStyle(fontSize: 11.5, color: Colors.black45, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Arrival dropdown
  // ---------------------------------------------------------------------------
  Widget _arrivalDropdown() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: kFieldBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kFieldBorder),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _arrivalTime,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black54),
          hint: const Text(
            "-- Select time --",
            style: TextStyle(fontSize: 13, color: Colors.black45, fontWeight: FontWeight.w600),
          ),
          items: _times
              .map(
                (t) => DropdownMenuItem(
                  value: t,
                  child: Text(
                    t,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              )
              .toList(),
          onChanged: (val) => setState(() => _arrivalTime = val),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Special requests text box
  // ---------------------------------------------------------------------------
  Widget _specialRequestsBox() {
    return Container(
      height: 115,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: kFieldBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kFieldBorder),
      ),
      child: TextField(
        controller: _requestsCtrl,
        maxLines: null,
        expands: true,
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: "Any special requests? (early arrival, high floor, etc.)",
          hintStyle: TextStyle(fontSize: 12.5, color: Colors.black38, fontWeight: FontWeight.w600),
        ),
      ),
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
