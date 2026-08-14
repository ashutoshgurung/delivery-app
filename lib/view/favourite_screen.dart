import 'package:flutter/material.dart';
import 'package:food_ordering_app/viewmodel/favourite_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavouriteViewModel>(context);
    final favourites = provider.favourites;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        centerTitle: true,
        title: Text(
          "Favorites",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: favourites.isEmpty
          ? Center(
              child: Text(
                "No favourites yet",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : ListView.builder(
              itemCount: favourites.length,
              itemBuilder: (context, index) {
                final item = favourites[index];

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundImage: AssetImage(item.image),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.title,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.subtitle,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (item.price != null)
                                Text(
                                  "Rs.${item.price}",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              IconButton(
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  provider.toggleFavourite(item);
                                },
                                icon: const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 22,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
