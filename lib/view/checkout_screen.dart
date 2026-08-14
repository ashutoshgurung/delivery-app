import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/model/addtocart_model.dart';
import 'package:food_ordering_app/model/order_model.dart';
import 'package:food_ordering_app/model/payment_model.dart';
import 'package:food_ordering_app/services/firestore_service.dart';
import 'package:food_ordering_app/view/delivery_in_progress_screen.dart';
import 'package:food_ordering_app/view/payment_screen.dart';
import 'package:food_ordering_app/viewmodel/addtoCart_view_model.dart';
import 'package:food_ordering_app/viewmodel/receipt_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  final String restaurantName; // pass from PopularRestaurantDetailScreen
  const CheckoutScreen({super.key, this.restaurantName = 'Restaurant'});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  int _selectedPayment = 0;
  int _selectedDelivery = 0;
  bool _isPlacingOrder = false;
  final TextEditingController _promoController = TextEditingController();
  String? _appliedPromo;
  double _discount = 0;

  final Map<String, double> _promoCodes = {
    'SAVE10': 0.10,
    'FLAT50': 0.15,
    'NEWUSER': 0.20,
  };

  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'icon': Icons.credit_card_rounded,
      'label': 'Visa •••• 4832',
      'sub': 'Credit Card',
    },
    {
      'icon': Icons.account_balance_wallet_rounded,
      'label': 'eSewa',
      'sub': 'Digital Wallet',
    },
    {
      'icon': Icons.money_rounded,
      'label': 'Cash on Delivery',
      'sub': 'Pay later',
    },
    {
      'icon': Icons.account_balance_wallet_rounded,
      'label': 'Khalti',
      'sub': 'Digital Wallet',
    },
  ];

  final List<Map<String, dynamic>> _deliverySlots = [
    {'time': 'ASAP', 'eta': '25–35 min', 'icon': Icons.flash_on_rounded},
    {'time': '12:30 PM', 'eta': 'Scheduled', 'icon': Icons.schedule_rounded},
    {'time': '1:00 PM', 'eta': 'Scheduled', 'icon': Icons.schedule_rounded},
  ];

  static const Color _bg = Color(0xFFFAF8F5);
  static const Color _ink = Color(0xFF1A1208);
  static const Color _ember = Color(0xFFE8411A);
  static const Color _cream = Color(0xFFF2EDE6);
  static const Color _muted = Color(0xFF8A7E72);
  static const Color _card = Color(0xFFFFFFFF);
  static const Color _green = Color(0xFF2E7D32);

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _promoController.dispose();
    super.dispose();
  }

  // ── Computed totals ───────────────────────────────────────────
  double _subtotal(List<AddtocartModel> items) =>
      items.fold(0, (sum, item) => sum + item.price * item.quantity);
  double get _deliveryFee => 120;
  double _tax(List<AddtocartModel> items) => _subtotal(items) * 0.13;
  double _discountAmount(List<AddtocartModel> items) =>
      _subtotal(items) * _discount;
  double _total(List<AddtocartModel> items) =>
      _subtotal(items) + _deliveryFee + _tax(items) - _discountAmount(items);

  void _applyPromo() {
    final code = _promoController.text.trim().toUpperCase();
    if (_promoCodes.containsKey(code)) {
      setState(() {
        _appliedPromo = code;
        _discount = _promoCodes[code]!;
      });
      FocusScope.of(context).unfocus();
      _showSnack('🎉 Promo applied! ${(_discount * 100).toInt()}% off', _green);
    } else {
      _showSnack('Invalid promo code', Colors.red);
    }
  }

  void _removePromo() {
    setState(() {
      _appliedPromo = null;
      _discount = 0;
      _promoController.clear();
    });
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg, style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _placeOrder(List<AddtocartModel> items) async {
    if (_isPlacingOrder) return;

    setState(() {
      _isPlacingOrder = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        setState(() {
          _isPlacingOrder = false;
        });

        _showSnack('Please login before placing an order.', Colors.red);

        return;
      }

      final orderId = 'ORD-${DateTime.now().millisecondsSinceEpoch}';

      final orderItems = items.map((item) {
        return {'name': item.name, 'qty': item.quantity, 'price': item.price};
      }).toList();

      final total = _total(items).toInt();

      final order = OrderModel(
        id: orderId,
        restaurantName: widget.restaurantName,
        items: orderItems,
        totalPrice: total,
        status: 'pending',
        createdAt: DateTime.now(),

        customerId: user.uid,
        customerName: user.displayName ?? 'Customer',
        customerEmail: user.email ?? '',
      );

      // Khalti
      if (_selectedPayment == 3) {
        setState(() {
          _isPlacingOrder = false;
        });

        if (!mounted) return;

        final paymentRequest = OrderPaymentRequest(
          orderId: orderId,
          orderName: 'Order from ${widget.restaurantName}',
          amountInPaisa: total * 100,
          customerName: user.displayName ?? 'Guest',
          customerEmail: user.email ?? '',
          customerPhone: user.phoneNumber ?? '',
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentScreen(order: paymentRequest),
          ),
        );

        return;
      }

      // Save order to Firebase
      final firestoreService = FirestoreService();

      await firestoreService.placeOrder(user.uid, order);

      if (!mounted) return;

      // Receipt
      context.read<ReceiptProvider>().createReceipt(
        orderId: orderId,
        items: orderItems,
      );

      // Clear cart
      context.read<AddtocartProvider>().clearCart();

      setState(() {
        _isPlacingOrder = false;
      });

      _showOrderSuccess();
    } catch (e) {
      debugPrint('PLACE ORDER ERROR: $e');

      if (!mounted) return;

      setState(() {
        _isPlacingOrder = false;
      });

      _showSnack('Failed to place order. Please try again.', Colors.red);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AddtocartProvider>(
      builder: (context, provider, _) {
        final items = provider.cartItems;

        if (items.isEmpty) {
          return Scaffold(
            backgroundColor: _bg,
            body: SafeArea(
              child: Column(
                children: [
                  _buildHeader(0),
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.shopping_bag_outlined,
                            size: 80,
                            color: _muted,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Your cart is empty',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: _muted,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Add items from the menu to checkout',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: _muted,
                            ),
                          ),
                          const SizedBox(height: 28),
                          ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _ember,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 14,
                              ),
                            ),
                            child: Text(
                              'Browse Menu',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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

        return Scaffold(
          backgroundColor: _bg,
          body: FadeTransition(
            opacity: _fadeAnimation,
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(items.length),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),
                          _buildDeliveryAddress(),
                          const SizedBox(height: 28),
                          _buildOrderItems(items, provider),
                          const SizedBox(height: 28),
                          _buildDeliveryTime(),
                          const SizedBox(height: 28),
                          _buildPaymentMethod(),
                          const SizedBox(height: 28),
                          _buildPromoCode(),
                          const SizedBox(height: 28),
                          _buildPriceSummary(items),
                          const SizedBox(height: 28),
                        ],
                      ),
                    ),
                  ),
                  _buildPlaceOrderButton(items),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(int count) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: _bg,
        border: Border(bottom: BorderSide(color: _cream, width: 1.5)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _cream,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.arrow_back, size: 16, color: _ink),
            ),
          ),
          Expanded(
            child: Text(
              'Checkout',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _ink,
                letterSpacing: -0.5,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _ember.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$count item${count == 1 ? '' : 's'}',
              style: GoogleFonts.poppins(
                color: _ember,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            text.toUpperCase(),
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: _muted,
              letterSpacing: 1.4,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(child: Container(height: 1, color: _cream)),
        ],
      ),
    );
  }

  Widget _buildDeliveryAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Deliver To'),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _ink.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: _ember.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on_rounded,
                  color: _ember,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Home',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '47 Lazimpat Road, Kathmandu 44600',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: _muted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: _ember,
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                ),
                child: Text(
                  'Change',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItems(
    List<AddtocartModel> items,
    AddtocartProvider provider,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Your Order'),
        Container(
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _ink.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              return Column(
                children: [
                  _buildOrderItemRow(item, i, provider),
                  if (i < items.length - 1)
                    Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: _cream,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderItemRow(
    AddtocartModel item,
    int index,
    AddtocartProvider provider,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _cream,
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                item.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Text('🍔', style: TextStyle(fontSize: 22)),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _ink,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 7,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: _cream,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    item.size,
                    style: GoogleFonts.poppins(fontSize: 11, color: _muted),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _quantityButton(
                Icons.remove,
                () => provider.decrementQuantity(index),
              ),
              SizedBox(
                width: 28,
                child: Text(
                  '${item.quantity}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _ink,
                  ),
                ),
              ),
              _quantityButton(
                Icons.add,
                () => provider.incrementQuantity(index),
                filled: true,
              ),
            ],
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Rs.${item.price * item.quantity}',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: _ink,
                ),
              ),
              GestureDetector(
                onTap: () => provider.removeItem(index),
                child: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Remove',
                    style: GoogleFonts.poppins(
                      fontSize: 11,
                      color: Colors.red.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quantityButton(
    IconData icon,
    VoidCallback onTap, {
    bool filled = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: filled ? _ember : _cream,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 14, color: filled ? Colors.white : _ink),
      ),
    );
  }

  Widget _buildDeliveryTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Delivery Time'),
        Row(
          children: _deliverySlots.asMap().entries.map((entry) {
            final i = entry.key;
            final slot = entry.value;
            final selected = _selectedDelivery == i;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => _selectedDelivery = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: EdgeInsets.only(right: i < 2 ? 8 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: selected ? _ember : _card,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: selected ? _ember : _cream,
                      width: 1.5,
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: _ember.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        slot['icon'] as IconData,
                        color: selected ? Colors.white : _muted,
                        size: 20,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        slot['time'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: selected ? Colors.white : _ink,
                        ),
                      ),
                      Text(
                        slot['eta'] as String,
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: selected
                              ? Colors.white.withOpacity(0.8)
                              : _muted,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildPaymentMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Payment'),
        Container(
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _ink.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: _paymentMethods.asMap().entries.map((entry) {
              final i = entry.key;
              final method = entry.value;
              final selected = _selectedPayment == i;
              return Column(
                children: [
                  GestureDetector(
                    onTap: () => setState(() => _selectedPayment = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? _ember.withOpacity(0.05)
                            : Colors.transparent,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: selected
                                  ? _ember.withOpacity(0.12)
                                  : _cream,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              method['icon'] as IconData,
                              color: selected ? _ember : _muted,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  method['label'] as String,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: selected ? _ember : _ink,
                                  ),
                                ),
                                Text(
                                  method['sub'] as String,
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: _muted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selected ? _ember : Colors.transparent,
                              border: Border.all(
                                color: selected ? _ember : _muted,
                                width: 1.5,
                              ),
                            ),
                            child: selected
                                ? const Icon(
                                    Icons.check,
                                    size: 12,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (i < _paymentMethods.length - 1)
                    Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: _cream,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Promo Code'),
        if (_appliedPromo != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _green.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _green.withOpacity(0.4)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_rounded, color: _green, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '$_appliedPromo applied — ${(_discount * 100).toInt()}% off!',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _green,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _removePromo,
                  child: const Icon(
                    Icons.close_rounded,
                    color: _green,
                    size: 18,
                  ),
                ),
              ],
            ),
          )
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: _card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: _cream, width: 1.5),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_offer_rounded, color: _muted, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _promoController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: 'Enter promo code',
                      hintStyle: GoogleFonts.poppins(
                        color: _muted,
                        fontSize: 14,
                      ),
                      border: InputBorder.none,
                    ),
                    style: GoogleFonts.poppins(color: _ink, fontSize: 14),
                    onSubmitted: (_) => _applyPromo(),
                  ),
                ),
                TextButton(
                  onPressed: _applyPromo,
                  style: TextButton.styleFrom(
                    foregroundColor: _ember,
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    'Apply',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 6),
        Text(
          'Try: SAVE10 · FLAT50 · NEWUSER',
          style: GoogleFonts.poppins(fontSize: 11, color: _muted),
        ),
      ],
    );
  }

  Widget _buildPriceSummary(List<AddtocartModel> items) {
    final sub = _subtotal(items);
    final disc = _discountAmount(items);
    final tax = _tax(items);
    final total = _total(items);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel('Bill Summary'),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _card,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _ink.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _priceRow(
                'Subtotal (${items.length} items)',
                'Rs.${sub.toStringAsFixed(0)}',
              ),
              const SizedBox(height: 10),
              _priceRow(
                'Delivery Fee',
                'Rs.${_deliveryFee.toStringAsFixed(0)}',
              ),
              const SizedBox(height: 10),
              _priceRow('VAT (13%)', 'Rs.${tax.toStringAsFixed(0)}'),
              if (_discount > 0) ...[
                const SizedBox(height: 10),
                _priceRow(
                  'Discount ($_appliedPromo)',
                  '− Rs.${disc.toStringAsFixed(0)}',
                  valueColor: _green,
                ),
              ],
              const SizedBox(height: 16),
              Container(height: 1, color: _cream),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: _ink,
                    ),
                  ),
                  Text(
                    'Rs.${total.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: _ember,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _priceRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.poppins(fontSize: 14, color: _muted)),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? _ink,
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceOrderButton(List<AddtocartModel> items) {
    final total = _total(items);
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: const BoxDecoration(
        color: _bg,
        border: Border(top: BorderSide(color: _cream, width: 1.5)),
      ),
      child: GestureDetector(
        onTap: _isPlacingOrder ? null : () => _placeOrder(items),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 58,
          decoration: BoxDecoration(
            color: _isPlacingOrder ? _ember.withOpacity(0.7) : _ember,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _ember.withOpacity(0.4),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isPlacingOrder)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              else ...[
                const Icon(
                  Icons.shopping_bag_rounded,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  'Place Order  ·  Rs.${total.toStringAsFixed(0)}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showOrderSuccess() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: _ember.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: _ember,
                size: 44,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Order Placed! 🎉',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: _ink,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your food is being prepared.\nEstimated delivery: ${_deliverySlots[_selectedDelivery]['eta']}',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: _muted,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // close sheet
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DeliveryScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _ember,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Track Order',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
