// import 'package:flutter/material.dart';
// import 'package:food_ordering_app/view/admin_order_detail_screen.dart';
// import 'package:food_ordering_app/viewmodel/admin_view_model.dart';
// import 'package:provider/provider.dart';

// const List<String> kOrderStatuses = [
//   'pending',
//   'preparing',
//   'delivered',
// ];

// class AdminOrderScreen extends StatefulWidget {
//   const AdminOrderScreen({super.key});

//   @override
//   State<AdminOrderScreen> createState() => _AdminOrderScreenState();
// }

// class _AdminOrderScreenState extends State<AdminOrderScreen> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<AdminViewModel>().fetchOrders();
//     });
//   }

//   Color _statusColor(String status) {
//     switch (status) {
//       case 'delivered':
//         return Colors.green;
//       case 'preparing':
//         return Colors.orange;
//       default:
//         return Colors.grey;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final vm = context.watch<AdminViewModel>();

//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F6F6),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFCC0000),
//         foregroundColor: Colors.white,
//         title: Center(
//           child: const Text(
//             'Manage Orders',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//       body: vm.isLoadingOrders
//           ? const Center(child: CircularProgressIndicator())
//           : vm.orders.isEmpty
//           ? const Center(child: Text('No orders yet.'))
//           : RefreshIndicator(
//               onRefresh: vm.fetchOrders,
//               child: ListView.builder(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: vm.orders.length,
//                 itemBuilder: (context, index) {
//                   final order = vm.orders[index];
//                   return GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (_) => AdminOrderDetailScreen(order: order),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       margin: const EdgeInsets.only(bottom: 14),
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.05),
//                             blurRadius: 10,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   order.customerEmail ?? 'Guest customer',
//                                   style: const TextStyle(fontWeight: FontWeight.w800),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               Container(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 10,
//                                   vertical: 4,
//                                 ),
//                                 decoration: BoxDecoration(
//                                   color: _statusColor(order.status).withOpacity(0.12),
//                                   borderRadius: BorderRadius.circular(20),
//                                 ),
//                                 child: Text(
//                                   order.status,
//                                   style: TextStyle(
//                                     color: _statusColor(order.status),
//                                     fontSize: 12,
//                                     fontWeight: FontWeight.w700,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             order.restaurantName,
//                             style: const TextStyle(color: Colors.grey, fontSize: 12),
//                           ),
//                           if (order.address != null) ...[
//                             const SizedBox(height: 4),
//                             Row(
//                               children: [
//                                 const Icon(Icons.location_on_outlined,
//                                     size: 14, color: Colors.grey),
//                                 const SizedBox(width: 4),
//                                 Expanded(
//                                   child: Text(
//                                     order.address!,
//                                     style: const TextStyle(
//                                         color: Colors.grey, fontSize: 12),
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ],
//                           const SizedBox(height: 10),
//                           ...order.items.map(
//                             (item) => Padding(
//                               padding: const EdgeInsets.only(bottom: 2),
//                               child: Text(
//                                 '${item['quantity'] ?? 1}x ${item['name'] ?? 'Item'}',
//                                 style: const TextStyle(fontSize: 13),
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Total: Rs. ${order.totalPrice}',
//                                     style: const TextStyle(fontWeight: FontWeight.w800),
//                                   ),
//                                   if (order.paymentMethod != null)
//                                     Text(
//                                       order.paymentMethod!,
//                                       style: const TextStyle(
//                                           color: Colors.grey, fontSize: 11),
//                                     ),
//                                 ],
//                               ),
//                               // Stops the tap on the dropdown from also
//                               // triggering the card's navigation.
//                               GestureDetector(
//                                 onTap: () {},
//                                 child: DropdownButton<String>(
//                                   value: order.status,
//                                   underline: const SizedBox(),
//                                   items: kOrderStatuses
//                                       .map(
//                                         (s) => DropdownMenuItem(
//                                           value: s,
//                                           child: Text(s),
//                                         ),
//                                       )
//                                       .toList(),
//                                   onChanged: (newStatus) {
//                                     if (newStatus == null) return;
//                                     context
//                                         .read<AdminViewModel>()
//                                         .updateOrderStatus(order.id, newStatus);
//                                   },
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:food_ordering_app/model/order_model.dart';
import 'package:food_ordering_app/viewmodel/admin_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminOrderViewModel>().startOrdersListener();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        elevation: 0,
        title: Text(
          'Orders',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<AdminOrderViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading && vm.orders.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.red),
            );
          }

          if (vm.errorMessage != null && vm.orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 70, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'Something went wrong',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    vm.errorMessage!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      vm.startOrdersListener();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'Retry',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            );
          }

          if (vm.orders.isEmpty) {
            return RefreshIndicator(
              color: Colors.red,
              onRefresh: () async {
                vm.startOrdersListener();
              },
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.receipt_long_outlined,
                            size: 80,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No orders yet',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Customer orders will appear here',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: Colors.red,
            onRefresh: () async {
              vm.startOrdersListener();
            },
            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: vm.orders.length,
              itemBuilder: (context, index) {
                final order = vm.orders[index];

                return _OrderCard(order: order, vm: vm);
              },
            ),
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  final AdminOrderViewModel vm;

  const _OrderCard({required this.order, required this.vm});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.05),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.storefront_rounded,
                    color: Colors.red,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.restaurantName,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        DateFormat(
                          'MMM d, yyyy • h:mm a',
                        ).format(order.createdAt),
                        style: GoogleFonts.poppins(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(status: order.status),
              ],
            ),
          ),

          // Customer information
          if (order.customerEmail != null || order.userId != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (order.customerEmail != null)
                      Row(
                        children: [
                          const Icon(
                            Icons.email_outlined,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              order.customerEmail!,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    if (order.userId != null) ...[
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(
                            Icons.person_outline,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Customer ID: ${order.userId}',
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              children: [
                ...order.items.map((item) => _ItemRow(item: item)),

                const SizedBox(height: 8),

                const Divider(height: 1),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${order.items.length} item${order.items.length == 1 ? '' : 's'}',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Rs.${order.totalPrice}',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),

                if (order.paymentMethod != null) ...[
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        order.paymentMethod!,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _showStatusDialog(context, order, vm);
                    },
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: Text(
                      'Update Status',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  onPressed: () {
                    _deleteOrder(context, order.id, vm);
                  },
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemRow extends StatelessWidget {
  final Map<String, dynamic> item;

  const _ItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final quantity = (item['quantity'] ?? item['qty'] ?? 1) as num;

    final price = (item['price'] ?? 0) as num;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${item['name'] ?? ''}',
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87),
            ),
          ),
          Text(
            'x${quantity.toInt()}',
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Text(
            'Rs.${(price * quantity).toInt()}',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final config = switch (status.toLowerCase()) {
      'delivered' => (
        color: Colors.green,
        icon: Icons.check_circle_rounded,
        label: 'Delivered',
      ),
      'preparing' => (
        color: Colors.orange,
        icon: Icons.restaurant_rounded,
        label: 'Preparing',
      ),
      'cancelled' => (
        color: Colors.red,
        icon: Icons.cancel_rounded,
        label: 'Cancelled',
      ),
      'ready' => (
        color: Colors.teal,
        icon: Icons.done_all_rounded,
        label: 'Ready',
      ),
      'out_for_delivery' => (
        color: Colors.purple,
        icon: Icons.delivery_dining,
        label: 'Out for Delivery',
      ),
      _ => (
        color: Colors.blue,
        icon: Icons.access_time_rounded,
        label: 'Pending',
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: config.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: config.color.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(config.icon, size: 12, color: config.color),
          const SizedBox(width: 4),
          Text(
            config.label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: config.color,
            ),
          ),
        ],
      ),
    );
  }
}

void _showStatusDialog(
  BuildContext context,
  OrderModel order,
  AdminOrderViewModel vm,
) {
  String selectedStatus = order.status;

  showDialog(
    context: context,
    builder: (dialogContext) {
      return StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            title: Text(
              'Update Order Status',
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
            ),
            content: DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(value: 'preparing', child: Text('Preparing')),
                DropdownMenuItem(value: 'ready', child: Text('Ready')),
                DropdownMenuItem(
                  value: 'out_for_delivery',
                  child: Text('Out for Delivery'),
                ),
                DropdownMenuItem(value: 'delivered', child: Text('Delivered')),
                DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setDialogState(() {
                    selectedStatus = value;
                  });
                }
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await vm.updateOrderStatus(order.id, selectedStatus);

                  if (dialogContext.mounted) {
                    Navigator.pop(dialogContext);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text(
                  'Update',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        },
      );
    },
  );
}

Future<void> _deleteOrder(
  BuildContext context,
  String orderId,
  AdminOrderViewModel vm,
) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete Order'),
        content: const Text('Are you sure you want to delete this order?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );

  if (confirm != true) return;

  await vm.deleteOrder(orderId);

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order deleted successfully'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
