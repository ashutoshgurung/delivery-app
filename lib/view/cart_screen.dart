import 'package:flutter/material.dart';
import 'package:food_ordering_app/view/checkout_screen.dart';
import 'package:food_ordering_app/viewmodel/addtoCart_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.black26),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black),
          ),
        ),
        title: Text(
          "My Cart",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<AddtocartProvider>(
        builder: (context, provider, child) {
          // ── Empty state ──
          if (provider.cartItems.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Your cart is empty",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Add items to get started",
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // ── Cart item list ──
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: provider.cartItems.length,
                  itemBuilder: (context, index) {
                    final item = provider.cartItems[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Food icon
                          Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.asset(
                              item.image,
                              height: 30,
                              width: 30,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Name, size, price
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.name,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                // Size chip
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    item.size,
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Rs.${item.price * item.quantity}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Quantity controls + delete
                          Column(
                            children: [
                              // Delete
                              GestureDetector(
                                onTap: () {
                                  provider.removeItem(index);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Item removed",
                                        style: GoogleFonts.poppins(),
                                      ),
                                      backgroundColor: Colors.red,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      duration: const Duration(seconds: 1),
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.red.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                    size: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),

                              // − qty +
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () =>
                                        provider.decrementQuantity(index),
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade100,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color: Colors.grey.shade300,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.remove,
                                        size: 16,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    child: Text(
                                      "${item.quantity}",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () =>
                                        provider.incrementQuantity(index),
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // ── Summary footer ──
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Total row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total (${provider.cartCount} items)",
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "Rs.${provider.totalPrice}",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Checkout button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CheckoutScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Proceed to Checkout",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
