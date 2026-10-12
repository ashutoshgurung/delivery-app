// import 'package:flutter/material.dart';
// import 'package:food_ordering_app/model/popular_restaurant_detail_screen_model.dart';
// import 'package:food_ordering_app/view/product_detail_screen.dart';
// import 'package:google_fonts/google_fonts.dart';

// class PopularRestaurantDetailScreen extends StatefulWidget {
//   final PopularRestaurantDetailScreenModel restaurant;

//   const PopularRestaurantDetailScreen({super.key, required this.restaurant});

//   @override
//   State<PopularRestaurantDetailScreen> createState() =>
//       _PopularRestaurantDetailScreenState();
// }

// class _PopularRestaurantDetailScreenState
//     extends State<PopularRestaurantDetailScreen> {
//   int selectedCategory = 0;

//   @override
//   Widget build(BuildContext context) {
//     final cats = widget.restaurant.categories;
//     final selectedTitle = cats[selectedCategory]['title'] as String;
//     final selectedItems = widget.restaurant.menuItems[selectedTitle] ?? [];

//     return Scaffold(
//       body: Column(
//         children: [
//           const SizedBox(height: 27),

//           // ── Hero image (dynamic) ─────────────────────────────
//           Stack(
//             children: [
//               Image.asset(
//                 widget.restaurant.image,
//                 width: double.maxFinite,
//                 height: 260,
//                 fit: BoxFit.cover,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12.0,
//                   vertical: 12,
//                 ),
//                 child: InkWell(
//                   onTap: () => Navigator.pop(context),
//                   child: Container(
//                     height: 51,
//                     width: 51,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withValues(alpha: 0.5),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: const Icon(Icons.arrow_back),
//                   ),
//                 ),
//               ),
//               Positioned(
//                 bottom: 10,
//                 left: 12,
//                 child: Container(
//                   height: 30,
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(5),
//                     color: Colors.black.withValues(alpha: 0.55),
//                   ),
//                   child: Center(
//                     child: Text(
//                       widget.restaurant.deliveryBadge,
//                       style: GoogleFonts.poppins(
//                         fontSize: 10,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           const SizedBox(height: 16),

//           // ── Name + delivery time ─────────────────────────────
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   widget.restaurant.name,
//                   style: GoogleFonts.poppins(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 Text(
//                   widget.restaurant.time,
//                   style: GoogleFonts.poppins(
//                     fontSize: 10,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 8),

//           // ── Stars + location ─────────────────────────────────
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//             child: Row(
//               children: [
//                 ...List.generate(
//                   5,
//                   (_) => const Icon(Icons.star, color: Colors.orange, size: 15),
//                 ),
//                 const Spacer(),
//                 const Icon(Icons.location_on, size: 15, color: Colors.grey),
//                 Text(
//                   '  ${widget.restaurant.location}',
//                   style: GoogleFonts.poppins(
//                     fontSize: 10,
//                     color: Colors.black.withValues(alpha: 0.5),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 16),

//           // ── Category tabs ────────────────────────────────────
//           SizedBox(
//             height: 50,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: cats.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8.0,
//                     vertical: 8,
//                   ),
//                   child: InkWell(
//                     onTap: () => setState(() => selectedCategory = index),
//                     child: AnimatedContainer(
//                       duration: const Duration(milliseconds: 200),
//                       width: 130,
//                       decoration: BoxDecoration(
//                         boxShadow: const [
//                           BoxShadow(
//                             offset: Offset(0, 3),
//                             color: Colors.black26,
//                             blurRadius: 5,
//                             spreadRadius: 1,
//                           ),
//                         ],
//                         color: selectedCategory == index
//                             ? Colors.red
//                             : Colors.grey,
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Center(
//                         child: Text(
//                           cats[index]['title'] as String,
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),

//           const SizedBox(height: 12),

//           // ── Menu items ───────────────────────────────────────
//           Expanded(
//             child: ListView.builder(
//               itemCount: selectedItems.length,
//               itemBuilder: (context, index) {
//                 final item = selectedItems[index];
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12.0,
//                     vertical: 8,
//                   ),
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => ProductDetailScreen(
//                             name: item['name'] as String,
//                             description: item['sub'] as String,
//                             price: item['price'] as int,
//                             image: item['image'] as String,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Card(
//                       elevation: 3,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       child: ListTile(
//                         contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 8,
//                         ),
//                         leading: ClipRRect(
//                           borderRadius: BorderRadius.circular(10),
//                           child: Image.asset(
//                             item['image'] as String,
//                             width: 60,
//                             height: 60,
//                             fit: BoxFit.cover,
//                             errorBuilder: (_, __, ___) => Container(
//                               width: 60,
//                               height: 60,
//                               color: Colors.orange.shade50,
//                               child: const Center(
//                                 child: Text(
//                                   '🍕',
//                                   style: TextStyle(fontSize: 28),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         title: Text(
//                           item['name'] as String,
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                         ),
//                         subtitle: Text(
//                           item['sub'] as String,
//                           style: GoogleFonts.poppins(fontSize: 10),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         trailing: Text(
//                           'Rs.${item['price']}',
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.bold,
//                             color: Colors.orange,
//                             fontSize: 13,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:food_ordering_app/model/popular_restaurant_detail_screen_model.dart';
import 'package:food_ordering_app/view/product_detail_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class PopularRestaurantDetailScreen extends StatefulWidget {
  final PopularRestaurantDetailScreenModel restaurant;

  const PopularRestaurantDetailScreen({super.key, required this.restaurant});

  @override
  State<PopularRestaurantDetailScreen> createState() =>
      _PopularRestaurantDetailScreenState();
}

class _PopularRestaurantDetailScreenState
    extends State<PopularRestaurantDetailScreen> {
  int selectedCategory = 0;

  @override
  Widget build(BuildContext context) {
    final cats = widget.restaurant.categories;
    final selectedTitle = cats[selectedCategory]['title'] as String;
    final selectedItems = widget.restaurant.menuItems[selectedTitle] ?? [];

    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 27),

          Stack(
            children: [
              Image.asset(
                widget.restaurant.image,
                width: double.maxFinite,
                height: 260,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 12,
                ),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 51,
                    width: 51,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_back),
                  ),
                ),
              ),
              Positioned(
                bottom: 10,
                left: 12,
                child: Container(
                  height: 30,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.black.withValues(alpha: 0.55),
                  ),
                  child: Center(
                    child: Text(
                      widget.restaurant.deliveryBadge,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

         
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.restaurant.name,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  widget.restaurant.time,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

       
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                ...List.generate(
                  5,
                  (_) =>
                      const Icon(Icons.star, color: Colors.orange, size: 15),
                ),
                const Spacer(),
                const Icon(Icons.location_on, size: 15, color: Colors.grey),
                Text(
                  '  ${widget.restaurant.location}',
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: Colors.black.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),


          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cats.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 8,
                  ),
                  child: InkWell(
                    onTap: () => setState(() => selectedCategory = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 130,
                      decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(0, 3),
                            color: Colors.black26,
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                        color: selectedCategory == index
                            ? Colors.red
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          cats[index]['title'] as String,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: ListView.builder(
              itemCount: selectedItems.length,
              itemBuilder: (context, index) {
                final item = selectedItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductDetailScreen(
                            name: item['name'] as String,
                            description: item['sub'] as String,
                            price: item['price'] as int,
                            image: item['image'] as String,
                            // ── pass restaurant name down ──
                            restaurantName: widget.restaurant.name,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            item['image'] as String,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 60,
                              height: 60,
                              color: Colors.orange.shade50,
                              child: const Center(
                                child: Text(
                                  '🍕',
                                  style: TextStyle(fontSize: 28),
                                ),
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          item['name'] as String,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          item['sub'] as String,
                          style: GoogleFonts.poppins(fontSize: 10),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          'Rs.${item['price']}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}