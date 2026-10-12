<<<<<<< HEAD
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
=======
import 'package:flutter/material.dart';
import 'package:food_ordering_app/model/order_model.dart';
import 'package:food_ordering_app/viewmodel/admin_order_view_model.dart';
import 'package:provider/provider.dart';

class AdminOrderScreen extends StatelessWidget {
  const AdminOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminOrderViewModel(),
      child: const _AdminOrderBody(),
    );
  }
}

class _AdminOrderBody extends StatelessWidget {
  const _AdminOrderBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdminOrderViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Orders',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: _buildBody(context, vm),
    );
  }

  Widget _buildBody(BuildContext context, AdminOrderViewModel vm) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (vm.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(vm.errorMessage!, textAlign: TextAlign.center),
        ),
      );
    }

    if (vm.orders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined, size: 70, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No orders yet',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        vm.listenToOrders();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vm.orders.length,
        itemBuilder: (context, index) {
          final order = vm.orders[index];

          return _OrderCard(order: order);
>>>>>>> origin/main
        },
      ),
    );
  }
}

<<<<<<< HEAD
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
=======
// ================================================================
// ORDER CARD
// ================================================================

class _OrderCard extends StatefulWidget {
  final OrderModel order;

  const _OrderCard({required this.order});

  @override
  State<_OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<_OrderCard> {
  late String selectedStatus;
  bool isUpdating = false;

  @override
  void initState() {
    super.initState();

    selectedStatus = _validStatus(widget.order.status)
        ? widget.order.status
        : 'pending';
  }

  @override
  void didUpdateWidget(covariant _OrderCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.order.status != widget.order.status) {
      selectedStatus = _validStatus(widget.order.status)
          ? widget.order.status
          : 'pending';
    }
  }

  Future<void> _deleteOrder() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Order?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            'Are you sure you want to delete Order #${widget.order.id}?\n\n'
            'This will permanently remove the order from both the admin '
            'and customer order history.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) {
      return;
    }

    if (!mounted) return;

    setState(() {
      isUpdating = true;
    });

    try {
      final vm = context.read<AdminOrderViewModel>();

      await vm.deleteOrder(widget.order);

      if (!mounted) return;

      if (vm.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(vm.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Order deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isUpdating = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Order #${widget.order.id}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                _StatusBadge(status: widget.order.status),
              ],
            ),

            const SizedBox(height: 12),

            const Divider(),

            const SizedBox(height: 10),

            if (widget.order.customerName != null &&
                widget.order.customerName!.isNotEmpty)
              _InfoRow(
                icon: Icons.person_outline,
                title: 'Customer',
                value: widget.order.customerName!,
              ),

            if (widget.order.customerEmail != null &&
                widget.order.customerEmail!.isNotEmpty)
              _InfoRow(
                icon: Icons.email_outlined,
                title: 'Email',
                value: widget.order.customerEmail!,
              ),

            _InfoRow(
              icon: Icons.restaurant_outlined,
              title: 'Restaurant',
              value: widget.order.restaurantName,
            ),

            _InfoRow(
              icon: Icons.currency_rupee,
              title: 'Total',
              value: 'Rs. ${widget.order.totalPrice}',
            ),

            if (widget.order.address != null &&
                widget.order.address!.isNotEmpty)
              _InfoRow(
                icon: Icons.location_on_outlined,
                title: 'Address',
                value: widget.order.address!,
              ),

            _InfoRow(
              icon: Icons.access_time,
              title: 'Ordered',
              value: _formatDate(widget.order.createdAt),
            ),

            const SizedBox(height: 12),

            const Text(
              'Items',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),

            const SizedBox(height: 8),

            ...widget.order.items.map((item) => _ItemRow(item: item)),

            const SizedBox(height: 16),

            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Change Order Status',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'pending', child: Text('Pending')),
                DropdownMenuItem(value: 'preparing', child: Text('Preparing')),
                DropdownMenuItem(
                  value: 'out_for_delivery',
                  child: Text('Out for Delivery'),
                ),
                DropdownMenuItem(value: 'delivered', child: Text('Delivered')),
                DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
              ],
              onChanged: isUpdating
                  ? null
                  : (value) {
                      if (value == null) return;

                      setState(() {
                        selectedStatus = value;
                      });
                    },
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: isUpdating || selectedStatus == widget.order.status
                    ? null
                    : _updateStatus,
                child: isUpdating
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Update Order',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: isUpdating ? null : _deleteOrder,
                icon: const Icon(Icons.delete_outline),
                label: const Text(
                  'Delete Order',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateStatus() async {
    setState(() {
      isUpdating = true;
    });

    try {
      final vm = context.read<AdminOrderViewModel>();

      await vm.changeStatus(widget.order, selectedStatus);

      if (!mounted) return;

      if (vm.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(vm.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Order status updated to ${_statusText(selectedStatus)}',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isUpdating = false;
        });
      }
    }
  }

  bool _validStatus(String status) {
    return [
      'pending',
      'preparing',
      'out_for_delivery',
      'delivered',
      'cancelled',
    ].contains(status);
  }

  String _statusText(String status) {
    switch (status) {
      case 'preparing':
        return 'Preparing';

      case 'out_for_delivery':
        return 'Out for Delivery';

      case 'delivered':
        return 'Delivered';

      case 'cancelled':
        return 'Cancelled';

      default:
        return 'Pending';
    }
  }

  String _formatDate(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();

    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute';
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 10),
          Text('$title: ', style: const TextStyle(fontWeight: FontWeight.w600)),
          Expanded(child: Text(value)),
>>>>>>> origin/main
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
<<<<<<< HEAD
    final quantity = (item['quantity'] ?? item['qty'] ?? 1) as num;

    final price = (item['price'] ?? 0) as num;
=======
    final name = item['name'] ?? item['title'] ?? item['foodName'] ?? 'Item';

    final quantity = item['qty'] ?? item['quantity'] ?? 1;

    final price = item['price'] ?? item['totalPrice'] ?? 0;
>>>>>>> origin/main

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
<<<<<<< HEAD
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
=======
          Expanded(child: Text('$name × $quantity')),
          Text(
            'Rs. $price',
            style: const TextStyle(fontWeight: FontWeight.w600),
>>>>>>> origin/main
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
<<<<<<< HEAD
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
=======
    late String label;
    late Color color;
    late IconData icon;

    switch (status) {
      case 'preparing':
        label = 'Preparing';
        color = Colors.orange;
        icon = Icons.restaurant;

        break;

      case 'out_for_delivery':
        label = 'Out for Delivery';
        color = Colors.deepOrange;
        icon = Icons.delivery_dining;

        break;

      case 'delivered':
        label = 'Delivered';
        color = Colors.green;
        icon = Icons.check_circle;

        break;

      case 'cancelled':
        label = 'Cancelled';
        color = Colors.red;
        icon = Icons.cancel;

        break;

      default:
        label = 'Pending';
        color = Colors.blue;
        icon = Icons.access_time;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
>>>>>>> origin/main
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
<<<<<<< HEAD
          Icon(config.icon, size: 12, color: config.color),
          const SizedBox(width: 4),
          Text(
            config.label,
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: config.color,
=======
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
>>>>>>> origin/main
            ),
          ),
        ],
      ),
    );
  }
}
<<<<<<< HEAD

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
=======
>>>>>>> origin/main
