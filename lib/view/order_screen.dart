// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:flutter/material.dart';
// // import 'package:food_ordering_app/model/order_model.dart';
// // import 'package:google_fonts/google_fonts.dart';
// // import 'package:intl/intl.dart';

// // class OrderScreen extends StatelessWidget {
// //   const OrderScreen({super.key});

// //   @override
// //   Widget build(BuildContext context) {
// //     final uid = FirebaseAuth.instance.currentUser?.uid;

// //     return Scaffold(
// //       backgroundColor: Colors.grey.shade100,
// //       appBar: AppBar(
// //         automaticallyImplyLeading: false,
// //         backgroundColor: Colors.red,
// //         elevation: 0,
// //         title: Text(
// //           'My Orders',
// //           style: GoogleFonts.poppins(
// //             color: Colors.white,
// //             fontWeight: FontWeight.bold,
// //             fontSize: 18,
// //           ),
// //         ),
// //         centerTitle: true,
// //       ),
// //       body: uid == null
// //           ? _buildNotLoggedIn(context)
// //           : StreamBuilder<QuerySnapshot>(
// //               stream: FirebaseFirestore.instance
// //                   .collection('users')
// //                   .doc(uid)
// //                   .collection('orders')
// //                   .orderBy('createdAt', descending: true)
// //                   .snapshots(),
// //               builder: (context, snapshot) {
// //                 if (snapshot.connectionState == ConnectionState.waiting) {
// //                   return const Center(
// //                     child: CircularProgressIndicator(color: Colors.red),
// //                   );
// //                 }

// //                 if (snapshot.hasError) {
// //                   return _buildError();
// //                 }

// //                 final docs = snapshot.data?.docs ?? [];

// //                 if (docs.isEmpty) {
// //                   return _buildEmptyState(context);
// //                 }

// //                 final orders = docs
// //                     .map(
// //                       (d) => OrderModel.fromMap(
// //                         d.id,
// //                         d.data() as Map<String, dynamic>,
// //                       ),
// //                     )
// //                     .toList();

// //                 return ListView.builder(
// //                   padding: const EdgeInsets.all(16),
// //                   itemCount: orders.length,
// //                   itemBuilder: (context, index) =>
// //                       _OrderCard(order: orders[index]),
// //                 );
// //               },
// //             ),
// //     );
// //   }

// //   Widget _buildNotLoggedIn(BuildContext context) {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           const Icon(Icons.lock_outline, size: 80, color: Colors.grey),
// //           const SizedBox(height: 16),
// //           Text(
// //             'Please log in to view orders',
// //             style: GoogleFonts.poppins(
// //               fontSize: 16,
// //               color: Colors.grey,
// //               fontWeight: FontWeight.w500,
// //             ),
// //           ),
// //           const SizedBox(height: 20),
// //           ElevatedButton(
// //             onPressed: () => Navigator.pushNamed(context, '/signin'),
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: Colors.red,
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
// //             ),
// //             child: Text(
// //               'Sign In',
// //               style: GoogleFonts.poppins(
// //                 color: Colors.white,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildEmptyState(BuildContext context) {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           const Icon(Icons.receipt_long_outlined, size: 90, color: Colors.grey),
// //           const SizedBox(height: 16),
// //           Text(
// //             'No orders yet',
// //             style: GoogleFonts.poppins(
// //               fontSize: 18,
// //               fontWeight: FontWeight.w600,
// //               color: Colors.grey,
// //             ),
// //           ),
// //           const SizedBox(height: 8),
// //           Text(
// //             'Your order history will appear here',
// //             style: GoogleFonts.poppins(
// //               fontSize: 13,
// //               color: Colors.grey.shade400,
// //             ),
// //           ),
// //           const SizedBox(height: 28),
// //           ElevatedButton(
// //             onPressed: () => Navigator.pushNamed(context, '/navigation'),
// //             style: ElevatedButton.styleFrom(
// //               backgroundColor: Colors.red,
// //               shape: RoundedRectangleBorder(
// //                 borderRadius: BorderRadius.circular(12),
// //               ),
// //               padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
// //             ),
// //             child: Text(
// //               'Browse Restaurants',
// //               style: GoogleFonts.poppins(
// //                 color: Colors.white,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }

// //   Widget _buildError() {
// //     return Center(
// //       child: Column(
// //         mainAxisAlignment: MainAxisAlignment.center,
// //         children: [
// //           const Icon(Icons.wifi_off_rounded, size: 80, color: Colors.grey),
// //           const SizedBox(height: 16),
// //           Text(
// //             'Something went wrong',
// //             style: GoogleFonts.poppins(
// //               fontSize: 16,
// //               color: Colors.grey,
// //               fontWeight: FontWeight.w500,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _OrderCard extends StatelessWidget {
// //   final OrderModel order;

// //   const _OrderCard({required this.order});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       margin: const EdgeInsets.only(bottom: 16),
// //       decoration: BoxDecoration(
// //         color: Colors.white,
// //         borderRadius: BorderRadius.circular(16),
// //         boxShadow: const [
// //           BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
// //         ],
// //       ),
// //       child: Column(
// //         children: [
// //           Container(
// //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
// //             decoration: BoxDecoration(
// //               color: Colors.red.withOpacity(0.05),
// //               borderRadius: const BorderRadius.vertical(
// //                 top: Radius.circular(16),
// //               ),
// //             ),
// //             child: Row(
// //               children: [
// //                 Container(
// //                   padding: const EdgeInsets.all(8),
// //                   decoration: BoxDecoration(
// //                     color: Colors.red.withOpacity(0.1),
// //                     borderRadius: BorderRadius.circular(10),
// //                   ),
// //                   child: const Icon(
// //                     Icons.storefront_rounded,
// //                     color: Colors.red,
// //                     size: 20,
// //                   ),
// //                 ),
// //                 const SizedBox(width: 12),
// //                 Expanded(
// //                   child: Column(
// //                     crossAxisAlignment: CrossAxisAlignment.start,
// //                     children: [
// //                       Text(
// //                         order.restaurantName,
// //                         style: GoogleFonts.poppins(
// //                           fontWeight: FontWeight.bold,
// //                           fontSize: 15,
// //                           color: Colors.black,
// //                         ),
// //                       ),
// //                       Text(
// //                         DateFormat(
// //                           'MMM d, yyyy • h:mm a',
// //                         ).format(order.createdAt),
// //                         style: GoogleFonts.poppins(
// //                           fontSize: 11,
// //                           color: Colors.grey,
// //                         ),
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //                 Row(
// //                   children: [
// //                     _StatusBadge(status: order.status),
// //                     SizedBox(width: 5),
// //                     IconButton(
// //                       onPressed: () {
// //                         _deleteOrder(context, order.id);
// //                       },
// //                       icon: Icon(Icons.delete, color: Colors.red),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),

// //           Padding(
// //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
// //             child: Column(
// //               children: [
// //                 ...order.items.map((item) => _ItemRow(item: item)),
// //                 const SizedBox(height: 8),
// //                 const Divider(height: 1),
// //                 const SizedBox(height: 12),

// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                   children: [
// //                     Text(
// //                       '${order.items.length} item${order.items.length == 1 ? '' : 's'}',
// //                       style: GoogleFonts.poppins(
// //                         fontSize: 13,
// //                         color: Colors.grey,
// //                       ),
// //                     ),
// //                     Text(
// //                       'Rs.${order.totalPrice}',
// //                       style: GoogleFonts.poppins(
// //                         fontSize: 16,
// //                         fontWeight: FontWeight.bold,
// //                         color: Colors.red,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ),

// //           Padding(
// //             padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
// //             child: SizedBox(
// //               width: double.infinity,
// //               height: 44,
// //               child: OutlinedButton.icon(
// //                 onPressed: () {
// //                   // TODO: push items back into cart
// //                   ScaffoldMessenger.of(context).showSnackBar(
// //                     SnackBar(
// //                       content: Text(
// //                         'Items added to cart!',
// //                         style: GoogleFonts.poppins(),
// //                       ),
// //                       backgroundColor: Colors.red,
// //                       behavior: SnackBarBehavior.floating,
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(12),
// //                       ),
// //                     ),
// //                   );
// //                 },
// //                 icon: const Icon(Icons.replay_rounded, size: 18),
// //                 label: Text(
// //                   'Reorder',
// //                   style: GoogleFonts.poppins(
// //                     fontWeight: FontWeight.w600,
// //                     fontSize: 14,
// //                   ),
// //                 ),
// //                 style: OutlinedButton.styleFrom(
// //                   foregroundColor: Colors.red,
// //                   side: const BorderSide(color: Colors.red),
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(12),
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // Future<void> _deleteOrder(BuildContext context, String orderId) async {
// //   final uid = FirebaseAuth.instance.currentUser?.uid;

// //   if (uid == null) return;

// //   final confirm = await showDialog<bool>(
// //     context: context,
// //     builder: (context) => AlertDialog(
// //       title: const Text("Delete Order"),
// //       content: const Text("Are you sure you want to delete this order?"),
// //       actions: [
// //         TextButton(
// //           onPressed: () => Navigator.pop(context, false),
// //           child: const Text("Cancel"),
// //         ),
// //         ElevatedButton(
// //           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
// //           onPressed: () => Navigator.pop(context, true),
// //           child: const Text("Delete", style: TextStyle(color: Colors.white)),
// //         ),
// //       ],
// //     ),
// //   );

// //   if (confirm != true) return;

// //   await FirebaseFirestore.instance
// //       .collection('users')
// //       .doc(uid)
// //       .collection('orders')
// //       .doc(orderId)
// //       .delete();

// //   if (context.mounted) {
// //     ScaffoldMessenger.of(context).showSnackBar(
// //       const SnackBar(
// //         content: Text("Order deleted successfully"),
// //         backgroundColor: Colors.red,
// //       ),
// //     );
// //   }
// // }

// // class _ItemRow extends StatelessWidget {
// //   final Map<String, dynamic> item;

// //   const _ItemRow({required this.item});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 4),
// //       child: Row(
// //         children: [
// //           Container(
// //             width: 6,
// //             height: 6,
// //             decoration: const BoxDecoration(
// //               color: Colors.red,
// //               shape: BoxShape.circle,
// //             ),
// //           ),
// //           const SizedBox(width: 10),
// //           Expanded(
// //             child: Text(
// //               '${item['name'] ?? ''}',
// //               style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
// //             ),
// //           ),
// //           Text(
// //             'x${item['quantity'] ?? 1}', // FIX: was 'qty'
// //             style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
// //           ),
// //           const SizedBox(width: 12),
// //           Text(
// //             'Rs.${(item['price'] ?? 0) * (item['quantity'] ?? 1)}', // FIX: was 'qty'
// //             style: GoogleFonts.poppins(
// //               fontSize: 13,
// //               fontWeight: FontWeight.w600,
// //               color: Colors.black,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _StatusBadge extends StatelessWidget {
// //   final String status;

// //   const _StatusBadge({required this.status});

// //   @override
// //   Widget build(BuildContext context) {
// //     final config = switch (status) {
// //       'delivered' => (
// //         color: Colors.green,
// //         icon: Icons.check_circle_rounded,
// //         label: 'Delivered',
// //       ),
// //       'preparing' => (
// //         color: Colors.orange,
// //         icon: Icons.restaurant_rounded,
// //         label: 'Preparing',
// //       ),
// //       'cancelled' => (
// //         color: Colors.red,
// //         icon: Icons.cancel_rounded,
// //         label: 'Cancelled',
// //       ),
// //       _ => (
// //         color: Colors.blue,
// //         icon: Icons.access_time_rounded,
// //         label: 'Pending',
// //       ),
// //     };

// //     return Container(
// //       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //       decoration: BoxDecoration(
// //         color: config.color.withOpacity(0.1),
// //         borderRadius: BorderRadius.circular(20),
// //         border: Border.all(color: config.color.withOpacity(0.4)),
// //       ),
// //       child: Row(
// //         mainAxisSize: MainAxisSize.min,
// //         children: [
// //           Icon(config.icon, size: 12, color: config.color),
// //           const SizedBox(width: 4),
// //           Text(
// //             config.label,
// //             style: GoogleFonts.poppins(
// //               fontSize: 11,
// //               fontWeight: FontWeight.w600,
// //               color: config.color,
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }


// import 'dart:ui';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:food_ordering_app/viewmodel/order_viewmodel.dart';
// import 'package:http/http.dart';
// import 'package:provider/provider.dart';

// class OrdersScreen extends StatefulWidget {
//   const OrdersScreen({super.key});

//   @override
//   State<OrdersScreen> createState() =>
//       _OrdersScreenState();
// }

// class _OrdersScreenState extends State<OrdersScreen> {
//   @override
//   void initState() {
//     super.initState();

//     Future.microtask(() {
//       final uid =
//           FirebaseAuth.instance.currentUser?.uid;

//       if (uid != null) {
//         context
//             .read<OrderViewModel>()
//             .startOrdersListener(uid);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final vm = context.watch<OrderViewModel>();

//     if (vm.isLoading) {
//       return const Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     if (vm.errorMessage != null) {
//       return Scaffold(
//         body: Center(
//           child: Text(vm.errorMessage!),
//         ),
//       );
//     }

//     if (vm.orders.isEmpty) {
//       return const Scaffold(
//         body: Center(
//           child: Text('No orders yet'),
//         ),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('My Orders'),
//       ),

//       body: ListView.builder(
//         itemCount: vm.orders.length,
//         itemBuilder: (context, index) {
//           final order = vm.orders[index];

//           return Card(
//             margin: const EdgeInsets.all(12),
//             child: ListTile(
//               title: Text(
//                 order.restaurantName,
//               ),

//               subtitle: Column(
//                 crossAxisAlignment:
//                     CrossAxisAlignment.start,
//                 children: [
//                   const SizedBox(height: 5),

//                   Text(
//                     'Rs. ${order.totalPrice}',
//                   ),

//                   const SizedBox(height: 5),

//                   Text(
//                     'Status: ${order.status}',
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_ordering_app/model/order_model.dart';
import 'package:food_ordering_app/viewmodel/order_viewmodel.dart';

typedef OrderScreen = CustomerOrderScreen;

class CustomerOrderScreen
    extends StatefulWidget {
  const CustomerOrderScreen({
    super.key,
  });

  @override
  State<CustomerOrderScreen> createState() =>
      _CustomerOrderScreenState();
}

class _CustomerOrderScreenState
    extends State<CustomerOrderScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(
      () {
        final uid =
            FirebaseAuth
                .instance
                .currentUser
                ?.uid;

        if (uid != null) {
          context
              .read<OrderViewModel>()
              .startOrdersListener(
                uid,
              );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text('My Orders'),
        centerTitle: true,
      ),

      body:
          Consumer<OrderViewModel>(
        builder: (
          context,
          vm,
          child,
        ) {
          if (vm.isLoading) {
            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          if (vm.errorMessage != null) {
            return Center(
              child: Text(
                vm.errorMessage!,
              ),
            );
          }

          if (vm.orders.isEmpty) {
            return const Center(
              child:
                  Text(
                'No orders yet',
              ),
            );
          }

          return ListView.builder(
            padding:
                const EdgeInsets.all(16),

            itemCount:
                vm.orders.length,

            itemBuilder:
                (context, index) {
              final order =
                  vm.orders[index];

              return _CustomerOrderCard(
                order: order,
              );
            },
          );
        },
      ),
    );
  }
}

class _CustomerOrderCard
    extends StatelessWidget {
  final OrderModel order;

  const _CustomerOrderCard({
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:
          const EdgeInsets.only(
        bottom: 14,
      ),

      shape:
          RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16),
      ),

      child: Padding(
        padding:
            const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    order.restaurantName,
                    style:
                        const TextStyle(
                      fontSize: 17,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                _StatusBadge(
                  status:
                      order.status,
                ),
              ],
            ),

            const SizedBox(
              height: 8,
            ),

            Text(
              'Order ID: ${order.id}',
              style:
                  TextStyle(
                color:
                    Colors.grey.shade600,
                fontSize: 12,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            ...order.items.map(
              (item) {
                return Padding(
                  padding:
                      const EdgeInsets
                          .symmetric(
                    vertical: 3,
                  ),

                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${item['name']} × ${item['quantity']}',
                        ),
                      ),

                      Text(
                        'Rs.${((item['price'] ?? 0) * (item['quantity'] ?? 1)).toStringAsFixed(0)}',
                      ),
                    ],
                  ),
                );
              },
            ),

            const Divider(),

            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,

              children: [
                const Text(
                  'Total',
                  style:
                      TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                Text(
                  'Rs.${order.totalPrice.toStringAsFixed(0)}',
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge
    extends StatelessWidget {
  final String status;

  const _StatusBadge({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (status) {
      case 'pending':
        color = Colors.orange;
        break;

      case 'accepted':
        color = Colors.green;
        break;

      case 'preparing':
        color = Colors.blue;
        break;

      case 'out_for_delivery':
        color = Colors.purple;
        break;

      case 'delivered':
        color = Colors.teal;
        break;

      case 'cancelled':
        color = Colors.red;
        break;

      default:
        color = Colors.grey;
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      decoration: BoxDecoration(
        color: color,
        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Text(
        status
            .replaceAll('_', ' ')
            .toUpperCase(),

        style:
            const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight:
              FontWeight.bold,
        ),
      ),
    );
  }
}