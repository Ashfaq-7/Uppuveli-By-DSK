import 'package:flutter/material.dart';
import 'avairoomsP.dart'; // ✅ make sure this file name matches your AvailableRoomsPage file

class RoomSearchPage extends StatefulWidget {
  const RoomSearchPage({
    super.key,
    this.selectedRoomName, // if coming from AvailableRooms tap
    this.initialGuests = 2,
    this.initialRooms = 1,
  });

  final String? selectedRoomName;
  final int initialGuests;
  final int initialRooms;

  @override
  State<RoomSearchPage> createState() => _RoomSearchPageState();
}

class _RoomSearchPageState extends State<RoomSearchPage> {
  static const Color kGold = Color(0xFFC9A633);
  static const Color kBg = Color(0xFFF9F8F3);

  DateTime? _checkIn;
  DateTime? _checkOut;

  late int _guests;
  late int _rooms;

  final TextEditingController _promoCtrl = TextEditingController();
  bool _applyMemberRate = false;

  @override
  void initState() {
    super.initState();
    _guests = widget.initialGuests;
    _rooms = widget.initialRooms;
  }

  @override
  void dispose() {
    _promoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            // Top gold bar + title (like screenshot)
            Container(
              height: 44,
              width: double.infinity,
              color: kGold,
              alignment: Alignment.center,
              child: const Text(
                'Screen 1: Room\nSearch',
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
              child: Stack(
                children: [
                  // Background image (LOCAL ASSET)
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/room.png', // <-- put your image here
                      fit: BoxFit.cover,
                    ),
                  ),

                  // Dark overlay for readability
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withOpacity(0.35),
                    ),
                  ),

                  // Content
                  Center(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),

                          // Title text
                          const Text(
                            'Find Your\nStay',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                              height: 1.1,
                            ),
                          ),

                          if ((widget.selectedRoomName ?? '').trim().isNotEmpty) ...[
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.92),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                'Selected: ${widget.selectedRoomName}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 18),

                          // White card
                          _buildFormCard(context),

                          const SizedBox(height: 14),
                        ],
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

  Widget _buildFormCard(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 420),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Check-in'),
          const SizedBox(height: 6),
          _dateField(
            context,
            value: _checkIn,
            onPick: () => _pickDate(isCheckIn: true),
          ),

          const SizedBox(height: 14),

          _label('Check-out'),
          const SizedBox(height: 6),
          _dateField(
            context,
            value: _checkOut,
            onPick: () => _pickDate(isCheckIn: false),
          ),

          const SizedBox(height: 14),

          _label('Guests'),
          const SizedBox(height: 6),
          _stepperField(
            value: _guests,
            onMinus: () => setState(() => _guests = (_guests > 1) ? _guests - 1 : 1),
            onPlus: () => setState(() => _guests = _guests + 1),
          ),

          const SizedBox(height: 14),

          _label('Rooms'),
          const SizedBox(height: 6),
          _stepperField(
            value: _rooms,
            onMinus: () => setState(() => _rooms = (_rooms > 1) ? _rooms - 1 : 1),
            onPlus: () => setState(() => _rooms = _rooms + 1),
          ),

          const SizedBox(height: 14),

          Row(
            children: const [
              Text(
                'Promo Code',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
              ),
              SizedBox(width: 10),
              Text(
                '(optional)',
                style: TextStyle(fontSize: 11.5, color: Colors.black45, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _textField(controller: _promoCtrl, hint: 'Have a code?'),

          const SizedBox(height: 14),

          // Apply member rate row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Apply member rate',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700),
              ),
              Switch(
                value: _applyMemberRate,
                onChanged: (v) => setState(() => _applyMemberRate = v),
                activeColor: kGold,
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Find Rooms button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _onFindRooms,
              style: ElevatedButton.styleFrom(
                backgroundColor: kGold,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'Find Rooms',
                style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) {
    return Text(text, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700));
  }

  Widget _dateField(BuildContext context, {required DateTime? value, required VoidCallback onPick}) {
    final text = (value == null) ? 'mm/dd/yyyy' : _fmt(value);

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onPick,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 13,
                  color: value == null ? Colors.black38 : Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.calendar_today_outlined, size: 18, color: Colors.black45),
            const SizedBox(width: 10),
            const Icon(Icons.calendar_month, size: 18, color: kGold),
          ],
        ),
      ),
    );
  }

  Widget _stepperField({
    required int value,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: Row(
        children: [
          _circleBtn(icon: Icons.remove, onTap: onMinus),
          const Spacer(),
          Text(
            '$value',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
          ),
          const Spacer(),
          _circleBtn(icon: Icons.add, onTap: onPlus),
        ],
      ),
    );
  }

  Widget _circleBtn({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 34,
        width: 34,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.95),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black12),
        ),
        child: Icon(icon, size: 18, color: kGold),
      ),
    );
  }

  Widget _textField({required TextEditingController controller, required String hint}) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black38, fontSize: 13),
          filled: true,
          fillColor: const Color(0xFFF6F6F6),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.black12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: kGold, width: 1.2),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate({required bool isCheckIn}) async {
    final now = DateTime.now();

    final initial = isCheckIn ? (_checkIn ?? now) : (_checkOut ?? (_checkIn ?? now));
    final firstDate = now;
    final lastDate = DateTime(now.year + 2);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked == null) return;

    setState(() {
      if (isCheckIn) {
        _checkIn = picked;

        // if checkout exists but is before checkin, clear it
        if (_checkOut != null && _checkOut!.isBefore(_checkIn!)) {
          _checkOut = null;
        }
      } else {
        // if no checkin yet, set checkin first
        if (_checkIn == null) {
          _checkIn = picked;
          _checkOut = null;
        } else {
          _checkOut = picked;
        }
      }
    });
  }

  String _fmt(DateTime d) {
    final mm = d.month.toString().padLeft(2, '0');
    final dd = d.day.toString().padLeft(2, '0');
    final yy = d.year.toString();
    return '$mm/$dd/$yy';
  }

  void _onFindRooms() {
    // ✅ Validation: must choose BOTH check-in and check-out
    if (_checkIn == null || _checkOut == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select check-in and check-out dates')),
      );
      return;
    }

    // ✅ Ensure checkout is after checkin (not same day or before)
    if (!_checkOut!.isAfter(_checkIn!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Check-out must be after check-in')),
      );
      return;
    }

    // ✅ Navigate to AvailableRoomsPage WITH the selected dates + guests
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AvailableRoomsPage(
          checkIn: _checkIn!,
          checkOut: _checkOut!,
          guests: _guests,
        ),
      ),
    );
  }
}
