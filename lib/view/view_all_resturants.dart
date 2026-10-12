import 'package:flutter/material.dart';
import 'package:food_ordering_app/model/favourite_model.dart';
import 'package:food_ordering_app/model/popular_restaurant_detail_screen_model.dart';
import 'package:food_ordering_app/view/popular_restaurant_detail_screen.dart';
import 'package:food_ordering_app/viewmodel/favourite_provider.dart';
import 'package:food_ordering_app/viewmodel/search_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ViewAllResturants extends StatefulWidget {
  final List<PopularRestaurantDetailScreenModel> restaurants;
  const ViewAllResturants({super.key, required this.restaurants});

  @override
  State<ViewAllResturants> createState() => _ViewAllResturantsState();
}

class _ViewAllResturantsState extends State<ViewAllResturants> {
  final _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
    Future.microtask(() {
      context.read<SearchViewModel>().setRestaurants(widget.restaurants);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Colors.red),
        title: Text(
          "All Resturants",
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
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
              child: Consumer<SearchViewModel>(
                builder: (context, searchvm, child) {
                  return TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      context.read<SearchViewModel>().searchRestaurant(value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search food, restaurants...',
                      hintStyle: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                      prefixIcon: const Icon(Icons.search, color: Colors.red),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_searchController.text.isNotEmpty)
                            IconButton(
                              onPressed: () {
                                _searchController.clear();
                                searchvm.clearSearch();
                              },
                              icon: Icon(Icons.clear, color: Colors.red),
                            ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.tune, color: Colors.red),
                          ),
                        ],
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 50),
          Consumer2<FavouriteViewModel, SearchViewModel>(
            builder: (context, favourite, search, child) {
              return Expanded(
                child: ListView.builder(
                  itemCount: search.restaurants.length,

                  itemBuilder: (context, index) {
                    final restaurant = search.restaurants[index];
                    final item = FavouriteModel(
                      image: restaurant.image,
                      title: restaurant.name,
                      subtitle: restaurant.location,
                    );
                    final isFavourite = favourite.isFavourite(item);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 12,
                      ),
                      child: Container(
                        height: 250,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
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
                                        restaurant.image,
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
                                          favourite.toggleFavourite(item);
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
                                        restaurant.name,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(restaurant.location),
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
                                            restaurant: restaurant,
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
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
