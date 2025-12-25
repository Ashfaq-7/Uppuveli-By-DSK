import 'package:flutter/material.dart';
import 'arrivingP.dart'; // ✅ make sure file name + class name match

class ConfirmInfoPage extends StatefulWidget {
  const ConfirmInfoPage({super.key});

  @override
  State<ConfirmInfoPage> createState() => _ConfirmInfoPageState();
}

class _ConfirmInfoPageState extends State<ConfirmInfoPage> {
  static const Color kGold = Color(0xFFC9A633);
  static const Color kBg = Color(0xFFF9F8F3);
  static const Color kFieldBg = Color(0xFFF7F5EF);
  static const Color kFieldBorder = Color(0xFFE4D8BF);

  final _firstNameCtrl = TextEditingController(text: "Sarah");
  final _lastNameCtrl = TextEditingController(text: "Johnson");
  final _emailCtrl = TextEditingController(text: "sarah.johnson@email.com");
  final _phoneCtrl = TextEditingController(text: "+1 (555) 123-4567");

  bool _isConfirmed = false;

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
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
                      "Confirm Your Information",
                      style: TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFFC9A633),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // ✅ Input fields
                    _editableField(controller: _firstNameCtrl),
                    const SizedBox(height: 12),

                    _editableField(controller: _lastNameCtrl),
                    const SizedBox(height: 12),

                    _editableField(controller: _emailCtrl),
                    const SizedBox(height: 12),

                    _editableField(controller: _phoneCtrl, keyboardType: TextInputType.phone),
                    const SizedBox(height: 18),

                    // ✅ Checkbox row
                    Row(
                      children: [
                        Checkbox(
                          value: _isConfirmed,
                          activeColor: kGold,
                          onChanged: (val) => setState(() => _isConfirmed = val ?? false),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          "Information is correct",
                          style: TextStyle(fontSize: 12, color: Colors.black54, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 4),
                        const Text(
                          "*",
                          style: TextStyle(fontSize: 14, color: Colors.red, fontWeight: FontWeight.w800),
                        ),
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
                  onPressed: _isConfirmed
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ArrivingPage()),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8FAFB2), // grey-blue like screenshot
                    disabledBackgroundColor: const Color(0xFF8FAFB2),
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
  // Step indicator widget (3 dots + "Step 1 of 3")
  // ---------------------------------------------------------------------------
  Widget _stepIndicator() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            _StepDot(isActive: true),
            SizedBox(width: 26),
            _StepDot(isActive: false),
            SizedBox(width: 26),
            _StepDot(isActive: false),
          ],
        ),
        const SizedBox(height: 10),
        const Center(
          child: Text(
            "Step 1 of 3",
            style: TextStyle(fontSize: 11.5, color: Colors.black45, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Editable field widget
  // ---------------------------------------------------------------------------
  Widget _editableField({
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: kFieldBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kFieldBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
          InkWell(
            borderRadius: BorderRadius.circular(999),
            onTap: () {
              // Optional: focus or show a snackbar
              FocusScope.of(context).requestFocus(FocusNode());
              FocusScope.of(context).unfocus();
            },
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.edit, size: 18, color: kGold),
            ),
          ),
        ],
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
