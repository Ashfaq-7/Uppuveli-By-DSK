import 'package:flutter/material.dart';
import 'spabookP.dart';

class SpaWellnessPage extends StatefulWidget {
  const SpaWellnessPage({super.key});

  @override
  State<SpaWellnessPage> createState() => _SpaWellnessPageState();
}

class _SpaWellnessPageState extends State<SpaWellnessPage>
    with SingleTickerProviderStateMixin {
  static const Color kGold = Color(0xFFC9A633);
  static const Color kBg = Color(0xFFF9F8F3);

  late final TabController _tabController;

  final List<SpaService> _allServices = const [
    SpaService(
      category: SpaCategory.massages,
      title: "Signature Ayurvedic Massage",
      minutes: 60,
      price: 85,
      rating: 4.9,
      reviews: 128,
      description:
          "Traditional healing massage with warm oils and aromatherapy to restore balance and harmony.",
      imageAsset: "assets/images/ayurvedic.jpg",
    ),
    SpaService(
      category: SpaCategory.facials,
      title: "Ocean Breeze Facial",
      minutes: 75,
      price: 95,
      rating: 4.8,
      reviews: 96,
      description:
          "Hydrating facial technique using marine botanicals to soothe and brighten for radiant skin.",
      imageAsset: "assets/images/facial.png",
    ),
    SpaService(
      category: SpaCategory.bodyTreatments,
      title: "Coconut Body Scrub",
      minutes: 45,
      price: 55,
      rating: 4.7,
      reviews: 78,
      description:
          "Exfoliating treatment with fresh coconut and sea salt to reveal smooth, glowing skin.",
      imageAsset: "assets/images/no.png",
    ),
    SpaService(
      category: SpaCategory.massages,
      title: "Deep Tissue Therapy",
      minutes: 90,
      price: 110,
      rating: 4.6,
      reviews: 114,
      description:
          "Intensive massage targeting muscle tension and stress relief with focused pressure techniques.",
      imageAsset: "assets/images/massage.png",
    ),
    SpaService(
      category: SpaCategory.wellnessPackages,
      title: "Sunset Wellness Package",
      minutes: 120,
      price: 180,
      rating: 5.0,
      reviews: 67,
      description:
          "Complete rejuvenation with massage, facial, and meditation session overlooking the ocean.",
      imageAsset: "assets/images/wellness.png",
    ),
    SpaService(
      category: SpaCategory.facials,
      title: "Tropical Glow Facial",
      minutes: 60,
      price: 80,
      rating: 4.8,
      reviews: 103,
      description:
          "Brightening facial with papaya enzymes and Vitamin C for a luminous, even complexion.",
      imageAsset: "assets/images/face.png",
    ),
    SpaService(
      category: SpaCategory.massages,
      title: "Hot Stone Massage",
      minutes: 75,
      price: 100,
      rating: 4.9,
      reviews: 144,
      description:
          "Soothing massage using heated volcanic stones to melt away tension and promote deep relaxation.",
      imageAsset: "assets/images/mass.png",
    ),
    SpaService(
      category: SpaCategory.bodyTreatments,
      title: "Seaweed Body Wrap",
      minutes: 60,
      price: 75,
      rating: 4.6,
      reviews: 81,
      description:
          "Detoxifying wrap with mineral-rich seaweed to nourish skin and improve circulation.",
      imageAsset: "assets/images/body.png",
    ),
  ];

  SpaCategoryTab _selectedTab = SpaCategoryTab.all;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedTab = SpaCategoryTab.values[_tabController.index];
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<SpaService> get _filteredServices {
    switch (_selectedTab) {
      case SpaCategoryTab.all:
        return _allServices;
      case SpaCategoryTab.massages:
        return _allServices.where((s) => s.category == SpaCategory.massages).toList();
      case SpaCategoryTab.facials:
        return _allServices.where((s) => s.category == SpaCategory.facials).toList();
      case SpaCategoryTab.bodyTreatments:
        return _allServices.where((s) => s.category == SpaCategory.bodyTreatments).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      appBar: AppBar(
        backgroundColor: kBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black87),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "Spa & Wellness",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w900,
                fontSize: 15,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Unwind and Rejuvenate",
              style: TextStyle(
                color: Colors.black45,
                fontWeight: FontWeight.w700,
                fontSize: 11.5,
              ),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(54),
          child: Align(
            alignment: Alignment.centerLeft,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: kGold,
              unselectedLabelColor: Colors.black54,
              indicatorColor: kGold,
              indicatorWeight: 2.8,
              labelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12),
              tabs: const [
                Tab(text: "All"),
                Tab(text: "Massages"),
                Tab(text: "Facials"),
                Tab(text: "Body Treatments"),
              ],
            ),
          ),
        ),
      ),

      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 18),
        itemCount: _filteredServices.length,
        itemBuilder: (context, index) {
          final s = _filteredServices[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _serviceCard(s),
          );
        },
      ),
    );
  }

  // ✅ SERVICE CARD
  Widget _serviceCard(SpaService s) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category label
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: _categoryTag(s.category),
          ),
          const SizedBox(height: 10),

          // Image
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              height: 170,
              width: double.infinity,
              child: Image.asset(
                s.imageAsset,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 6),

                Row(
                  children: [
                    Text(
                      "${s.minutes} min",
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Colors.black54,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "\$${s.price.toStringAsFixed(0)}",
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Colors.black54,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
                Text(
                  s.description,
                  style: const TextStyle(
                    fontSize: 11.5,
                    height: 1.25,
                    color: Colors.black54,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: kGold),
                    const SizedBox(width: 6),
                    Text(
                      s.rating.toStringAsFixed(1),
                      style: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "(${s.reviews} reviews)",
                      style: const TextStyle(
                        color: Colors.black45,
                        fontWeight: FontWeight.w700,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // ✅ NAVIGATION INSTEAD OF DIALOG
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SpaBookingPage(
                            treatmentName: s.title,
                            minutes: s.minutes,
                            price: s.price,
                            imageAsset: s.imageAsset,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kGold,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Select Date & Time",
                      style: TextStyle(fontWeight: FontWeight.w900),
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

  // ✅ CATEGORY TAG
  Widget _categoryTag(SpaCategory cat) {
    String label;
    switch (cat) {
      case SpaCategory.massages:
        label = "Massages";
        break;
      case SpaCategory.facials:
        label = "Facials";
        break;
      case SpaCategory.bodyTreatments:
        label = "Body Treatments";
        break;
      case SpaCategory.wellnessPackages:
        label = "Wellness Packages";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF6E9C6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: kGold,
          fontWeight: FontWeight.w900,
          fontSize: 10.8,
        ),
      ),
    );
  }
}

// ---------------- Models ----------------

enum SpaCategory { massages, facials, bodyTreatments, wellnessPackages }

enum SpaCategoryTab { all, massages, facials, bodyTreatments }

class SpaService {
  final SpaCategory category;
  final String title;
  final int minutes;
  final double price;
  final double rating;
  final int reviews;
  final String description;
  final String imageAsset;

  const SpaService({
    required this.category,
    required this.title,
    required this.minutes,
    required this.price,
    required this.rating,
    required this.reviews,
    required this.description,
    required this.imageAsset,
  });
}
