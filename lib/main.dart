import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'pages/welcomeP.dart';

// ✅ (Recommended for payments later) Stripe setup
// If you haven't added flutter_stripe yet, you can keep this import/commented.
// import 'package:flutter_stripe/flutter_stripe.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ✅ Stripe (only if you are using Stripe later)
  // Stripe.publishableKey = "pk_test_xxxxxxxxxxxxxxxxxxxxx";
  // await Stripe.instance.applySettings();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Uppuveli By DSK',
      theme: ThemeData(
        // ✅ Use your app theme color (your UI uses gold a lot)
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFC9A633)),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF9F8F3),
      ),
      home: const WelcomePage(),
    );
  }
}
