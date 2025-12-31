import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:artist_hub/core/constants/app_colors.dart';
import 'package:artist_hub/core/constants/app_strings.dart';
import 'package:artist_hub/models/artist_model.dart';
import 'package:artist_hub/providers/artist_provider.dart';
import 'package:artist_hub/providers/auth_provider.dart';

import 'package:artist_hub/customer/search/search_artist_screen.dart';
import 'package:artist_hub/customer/bookings/booking_list_screen.dart';
import 'package:artist_hub/customer/profile/customer_profile_screen.dart';
import 'package:artist_hub/customer/bookings/booking_screen.dart';

class CustomerDashboardScreen extends StatefulWidget {
  const CustomerDashboardScreen({Key? key}) : super(key: key);

  @override
  State<CustomerDashboardScreen> createState() =>
      _CustomerDashboardScreenState();
}

class _CustomerDashboardScreenState extends State<CustomerDashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    CustomerHomeTab(),
    SearchArtistScreen(),
    CustomerBookingsTab(),
    CustomerProfileTab(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ArtistProvider>().fetchArtists();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: _screens[_currentIndex],
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) => setState(() => _currentIndex = index),
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.white,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.grey,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: AppStrings.home,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search_outlined),
          activeIcon: Icon(Icons.search),
          label: AppStrings.search,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          activeIcon: Icon(Icons.calendar_today),
          label: AppStrings.bookings,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: AppStrings.profile,
        ),
      ],
    );
  }
}

class CustomerHomeTab extends StatelessWidget {
  const CustomerHomeTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 180,
          backgroundColor: AppColors.primaryColor,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              padding: const EdgeInsets.only(top: 40),
              color: AppColors.primaryColor,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 40, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Welcome, ${user?.name ?? 'User'}',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Find the perfect artist for your event',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.85)),
                  ),
                ],
              ),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _SearchBar(),
              const SizedBox(height: 20),
              _CategoriesSection(),
              const SizedBox(height: 20),
              const _FeaturedArtistsSection(),
              const SizedBox(height: 20),
              const _PopularArtistsSection(),
            ]),
          ),
        ),
      ],
    );
  }
}

/* ---------------- SEARCH BAR ---------------- */

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SearchArtistScreen()),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.lightGrey),
        ),
        child: Row(
          children: const [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 12),
            Text(
              'Search artists, categories...',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

/* ---------------- CATEGORIES ---------------- */

class _CategoriesSection extends StatelessWidget {
  final List<Map<String, dynamic>> categories = const [
    {'icon': Icons.mic, 'label': 'Singers'},
    {'icon': Icons.music_note, 'label': 'Musicians'},
    {'icon': Icons.brush, 'label': 'Painters'},
    {'icon': Icons.directions_run, 'label': 'Dancers'},
    {'icon': Icons.theater_comedy, 'label': 'Performers'},
    {'icon': Icons.more_horiz, 'label': 'More'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Categories',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
          ),
          itemBuilder: (_, i) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(categories[i]['icon'],
                      size: 28, color: AppColors.primaryColor),
                  const SizedBox(height: 8),
                  Text(categories[i]['label'],
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            );
          },
        )
      ],
    );
  }
}

/* ---------------- FEATURED ARTISTS ---------------- */

class _FeaturedArtistsSection extends StatelessWidget {
  const _FeaturedArtistsSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<ArtistProvider>(
      builder: (_, provider, __) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final artists = provider.artists.take(3).toList();
        if (artists.isEmpty) {
          return const Center(child: Text('No artists available'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Featured Artists',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: artists.length,
                itemBuilder: (_, i) =>
                    _ArtistCard(artist: artists[i]),
              ),
            ),
          ],
        );
      },
    );
  }
}

/* ---------------- POPULAR ARTISTS ---------------- */

class _PopularArtistsSection extends StatelessWidget {
  const _PopularArtistsSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<ArtistProvider>(
      builder: (_, provider, __) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final artists = provider.artists.skip(3).take(4).toList();
        if (artists.isEmpty) {
          return const Center(child: Text('No artists available'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Popular Artists',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: artists.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12),
              itemBuilder: (_, i) =>
                  _ArtistCard(artist: artists[i]),
            ),
          ],
        );
      },
    );
  }
}

/* ---------------- ARTIST CARD ---------------- */

class _ArtistCard extends StatelessWidget {
  final ArtistModel artist;
  const _ArtistCard({required this.artist});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showDetails(context),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(12)),
                  // image: DecorationImage(
                  //   fit: BoxFit.cover,
                  //   image: NetworkImage(
                  //     artist.imageUrl ??
                  //         'https://via.placeholder.com/300',
                  //   ),
                  // ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Text(artist.name ?? 'Artist',
                      style:
                      const TextStyle(fontWeight: FontWeight.bold)),
                  Text(artist.category ?? ''),
                  Text('₹${artist.price ?? 0}',
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => ArtistDetailsBottomSheet(artist: artist),
    );
  }
}

/* ---------------- DETAILS BOTTOM SHEET ---------------- */

class ArtistDetailsBottomSheet extends StatelessWidget {
  final ArtistModel artist;
  const ArtistDetailsBottomSheet({Key? key, required this.artist})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
              child: Container(
                  width: 60,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2)))),
          const SizedBox(height: 20),
          Text(artist.name ?? '',
              style:
              const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          Text(artist.category ?? ''),
          const SizedBox(height: 10),
          Text(artist.description ?? 'No description'),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => BookingScreen(artist: artist)),
              );
            },
            child: const Center(child: Text('Book Now')),
          )
        ],
      ),
    );
  }
}

/* ---------------- OTHER TABS ---------------- */

class CustomerBookingsTab extends StatelessWidget {
  const CustomerBookingsTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const BookingListScreen();
}

class CustomerProfileTab extends StatelessWidget {
  const CustomerProfileTab({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) => const CustomerProfileScreen();
}
