import 'package:flutter/material.dart';
import 'loginP.dart';
import 'signupP.dart';
import 'homeP.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  // 👉 Update these to your actual asset paths
  static const String kBgImage = 'assets/images/hotelview.png';
  static const String kLogoImage = 'assets/images/logo.png';

  static const Color kGold = Color(0xFFC9A633);
  static const double kSidePadding = 26;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            kBgImage,
            fit: BoxFit.cover,
          ),

          // Slight dark overlay to improve text contrast
          Container(
            color: Colors.black.withOpacity(0.08),
          ),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Top gold strip like the design
                Container(
                  height: 44,
                  width: double.infinity,
                  color: kGold,
                ),

                // Body
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kSidePadding),
                    child: Column(
                      children: [
                        const SizedBox(height: 42),

                        // Logo + title
                        _LogoBlock(
                          logoPath: kLogoImage,
                        ),

                        const Spacer(),

                        // Buttons
                        _PrimaryButton(
                          label: 'Log In',
                          onTap: () => _push(context, const LoginPage()),
                        ),
                        const SizedBox(height: 14),
                        _PrimaryButton(
                          label: 'Sign Up',
                          onTap: () => _push(context, const SignUpPage()),
                        ),
                        const SizedBox(height: 14),
                        _OutlineButton(
                          label: 'Continue as Guest',
                          onTap: () => _replace(context, const HomePage()),
                        ),

                        SizedBox(height: size.height * 0.06),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static void _push(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  static void _replace(BuildContext context, Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }
}

class _LogoBlock extends StatelessWidget {
  final String logoPath;
  const _LogoBlock({required this.logoPath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Logo image
        Image.asset(
          logoPath,
          height: 70,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 10),

        // Text (you can replace with your exact font later)
        const Text(
          'UPPUVELI',
          style: TextStyle(
            color: Colors.white,
            fontSize: 34,
            letterSpacing: 6,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'BEACH BY DSK',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            letterSpacing: 2,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'a luxurious stay',
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
            fontStyle: FontStyle.italic,
            letterSpacing: 0.4,
          ),
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  static const Color kGold = Color(0xFFC9A633);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kGold,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: Row(
          children: [
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: Colors.white, size: 26),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  const _OutlineButton({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  static const Color kGold = Color(0xFFC9A633);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          side: BorderSide(color: kGold.withOpacity(0.85), width: 1.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
        child: Row(
          children: [
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: kGold,
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            const Icon(Icons.chevron_right, color: kGold, size: 26),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
