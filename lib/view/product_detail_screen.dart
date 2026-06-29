import 'package:flutter/material.dart';
import 'package:food_ordering_app/model/favourite_model.dart';
import 'package:food_ordering_app/view/checkout_screen.dart';
import 'package:food_ordering_app/viewmodel/addtoCart_view_model.dart';
import 'package:food_ordering_app/viewmodel/favourite_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final String name;
  final String description;
  final int price;
  final String image;
  final String restaurantName;

  const ProductDetailScreen({
    super.key,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.restaurantName,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedSizeIndex = -1;
  int _quantity = 1;

  final List<Map<String, dynamic>> _sizes = [
    {'label': 'X-Large', 'color': Colors.blue, 'delta': 100},
    {'label': 'Large', 'color': Colors.green, 'delta': 50},
    {'label': 'Small', 'color': Colors.red, 'delta': 0},
  ];

  void _increment() => setState(() => _quantity++);

  void _decrement() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  int get _currentPrice {
    if (_selectedSizeIndex == -1) return widget.price;
    return widget.price + (_sizes[_selectedSizeIndex]['delta'] as int);
  }

  void _addToCart(BuildContext context) {
    if (_selectedSizeIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a size first!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    context.read<AddtocartProvider>().addProduct(
      image: widget.image,
      name: widget.name,
      price: _currentPrice,
      quantity: _quantity,
      size: _sizes[_selectedSizeIndex]['label'],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to cart!'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favouriteItem = FavouriteModel(
      image: widget.image,
      title: widget.name,
      subtitle: widget.description,
      price: widget.price,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      body: Column(
        children: [
          const SizedBox(height: 50),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 41,
                    width: 41,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.arrow_back),
                  ),
                ),

                Expanded(
                  child: Text(
                    widget.name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Consumer<FavouriteViewModel>(
                  builder: (context, provider, child) {
                    final isFav = provider.isFavourite(favouriteItem);

                    return IconButton(
                      onPressed: () {
                        provider.toggleFavourite(favouriteItem);
                      },
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : Colors.grey,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Container(
            height: 220,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(widget.image, fit: BoxFit.cover),
            ),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(_sizes.length, (index) {
                final isSelected = _selectedSizeIndex == index;
                final color = _sizes[index]['color'] as Color;

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedSizeIndex = index;
                      });
                    },
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? color : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          _sizes[index]['label'],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          const SizedBox(height: 24),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rs.$_currentPrice',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),

                Row(
                  children: [
                    _qtyButton(Icons.remove, _decrement),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        '$_quantity',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    _qtyButton(Icons.add, _increment, filled: true),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.description,
              style: GoogleFonts.poppins(color: Colors.black54),
            ),
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _addToCart(context);

                      if (_selectedSizeIndex != -1) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const CheckoutScreen(),
                          ),
                        );
                      }
                    },
                    child: Container(
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(
                        child: Text(
                          "Checkout",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Consumer<AddtocartProvider>(
                  builder: (context, provider, _) {
                    return InkWell(
                      onTap: () => _addToCart(context),
                      child: Stack(
                        children: [
                          Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(Icons.shopping_cart_outlined),
                          ),
                          if (provider.cartCount > 0)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: CircleAvatar(
                                radius: 8,
                                backgroundColor: Colors.orange,
                                child: Text(
                                  '${provider.cartCount}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
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
        ],
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap, {bool filled = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: filled ? Colors.orange : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: filled ? Colors.white : Colors.black),
      ),
    );
  }
}
