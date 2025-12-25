class RoomItem {
  final String name;
  final String imageAsset;
  final int sqft;
  final int guests;
  final String bedsLabel;
  final int price;
  final int points;
  final bool refundable;

  const RoomItem({
    required this.name,
    required this.imageAsset,
    required this.sqft,
    required this.guests,
    required this.bedsLabel,
    required this.price,
    required this.points,
    required this.refundable,
  });
}
