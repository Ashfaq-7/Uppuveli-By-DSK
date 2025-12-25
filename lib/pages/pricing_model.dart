class PricingBreakdown {
  final double baseRatePerNight;
  final int nights;
  final double taxesFees;
  final double promoDiscount;

  const PricingBreakdown({
    required this.baseRatePerNight,
    required this.nights,
    required this.taxesFees,
    required this.promoDiscount,
  });

  double get baseTotal => baseRatePerNight * nights;
  double get total => (baseTotal + taxesFees - promoDiscount).clamp(0, double.infinity);
}
