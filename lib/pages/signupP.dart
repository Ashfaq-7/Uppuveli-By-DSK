import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'homeP.dart'; // ✅ change this import to your actual GuestHomePage file

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  static const Color kGold = Color(0xFFC9A633);

  final _firstName = TextEditingController();
  final _lastName = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  bool _acceptTerms = false;
  bool _optInOffers = false;

  bool _loading = false;

  String _countryCode = '+94';

  // ✅ extended country codes list
  static const List<_CountryCodeItem> _countryCodes = [
    _CountryCodeItem(flag: '🇱🇰', code: '+94', label: 'Sri Lanka'),
    _CountryCodeItem(flag: '🇮🇳', code: '+91', label: 'India'),
    _CountryCodeItem(flag: '🇺🇸', code: '+1', label: 'United States'),
    _CountryCodeItem(flag: '🇬🇧', code: '+44', label: 'United Kingdom'),
    _CountryCodeItem(flag: '🇨🇦', code: '+1', label: 'Canada'),
    _CountryCodeItem(flag: '🇦🇺', code: '+61', label: 'Australia'),
    _CountryCodeItem(flag: '🇳🇿', code: '+64', label: 'New Zealand'),
    _CountryCodeItem(flag: '🇦🇪', code: '+971', label: 'UAE'),
    _CountryCodeItem(flag: '🇸🇦', code: '+966', label: 'Saudi Arabia'),
    _CountryCodeItem(flag: '🇶🇦', code: '+974', label: 'Qatar'),
    _CountryCodeItem(flag: '🇴🇲', code: '+968', label: 'Oman'),
    _CountryCodeItem(flag: '🇰🇼', code: '+965', label: 'Kuwait'),
    _CountryCodeItem(flag: '🇲🇾', code: '+60', label: 'Malaysia'),
    _CountryCodeItem(flag: '🇸🇬', code: '+65', label: 'Singapore'),
    _CountryCodeItem(flag: '🇹🇭', code: '+66', label: 'Thailand'),
    _CountryCodeItem(flag: '🇮🇩', code: '+62', label: 'Indonesia'),
    _CountryCodeItem(flag: '🇵🇭', code: '+63', label: 'Philippines'),
    _CountryCodeItem(flag: '🇯🇵', code: '+81', label: 'Japan'),
    _CountryCodeItem(flag: '🇰🇷', code: '+82', label: 'South Korea'),
    _CountryCodeItem(flag: '🇨🇳', code: '+86', label: 'China'),
    _CountryCodeItem(flag: '🇭🇰', code: '+852', label: 'Hong Kong'),
    _CountryCodeItem(flag: '🇫🇷', code: '+33', label: 'France'),
    _CountryCodeItem(flag: '🇩🇪', code: '+49', label: 'Germany'),
    _CountryCodeItem(flag: '🇮🇹', code: '+39', label: 'Italy'),
    _CountryCodeItem(flag: '🇪🇸', code: '+34', label: 'Spain'),
    _CountryCodeItem(flag: '🇳🇱', code: '+31', label: 'Netherlands'),
    _CountryCodeItem(flag: '🇸🇪', code: '+46', label: 'Sweden'),
    _CountryCodeItem(flag: '🇳🇴', code: '+47', label: 'Norway'),
    _CountryCodeItem(flag: '🇩🇰', code: '+45', label: 'Denmark'),
    _CountryCodeItem(flag: '🇨🇭', code: '+41', label: 'Switzerland'),
  ];

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _email.dispose();
    _phone.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F3),
      body: SafeArea(
        child: Column(
          children: [
            // Top gold bar
            Container(
              height: 48,
              width: double.infinity,
              color: kGold,
              alignment: Alignment.center,
              child: const Text(
                'Sign\nUp',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  height: 1.1,
                ),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 22),
                child: Column(
                  children: [
                    const SizedBox(height: 6),

                    // Title area
                    const Text(
                      'Create\nAccount',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: kGold,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Join Uppuveli Beach Resort',
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),

                    const SizedBox(height: 24),

                    // Form Card
                    _buildCardForm(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // First + Last name row
          Row(
            children: [
              Expanded(
                child: _labeledField(
                  label: 'First Name *',
                  child: TextField(
                    controller: _firstName,
                    decoration: _inputDecoration('John'),
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _labeledField(
                  label: 'Last Name *',
                  child: TextField(
                    controller: _lastName,
                    decoration: _inputDecoration('Doe'),
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Email
          _labeledField(
            label: 'Email *',
            child: TextField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: _inputDecoration('your@email.com'),
              textInputAction: TextInputAction.next,
            ),
          ),

          const SizedBox(height: 14),

          // Phone (code + number)
          const Text('Phone *', style: TextStyle(fontSize: 13)),
          const SizedBox(height: 6),
          Row(
            children: [
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F6F6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _countryCode,
                    items: _countryCodes
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.code,
                            child: Text('${c.flag}  ${c.code}'),
                          ),
                        )
                        .toList(),
                    onChanged: (v) {
                      if (v == null) return;
                      setState(() => _countryCode = v);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: TextField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    decoration: _inputDecoration('77 123 4567'),
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Password
          _labeledField(
            label: 'Password *',
            child: TextField(
              controller: _password,
              obscureText: _obscurePassword,
              decoration: _inputDecoration('••••••••').copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ),
              textInputAction: TextInputAction.next,
            ),
          ),

          const SizedBox(height: 14),

          // Confirm Password
          _labeledField(
            label: 'Confirm Password *',
            child: TextField(
              controller: _confirmPassword,
              obscureText: _obscureConfirm,
              decoration: _inputDecoration('••••••••').copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirm ? Icons.visibility_off : Icons.visibility,
                    size: 20,
                  ),
                  onPressed: () {
                    setState(() => _obscureConfirm = !_obscureConfirm);
                  },
                ),
              ),
              textInputAction: TextInputAction.done,
            ),
          ),

          const SizedBox(height: 16),

          // Terms checkbox
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: _acceptTerms,
                activeColor: kGold,
                onChanged: (v) => setState(() => _acceptTerms = v ?? false),
              ),
              const Text('I accept the '),
              GestureDetector(
                onTap: _onTermsTap,
                child: const Text(
                  'terms & conditions',
                  style: TextStyle(color: kGold, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),

          // Offers checkbox
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Checkbox(
                value: _optInOffers,
                activeColor: kGold,
                onChanged: (v) => setState(() => _optInOffers = v ?? false),
              ),
              const Expanded(
                child: Text(
                  'Opt-in for exclusive promotions and\noffers',
                  style: TextStyle(height: 1.2),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Create account button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kGold,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: _loading ? null : _onCreateAccount,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text(
                      'Create Account',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _labeledField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13)),
        const SizedBox(height: 6),
        SizedBox(height: 50, child: child),
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF6F6F6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Actions (Firebase)
  // ---------------------------------------------------------------------------

  void _onTermsTap() {
    // TODO: open terms page or web link
  }

  Future<void> _onCreateAccount() async {
    // ✅ Validate all required fields
    final first = _firstName.text.trim();
    final last = _lastName.text.trim();
    final email = _email.text.trim();
    final phone = _phone.text.trim();
    final pass = _password.text;
    final confirm = _confirmPassword.text;

    if (first.isEmpty ||
        last.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        pass.isEmpty ||
        confirm.isEmpty) {
      _toast('Please fill all required fields (*)');
      return;
    }

    if (!_acceptTerms) {
      _toast('Please accept the terms & conditions');
      return;
    }

    if (pass.length < 6) {
      _toast('Password must be at least 6 characters');
      return;
    }

    if (pass != confirm) {
      _toast('Passwords do not match');
      return;
    }

    try {
      setState(() => _loading = true);

      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );

      final displayName = '$first $last'.trim();
      await cred.user?.updateDisplayName(displayName);

      if (!mounted) return;

      // ✅ Navigate to Home (GuestHomePage)
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(
            displayName: displayName.isEmpty ? 'DSK GUEST' : displayName,
            isGuest: false,
            initialTabIndex: 0,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      _toast(e.message ?? 'Sign up failed');
    } catch (e) {
      _toast('Sign up failed: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

// ===================== Helper Model =====================

class _CountryCodeItem {
  final String flag;
  final String code;
  final String label;
  const _CountryCodeItem({
    required this.flag,
    required this.code,
    required this.label,
  });
}
