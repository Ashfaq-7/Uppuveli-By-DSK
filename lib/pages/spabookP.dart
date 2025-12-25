import 'package:flutter/material.dart';

class SpaBookingPage extends StatefulWidget {
  const SpaBookingPage({
    super.key,
    required this.treatmentName,
    required this.minutes,
    required this.price,
    required this.imageAsset,
  });

  final String treatmentName;
  final int minutes;
  final double price;
  final String imageAsset;

  @override
  State<SpaBookingPage> createState() => _SpaBookingPageState();
}

class _SpaBookingPageState extends State<SpaBookingPage> {
  static const Color kGold = Color(0xFFC9A633);
  static const Color kBg = Color(0xFFF9F8F3);
  static const Color kBorder = Color(0xFFE7D7B2);

  // Calendar
  late DateTime _month;
  DateTime? _selectedDate;

  // Time slots
  String? _selectedTime;
  final List<String> _timeSlots = const [
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "2:00 PM",
    "3:00 PM",
    "4:00 PM",
    "5:00 PM",
    "6:00 PM",
  ];

  // Therapist
  String _therapistOption = "assigned"; // assigned / choose
  String? _selectedTherapist;

  // Special requests
  final TextEditingController _specialReq = TextEditingController();

  // First time guest
  bool _firstTimeGuest = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  @override
  void dispose() {
    _specialReq.dispose();
    super.dispose();
  }

  double get _tax => (widget.price * 0.10); // 10% tax example
  double get _total => widget.price + _tax;

  String _money(double v) => "\$${v.toStringAsFixed(2)}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _treatmentHeader(),
                    const SizedBox(height: 14),

                    const Text(
                      "Select Date",
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    _calendarCard(),
                    const SizedBox(height: 16),

                    const Text(
                      "Select Time",
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    _timeGrid(),
                    const SizedBox(height: 18),

                    const Text(
                      "Choose Therapist (Optional)",
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    _therapistBox(),
                    const SizedBox(height: 18),

                    const Text(
                      "Special Requests",
                      style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(height: 8),
                    _specialRequestsField(),
                    const SizedBox(height: 14),

                    _firstTimeRow(),
                    const SizedBox(height: 20),

                    _priceSummary(),
                  ],
                ),
              ),
            ),

            _bottomButton(),
          ],
        ),
      ),
    );
  }

  // ---------------- Top Bar ----------------

  Widget _topBar(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      alignment: Alignment.centerLeft,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 28),
            onPressed: () => Navigator.maybePop(context),
          ),
          const SizedBox(width: 4),
          const Text(
            "Book Your Spa",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900),
          ),
        ],
      ),
    );
  }

  // ---------------- Treatment Header ----------------

  Widget _treatmentHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
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
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              widget.imageAsset,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.treatmentName,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12.8),
                ),
                const SizedBox(height: 4),
                Text(
                  "${widget.minutes} min  |  ${_money(widget.price)}",
                  style: const TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w700,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Calendar ----------------

  Widget _calendarCard() {
    final days = _daysForMonth(_month);
    final firstWeekday = DateTime(_month.year, _month.month, 1).weekday; // Mon=1..Sun=7

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kBorder),
      ),
      child: Column(
        children: [
          // month header
          Row(
            children: [
              IconButton(
                onPressed: () => setState(() {
                  _month = DateTime(_month.year, _month.month - 1);
                }),
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "${_monthName(_month.month)}  ${_month.year}",
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
              IconButton(
                onPressed: () => setState(() {
                  _month = DateTime(_month.year, _month.month + 1);
                }),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // weekday labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _CalLabel("Sun"),
              _CalLabel("Mon"),
              _CalLabel("Tue"),
              _CalLabel("Wed"),
              _CalLabel("Thu"),
              _CalLabel("Fri"),
              _CalLabel("Sat"),
            ],
          ),
          const SizedBox(height: 8),

          // days grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 42, // 6 weeks
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              final dayIndex = index - (firstWeekday % 7); // shift: Sunday start

              if (dayIndex < 0 || dayIndex >= days.length) {
                return const SizedBox();
              }

              final date = DateTime(_month.year, _month.month, days[dayIndex]);
              final selected = _selectedDate != null &&
                  date.year == _selectedDate!.year &&
                  date.month == _selectedDate!.month &&
                  date.day == _selectedDate!.day;

              final isPast = date.isBefore(DateTime.now().subtract(const Duration(days: 1)));

              return InkWell(
                onTap: isPast
                    ? null
                    : () => setState(() {
                          _selectedDate = date;
                        }),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? Colors.black : const Color(0xFFEDEDED),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "${days[dayIndex]}",
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w900,
                      fontSize: 11.5,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<int> _daysForMonth(DateTime d) {
    final lastDay = DateTime(d.year, d.month + 1, 0).day;
    return List.generate(lastDay, (i) => i + 1);
  }

  String _monthName(int m) {
    const months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December",
    ];
    return months[m - 1];
  }

  // ---------------- Time Grid ----------------

  Widget _timeGrid() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _timeSlots.map((slot) {
        final selected = _selectedTime == slot;
        final disabled = slot == "12:00 PM"; // example disabled slot

        return InkWell(
          onTap: disabled
              ? null
              : () => setState(() {
                    _selectedTime = slot;
                  }),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 100,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: disabled
                  ? const Color(0xFFF0F0F0)
                  : selected
                      ? kGold.withOpacity(0.18)
                      : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: disabled
                    ? Colors.black12
                    : selected
                        ? kGold
                        : kBorder,
                width: selected ? 1.6 : 1.0,
              ),
            ),
            child: Text(
              slot,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 11.5,
                color: disabled
                    ? Colors.black26
                    : selected
                        ? kGold
                        : Colors.black87,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ---------------- Therapist ----------------

  Widget _therapistBox() {
    return Column(
      children: [
        _radioRow(
          value: "assigned",
          title: "Assigned Therapist",
          subtitle: "We will assign our best available therapist",
        ),
        const SizedBox(height: 10),
        _radioRow(
          value: "choose",
          title: "Choose Therapist",
          subtitle: null,
        ),

        if (_therapistOption == "choose") ...[
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: kBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: _selectedTherapist,
                hint: const Text("Select a therapist"),
                items: const [
                  DropdownMenuItem(value: "Therapist A", child: Text("Therapist A")),
                  DropdownMenuItem(value: "Therapist B", child: Text("Therapist B")),
                  DropdownMenuItem(value: "Therapist C", child: Text("Therapist C")),
                ],
                onChanged: (v) => setState(() => _selectedTherapist = v),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _radioRow({
    required String value,
    required String title,
    String? subtitle,
  }) {
    final selected = _therapistOption == value;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: selected ? kGold : kBorder, width: selected ? 1.4 : 1),
      ),
      child: Row(
        children: [
          Radio<String>(
            value: value,
            groupValue: _therapistOption,
            activeColor: kGold,
            onChanged: (v) {
              if (v == null) return;
              setState(() {
                _therapistOption = v;
                if (v == "assigned") _selectedTherapist = null;
              });
            },
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 11.5, color: Colors.black54),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- Special requests ----------------

  Widget _specialRequestsField() {
    return TextField(
      controller: _specialReq,
      maxLines: 3,
      decoration: InputDecoration(
        hintText: "Any preferences or allergies?",
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: kBorder),
        ),
      ),
    );
  }

  // ---------------- First time ----------------

  Widget _firstTimeRow() {
    return Row(
      children: [
        Checkbox(
          value: _firstTimeGuest,
          activeColor: kGold,
          onChanged: (v) => setState(() => _firstTimeGuest = v ?? false),
        ),
        const Text(
          "First-time guest?",
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        const SizedBox(width: 6),
        const Icon(Icons.info_outline, size: 16, color: Colors.black45),
      ],
    );
  }

  // ---------------- Price Summary ----------------

  Widget _priceSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 14, 12, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        children: [
          _kv("Treatment", _money(widget.price)),
          const SizedBox(height: 8),
          _kv("Tax", _money(_tax)),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              const Expanded(
                child: Text(
                  "Total",
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                ),
              ),
              Text(
                _money(_total),
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: kGold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Row(
      children: [
        Expanded(
          child: Text(
            k,
            style: const TextStyle(fontSize: 11.5, color: Colors.black54, fontWeight: FontWeight.w700),
          ),
        ),
        Text(
          v,
          style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }

  // ---------------- Bottom Button ----------------

  Widget _bottomButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
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
              backgroundColor: const Color(0xFF8AAEB0), // gray/teal like screenshot
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: _canContinue ? _onContinue : null,
            child: const Text(
              "Continue to Confirmation",
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ),
      ),
    );
  }

  bool get _canContinue => _selectedDate != null && _selectedTime != null;

  void _onContinue() {
    if (!_canContinue) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select date and time")),
      );
      return;
    }

    final date = _selectedDate!;
    final msg =
        "Booked ${widget.treatmentName}\nDate: ${date.day}/${date.month}/${date.year}\nTime: $_selectedTime\nTotal: ${_money(_total)}";

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

// Weekday label widget
class _CalLabel extends StatelessWidget {
  const _CalLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34,
      child: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 10.5,
            color: Colors.black45,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}
