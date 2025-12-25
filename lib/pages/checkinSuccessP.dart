import 'package:flutter/material.dart';
import 'homeP.dart'; // ✅ update this import if your HomePage file name is different

class CheckInSuccessPage extends StatelessWidget {
  const CheckInSuccessPage({
    super.key,
    this.resortName = "Beach Bliss",
    this.roomNumber = "405",
  });

  final String resortName;
  final String roomNumber;

  static const Color kGold = Color(0xFFC9A633);
  static const Color kBg = Color(0xFFF9F8F3);
  static const Color kBtn = Color(0xFF8FAFB2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
          child: Column(
            children: [
              const SizedBox(height: 18),

              // ✅ Top bar (close)
              Row(
                children: [
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
                    icon: const Icon(Icons.close, color: Colors.black54),
                  ),
                ],
              ),

              const SizedBox(height: 20),

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
                "Check-In Completed!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: kGold,
                ),
              ),

              const SizedBox(height: 10),

              // ✅ Message
              const Text(
                "You're all set. Your mobile key will be available shortly.\nEnjoy your stay!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  color: Colors.black54,
                  height: 1.35,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 22),

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
                    Text(
                      resortName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                        color: kGold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.meeting_room_outlined, size: 18, color: kGold),
                        const SizedBox(width: 8),
                        Text(
                          "Room $roomNumber",
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: const [
                        Icon(Icons.key_outlined, size: 18, color: kGold),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Mobile key will appear in your profile once ready",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.black54,
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ✅ View Mobile Key Button (connect later)
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Mobile key coming soon!")),
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
                    "View Mobile Key",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // ✅ Go Home Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () {
                    // ✅ Return to Home and clear stack
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomePage()),
                      (route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: kBtn,
                    side: BorderSide(color: kBtn.withOpacity(0.8)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Go to Home",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
                  ),
                ),
              ),

              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
