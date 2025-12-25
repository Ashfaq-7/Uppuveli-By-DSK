import 'package:flutter/material.dart';
import 'roomsearchP.dart'; // ✅ ADD: make sure file name + class name match your page
import 'spaWellP.dart'; // ✅ ADD: make sure file name + class name match your spa page
import 'checkinP.dart'; // ✅ ADD: make sure file name + class name match your check-in page

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.displayName = 'DSK GUEST',
    this.isGuest = true,
    this.initialTabIndex = 0, // 0 = Home
  });

  final String displayName;
  final bool isGuest;
  final int initialTabIndex;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const Color kGold = Color(0xFFC9A633);
  static const Color kGoldDark = Color(0xFFB8962E);

  late int _navIndex;

  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _navIndex = widget.initialTabIndex;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ✅ Hotel Facilities
  final List<_FacilityItem> _roomTypes = const [
    _FacilityItem(title: 'Deluxe Room', icon: Icons.apartment_outlined),
    _FacilityItem(title: 'Standard\nRoom', icon: Icons.bed_outlined),
    _FacilityItem(title: 'Beach Suite', icon: Icons.waves_outlined),
    _FacilityItem(title: 'Ocean Villa', icon: Icons.home_outlined),
    _FacilityItem(title: 'Family Suite', icon: Icons.family_restroom_outlined),
    _FacilityItem(title: 'Restaurant', icon: Icons.restaurant_outlined),

    // ✅ Spa navigates to SpaWellnessPage
    _FacilityItem(
      title: 'Spa',
      icon: Icons.spa_outlined,
      onTapKey: _FacilityAction.spa,
    ),

    _FacilityItem(title: 'More', icon: Icons.more_horiz),
  ];

  // ✅ Recommendation cards:
  // - first 2 gradients match screenshot (Blue, Green)
  // - 3rd uses GOLD GRADIENT top
  final List<_RecommendationItem> _recommendations = const [
    _RecommendationItem(
      title: 'Ocean View Villa',
      subtitle: 'Uppuveli Beachfront – Rooms starting\nat \$79',
      location: 'Uppuveli, Trincomalee',
      priceTag: 'From \$79',
      style: _RecommendationStyle.gradient,
      // ✅ BLUE like screenshot
      topLeftColor: Color(0xFF00B2C7),
      topRightColor: Color(0xFF246BDA),
    ),
    _RecommendationItem(
      title: 'DSK Premium Suite',
      subtitle: 'Luxurious comfort\nwith sea view',
      location: 'Main Building',
      priceTag: 'From \$99',
      style: _RecommendationStyle.gradient,
      // ✅ GREEN like screenshot
      topLeftColor: Color(0xFF18B36B),
      topRightColor: Color(0xFF0E8B62),
    ),
    _RecommendationItem(
      title: 'Family Garden Villa',
      subtitle: 'Spacious 2-bedroom villa with private garden',
      location: 'Garden Wing',
      priceTag: 'From \$150',
      style: _RecommendationStyle.goldTopOnly, // ✅ IMPORTANT
    ),
  ];

  final List<_ExperienceItem> _experiences = const [
    _ExperienceItem(title: 'Snorkeling at Pigeon\nIsland', tag: 'Snorkeling'),
    _ExperienceItem(title: 'Cultural Tour –\nKoneswaram Temple', tag: 'Cultural Tour'),
    _ExperienceItem(title: 'Whale Watching', tag: 'Adventure'),
    _ExperienceItem(title: 'Sunset Beach BBQ', tag: 'Dining'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F8F3),
      body: SafeArea(
        child: Column(
          children: [
            // Top gold strip
            Container(height: 44, width: double.infinity, color: kGold),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _headerRow(),
                    const SizedBox(height: 12),

                    _searchBar(),
                    const SizedBox(height: 12),

                    // ✅ NEW CHECK-IN CARD (below search bar)
                    _checkInCard(),
                    const SizedBox(height: 16),

                    _sectionHeader(
                      title: 'Hotel Facilities',
                      actionText: 'See All',
                      onAction: () => debugPrint('See All facilities tapped'),
                    ),
                    const SizedBox(height: 10),
                    _facilityRow(_roomTypes),
                    const SizedBox(height: 14),

                    _sectionHeader(
                      title: 'Recommendation',
                      actionText: 'View All',
                      onAction: () => debugPrint('View All recommendations tapped'),
                    ),
                    const SizedBox(height: 10),
                    _recommendationRow(),
                    const SizedBox(height: 16),

                    _sectionHeader(
                      title: 'Popular Experiences',
                      actionText: 'Explore',
                      onAction: () => debugPrint('Explore experiences tapped'),
                    ),
                    const SizedBox(height: 10),
                    _experienceGrid(),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _bottomNav(),
    );
  }

  Widget _headerRow() {
    return Row(
      children: [
        Container(
          height: 42,
          width: 42,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFE9E6D8),
          ),
          child: const Icon(Icons.person_outline, color: Colors.black54),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Welcome!', style: TextStyle(fontSize: 12, color: Colors.black54)),
              const SizedBox(height: 2),
              Text(
                widget.displayName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: kGold,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => debugPrint('Notifications tapped'),
          icon: const Icon(Icons.notifications_none),
        ),
      ],
    );
  }

  Widget _searchBar() {
    return Container(
      height: 46,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.black45),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchCtrl,
              textInputAction: TextInputAction.search,
              decoration: const InputDecoration(
                hintText: 'Search rooms, villas or experiences...',
                hintStyle: TextStyle(color: Colors.black45, fontSize: 13),
                border: InputBorder.none,
                isDense: true,
              ),
              onChanged: (_) => setState(() {}),
              onSubmitted: _performSearch, // ✅ this now navigates
            ),
          ),
          if (_searchCtrl.text.isNotEmpty)
            IconButton(
              splashRadius: 18,
              icon: const Icon(Icons.close, size: 18, color: Colors.black45),
              onPressed: () {
                _searchCtrl.clear();
                setState(() {});
              },
            ),
        ],
      ),
    );
  }

  // ✅ NEW: CHECK-IN CARD UI
  Widget _checkInCard() {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: _goToCheckIn,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
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
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: kGold.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.verified_outlined, color: kGold),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Ready to Check In?',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                      color: kGold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Mobile check-in is now available for your stay',
                    style: TextStyle(fontSize: 12, color: Colors.black54, height: 1.2),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: null, // ✅ disabled here because InkWell handles tap
              style: ButtonStyle(
                elevation: MaterialStatePropertyAll(0),
                backgroundColor: MaterialStatePropertyAll(kGold),
                foregroundColor: MaterialStatePropertyAll(Colors.white),
                padding: MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 12, vertical: 10)),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
              child: Text(
                'Start',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ NEW: navigation function for check-in
  void _goToCheckIn() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CheckInPage()),
    );
  }

  // ✅ UPDATED: only navigate if user is searching rooms/villas/suites
  void _performSearch(String query) {
    final q = query.trim();
    if (q.isEmpty) return;

    debugPrint('Search query: $q');

    // ✅ keywords that mean "rooms"
    const roomKeywords = <String>[
      'room',
      'rooms',
      'deluxe',
      'standard',
      'suite',
      'suites',
      'villa',
      'villas',
      'ocean',
      'beach',
      'family',
    ];

    final lower = q.toLowerCase();
    final isRoomSearch = roomKeywords.any((k) => lower.contains(k));

    if (!isRoomSearch) {
      // do nothing (stay on home page)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please search using room/villa keywords.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const RoomSearchPage(),
      ),
    );
  }

  // ✅ handle facility actions (Spa navigation here)
  void _handleFacilityTap(_FacilityItem item) {
    if (item.onTapKey == _FacilityAction.spa) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SpaWellnessPage()),
      );
      return;
    }

    // fallback
    debugPrint('Facility tapped: ${item.title}');
  }

  Widget _sectionHeader({
    required String title,
    required String actionText,
    required VoidCallback onAction,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: kGold,
              fontSize: 13,
            ),
          ),
        ),
        TextButton(
          onPressed: onAction,
          child: Text(actionText, style: const TextStyle(fontSize: 12, color: Colors.black54)),
        ),
      ],
    );
  }

  Widget _facilityRow(List<_FacilityItem> items) {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          return _FacilityCard(
            title: item.title,
            icon: item.icon,
            onTap: () => _handleFacilityTap(item), // ✅ UPDATED
          );
        },
      ),
    );
  }

  Widget _recommendationRow() {
    return SizedBox(
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _recommendations.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => _RecommendationCard(item: _recommendations[index]),
      ),
    );
  }

  Widget _experienceGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _experiences.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.05,
      ),
      itemBuilder: (context, index) => _ExperienceCard(item: _experiences[index]),
    );
  }

  Widget _bottomNav() {
    return Container(
      height: 74,
      color: kGold,
      padding: const EdgeInsets.only(bottom: 6, top: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            label: 'Home',
            icon: Icons.home_outlined,
            isActive: _navIndex == 0,
            onTap: () => setState(() => _navIndex = 0),
          ),
          _NavItem(
            label: 'Explore',
            icon: Icons.search_outlined,
            isActive: _navIndex == 1,
            onTap: () => setState(() => _navIndex = 1),
          ),
          _NavItem(
            label: 'Bookmark',
            icon: Icons.favorite_border,
            isActive: _navIndex == 2,
            onTap: () => setState(() => _navIndex = 2),
          ),
          _NavItem(
            label: 'Profile',
            icon: Icons.person_outline,
            isActive: _navIndex == 3,
            onTap: () => setState(() => _navIndex = 3),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// Models
// -----------------------------------------------------------------------------
enum _FacilityAction { spa }

class _FacilityItem {
  final String title;
  final IconData icon;

  // ✅ action key for navigation
  final _FacilityAction? onTapKey;

  const _FacilityItem({
    required this.title,
    required this.icon,
    this.onTapKey,
  });
}

enum _RecommendationStyle { gradient, goldTopOnly }

class _RecommendationItem {
  final String title;
  final String subtitle;
  final String location;
  final String priceTag;

  final _RecommendationStyle style;

  // for gradient cards
  final Color? topLeftColor;
  final Color? topRightColor;

  const _RecommendationItem({
    required this.title,
    required this.subtitle,
    required this.location,
    required this.priceTag,
    required this.style,
    this.topLeftColor,
    this.topRightColor,
  });
}

class _ExperienceItem {
  final String title;
  final String tag;
  const _ExperienceItem({required this.title, required this.tag});
}

// -----------------------------------------------------------------------------
// Widgets
// -----------------------------------------------------------------------------
class _FacilityCard extends StatelessWidget {
  const _FacilityCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  static const Color kGold = Color(0xFFC9A633);

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: 92,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: kGold,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  const _RecommendationCard({required this.item});

  final _RecommendationItem item;

  static const Color kGold = Color(0xFFC9A633);
  static const Color kGoldDark = Color(0xFFB8962E);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => debugPrint('Recommendation tapped: ${item.title}'),
      child: Container(
        width: 260,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 14,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ TOP BLOCK: gradient (first 2), GOLD GRADIENT (3rd)
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                gradient: item.style == _RecommendationStyle.goldTopOnly
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFE1C15C), // light gold
                          Color(0xFFB8962E), // dark gold
                        ],
                      )
                    : LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          item.topLeftColor ?? const Color(0xFF00B2C7),
                          item.topRightColor ?? const Color(0xFF2DC96D),
                        ],
                      ),
              ),
              child: Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    item.priceTag,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),

            // ✅ FIX: make bottom area fit so location never overflows
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.subtitle,
                      style: const TextStyle(fontSize: 12, color: Colors.black54, height: 1.2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.location_on_outlined, size: 15, color: kGold),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            item.location,
                            style: const TextStyle(fontSize: 12, color: kGold, fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({required this.item});
  final _ExperienceItem item;

  static const Color kGold = Color(0xFFC9A633);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => debugPrint('Experience tapped: ${item.title}'),
      child: Container(
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(16)),
        child: Stack(
          children: [
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999)),
                child: Text(
                  item.tag,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: kGold),
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Text(
                item.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = isActive ? const Color(0xFF0D3B2E) : Colors.white.withOpacity(0.85);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: SizedBox(
        width: 74,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: activeColor),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: activeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
