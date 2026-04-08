import 'package:exotic/controllers/Homescreen/Homepage/src/build_search_bar.dart';
import 'package:exotic/data/providers/homepage_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExoticSliverAppBar extends StatelessWidget {
  const ExoticSliverAppBar({super.key, required this.controller});

  final TabController controller;

  @override
  Widget build(BuildContext context) {
    return Consumer<HomepageProvider>(
      builder: (context, provider, _) {
        final tabs = provider.tabs;

        return SliverAppBar(
          backgroundColor: Colors.white,
          pinned: true,
          expandedHeight: 185,
          toolbarHeight: 0,
          elevation: 0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF9747FF),
                  Colors.white,
                ],
              ),
            ),
            child: FlexibleSpaceBar(
              background: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
                  child: Column(
                    children: [
                      // --- ADDRESS BAR ---
                      Ink(
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: InkWell(
                          onTap: () => _showAddressBottomSheet(context),
                          borderRadius: BorderRadius.circular(12),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  size: 18,
                                  color: Colors.black87,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "388440  ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                                Text(
                                  "Add address",
                                  style: TextStyle(
                                    fontSize: 13,
                                    decoration: TextDecoration.underline,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Spacer(),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),

                      // --- SEARCH BAR SECTION ---
                      Row(
                        children: [
                          const Expanded(child: BuildSearchBar()),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.qr_code_scanner_rounded,
                              color: Colors.black87,
                              size: 26,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(85),
            child: Container(
              color: Colors.transparent,
              child:
                  tabs.isEmpty
                      ? const SizedBox(
                        height: 85,
                        child: Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                      : TabBar(
                        controller: controller,
                        isScrollable: true,
                        tabAlignment: TabAlignment.start,
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        physics: const BouncingScrollPhysics(),
                        dividerColor: Colors.grey.shade300,
                        labelColor: Colors.deepPurple,
                        unselectedLabelColor: Colors.black87,
                        labelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                        unselectedLabelStyle: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w300,
                        ),
                        indicator: const UnderlineTabIndicator(
                          borderSide: BorderSide(
                            color: Color(0xFF9747FF),
                            width: 3,
                          ),
                          insets: EdgeInsets.symmetric(horizontal: 16),
                        ),

                        tabs:
                            tabs.asMap().entries.map((entry) {
                              final index = entry.key;
                              final e = entry.value;

                              // Testing icons for tabs
                              IconData iconData;
                              switch (index % 6) {
                                case 0:
                                  iconData = Icons.style_outlined;
                                  break;
                                case 1:
                                  iconData = Icons.checkroom_outlined;
                                  break;
                                case 2:
                                  iconData = Icons.smartphone_outlined;
                                  break;
                                case 3:
                                  iconData = Icons.face_retouching_natural;
                                  break;
                                case 4:
                                  iconData = Icons.computer_outlined;
                                  break;
                                case 5:
                                  iconData = Icons.weekend_outlined;
                                  break;
                                default:
                                  iconData = Icons.category_outlined;
                              }

                              return Tab(
                                icon: Icon(iconData, size: 24),
                                text: e.title ?? "",
                              );
                            }).toList(),
                      ),
            ),
          ),
        );
      },
    );
  }

  void _showAddressBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                "Add new address",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: InputDecoration(
                  hintText: "Search your area, street name...",
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF9747FF),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                "Saved Addresses",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey,
                  fontFamily: 'Poppins',
                ),
              ),
              const SizedBox(height: 12),
              ..._buildStaticAddresses(),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildStaticAddresses() {
    final List<Map<String, String>> addresses = [
      {
        "title": "Home",
        "description": "24, Dream Residency, Near City Park, Mumbai",
        "type": "home",
      },
      {
        "title": "Office",
        "description": "Tech Plaza, Floor 4, Sector 5, Bengaluru",
        "type": "work",
      },
    ];

    return addresses.map((addr) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF9747FF).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  addr['type'] == 'home'
                      ? Icons.home_rounded
                      : Icons.work_rounded,
                  color: const Color(0xFF9747FF),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      addr['title']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      addr['description']!,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.grey),
            ],
          ),
        ),
      );
    }).toList();
  }
}
