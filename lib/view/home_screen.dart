import 'package:flutter/material.dart';
import 'package:food_ordering_app/model/favourite_model.dart';
import 'package:food_ordering_app/model/popular_restaurant_detail_screen_model.dart';
import 'package:food_ordering_app/view/cart_screen.dart';
import 'package:food_ordering_app/view/popular_restaurant_detail_screen.dart';
import 'package:food_ordering_app/view/view_all_resturants.dart';
import 'package:food_ordering_app/viewmodel/addtoCart_view_model.dart';
import 'package:food_ordering_app/viewmodel/favourite_provider.dart';
import 'package:food_ordering_app/viewmodel/search_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 45),

            // ── Header ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Colors.red),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'VhokLayo',
                            style: GoogleFonts.poppins(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const Row(
                            children: [
                              Text('Pokhara', style: TextStyle(fontSize: 13)),
                              Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Consumer<AddtocartProvider>(
                    builder: (context, provider, child) {
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CartScreen()),
                        ),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            const Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.red,
                              size: 28,
                            ),
                            if (provider.cartCount > 0)
                              Positioned(
                                top: -6,
                                right: -6,
                                child: Container(
                                  height: 18,
                                  width: 18,
                                  decoration: const BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${provider.cartCount}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            // ── Search bar ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Container(
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      context.read<SearchViewModel>().searchRestaurant(value);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ViewAllResturants(restaurants: restaurants),
                        ),
                      );
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Search food, restaurants...',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.red),
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.tune, color: Colors.red),
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ── Section title ────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Restaurants',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    'View All',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.black.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),

            Consumer<FavouriteViewModel>(
              builder: (context, favouriteProvider, child) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: restaurants.length > 4 ? 4 : restaurants.length,
                  itemBuilder: (context, index) {
                    final r = restaurants[index];

                    final item = FavouriteModel(
                      image: r.image,
                      title: r.name,
                      subtitle: r.location,
                    );

                    final isFavourite = favouriteProvider.isFavourite(item);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Container(
                        height: 280,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(18),
                                      ),
                                      child: Image.asset(
                                        r.image,
                                        height: 170,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),

                                    Positioned(
                                      top: 12,
                                      right: 12,
                                      child: GestureDetector(
                                        onTap: () {
                                          favouriteProvider.toggleFavourite(
                                            item,
                                          );
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.12,
                                                ),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Icon(
                                            isFavourite
                                                ? Icons.favorite_rounded
                                                : Icons
                                                      .favorite_border_outlined,
                                            color: isFavourite
                                                ? Colors.red
                                                : Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        r.name,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(r.location),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            Positioned(
                              top: 148,
                              right: 16,
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          PopularRestaurantDetailScreen(
                                            restaurant: r,
                                          ),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 42,
                                  width: 42,
                                  decoration: const BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 50),

            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ViewAllResturants(restaurants: restaurants),
                  ),
                );
              },
              child: Container(
                height: 51,
                width: 349,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.red.withValues(alpha: 0.5),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.red,
                ),
                child: Center(
                  child: Text(
                    'View all restaurants',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
