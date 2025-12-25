import 'package:cloud_firestore/cloud_firestore.dart';
import 'pricing_model.dart';

class PricingService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> _getPricingSettings() async {
    final doc = await _db.collection('settings').doc('pricing').get();
    final data = doc.data() ?? {};
    return {
      "taxRate": (data["taxRate"] ?? 0.0).toDouble(),   // e.g. 0.10
      "fixedFee": (data["fixedFee"] ?? 0.0).toDouble(), // e.g. 0
    };
  }

  Future<double> _getPromoDiscount({
    required String? promoCode,
    required double baseTotal,
  }) async {
    final code = (promoCode ?? '').trim().toUpperCase();
    if (code.isEmpty) return 0.0;

    final doc = await _db.collection('promocodes').doc(code).get();
    final data = doc.data();
    if (data == null) return 0.0;

    final active = (data["active"] ?? false) == true;
    if (!active) return 0.0;

    final type = (data["type"] ?? "amount").toString(); // "amount" or "percent"
    final value = (data["value"] ?? 0).toDouble();

    if (type == "percent") {
      final pct = (value / 100.0);
      return (baseTotal * pct).clamp(0, baseTotal);
    }

    // amount
    return value.clamp(0, baseTotal);
  }

  Future<PricingBreakdown> calculate({
    required double baseRatePerNight,
    required int nights,
    required String? promoCode,
  }) async {
    final n = nights < 1 ? 1 : nights;

    final settings = await _getPricingSettings();
    final taxRate = settings["taxRate"] as double;
    final fixedFee = settings["fixedFee"] as double;

    final baseTotal = baseRatePerNight * n;
    final taxesFees = (baseTotal * taxRate) + fixedFee;

    final promoDiscount = await _getPromoDiscount(
      promoCode: promoCode,
      baseTotal: baseTotal,
    );

    return PricingBreakdown(
      baseRatePerNight: baseRatePerNight,
      nights: n,
      taxesFees: taxesFees,
      promoDiscount: promoDiscount,
    );
  }
}
