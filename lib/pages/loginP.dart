import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'signupP.dart';
import 'sociallog.dart'; // <-- SocialConfirmPage file
import 'homeP.dart'; // ✅ make sure this file name matches your GuestHomePage file

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _loadingSocial = false;

  static const Color kGold = Color(0xFFC9A633);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),

                    const Text(
                      'Welcome\nBack',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        color: kGold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sign in to your account',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 32),

                    _buildLoginCard(),

                    const SizedBox(height: 24),

                    _buildSocialLogin(),

                    if (_loadingSocial) ...[
                      const SizedBox(height: 18),
                      const CircularProgressIndicator(),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginCard() {
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
          const Text('Email', style: TextStyle(fontSize: 13)),
          const SizedBox(height: 6),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: _inputDecoration('your@email.com'),
          ),

          const SizedBox(height: 16),

          const Text('Password', style: TextStyle(fontSize: 13)),
          const SizedBox(height: 6),
          TextField(
            controller: _passwordController,
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
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Checkbox(
                value: _rememberMe,
                activeColor: kGold,
                onChanged: (v) => setState(() => _rememberMe = v ?? false),
              ),
              const Text('Remember me'),
            ],
          ),

          const SizedBox(height: 8),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kGold,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _onEmailLogin,
              child: const Text(
                'Sign In',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Center(
            child: TextButton(
              onPressed: _onForgotPassword,
              child: const Text(
                'Forgot Password?',
                style: TextStyle(color: kGold),
              ),
            ),
          ),

          Center(
            child: TextButton(
              onPressed: _goToSignUp,
              child: const Text(
                "Don't have an account? Sign Up",
                style: TextStyle(
                  color: kGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialLogin() {
    return Column(
      children: [
        const Text(
          'Or continue with',
          style: TextStyle(color: Colors.black54),
        ),
        const SizedBox(height: 14),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _socialButton('assets/icons/googlelogo.png', _onGoogleLogin),
            const SizedBox(width: 16),
            _socialButton('assets/icons/applelogo.png', _onAppleLogin),
            const SizedBox(width: 16),
            _socialButton('assets/icons/fblogo.png', _onFacebookLogin),
          ],
        ),
      ],
    );
  }

  Widget _socialButton(String icon, VoidCallback onTap) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: _loadingSocial ? null : onTap,
      child: Container(
        height: 54,
        width: 54,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Image.asset(icon),
        ),
      ),
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
  // ACTIONS
  // ---------------------------------------------------------------------------

  void _goToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SignUpPage()),
    );
  }

  Future<void> _onEmailLogin() async {
    final email = _emailController.text.trim();
    final pass = _passwordController.text.trim();

    if (email.isEmpty || pass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter email and password')),
      );
      return;
    }

    try {
      final userCred = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );

      final user = userCred.user;
      if (user == null || !mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(
            displayName: user.displayName ?? user.email ?? 'User',
            isGuest: false,
            initialTabIndex: 0,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String msg = 'Login failed';
      if (e.code == 'user-not-found') msg = 'No account found for that email.';
      if (e.code == 'wrong-password') msg = 'Wrong password.';
      if (e.code == 'invalid-email') msg = 'Invalid email.';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e')),
      );
    }
  }

  void _onForgotPassword() {
    // TODO: Firebase reset password
  }

  Future<void> _onGoogleLogin() async {
    try {
      setState(() => _loadingSocial = true);

      UserCredential userCred;

      if (kIsWeb) {
        // ✅ WEB Google login (Popup)
        final googleProvider = GoogleAuthProvider()
          ..addScope('email')
          ..addScope('profile');

        userCred = await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        // ✅ ANDROID/iOS Google login (google_sign_in)
        final googleUser = await GoogleSignIn().signIn();
        if (googleUser == null) {
          // user canceled
          setState(() => _loadingSocial = false);
          return;
        }

        final googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        userCred = await FirebaseAuth.instance.signInWithCredential(credential);
      }

      final user = userCred.user;

      if (!mounted) return;

      final displayName = user?.displayName ?? 'Guest';
      final email = user?.email ?? 'No email';

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SocialConfirmPage(
            displayName: displayName,
            email: email,
            providerLabel: 'Signing in with Google',
            avatarText: _initials(displayName),
            providerIconAsset: 'assets/icons/googlelogo.png',
            onUseDifferentAccount: () async {
              // Sign out from Firebase
              await FirebaseAuth.instance.signOut();

              // Also sign out from Google session (mobile)
              if (!kIsWeb) {
                await GoogleSignIn().signOut();
              }

              if (!mounted) return;
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-in failed: $e')),
      );
    } finally {
      if (mounted) setState(() => _loadingSocial = false);
    }
  }

  void _onAppleLogin() {
    // Apple Sign-In needs iOS/macOS setup (Xcode capabilities + Apple Developer setup)
    // For now, this is a demo navigation so your UI flow works.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SocialConfirmPage(
          displayName: 'Apple User',
          email: 'appleuser@icloud.com',
          providerLabel: 'Signing in with Apple',
          avatarText: 'AU',
          providerIconAsset: 'assets/icons/applelogo.png',
          onUseDifferentAccount: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _onFacebookLogin() {
    // TODO: Implement Facebook auth
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SocialConfirmPage(
          displayName: 'Facebook User',
          email: 'fbuser@example.com',
          providerLabel: 'Signing in with Facebook',
          avatarText: 'FU',
          providerIconAsset: 'assets/icons/fblogo.png',

          onUseDifferentAccount: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'GU';
    if (parts.length == 1) return parts[0].substring(0, 1).toUpperCase();
    return (parts[0].substring(0, 1) + parts[1].substring(0, 1)).toUpperCase();
  }
}
