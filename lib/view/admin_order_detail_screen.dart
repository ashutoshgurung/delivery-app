// import 'package:flutter/material.dart';
// import 'package:food_ordering_app/model/order_model.dart';
// import 'package:food_ordering_app/viewmodel/admin_view_model.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:provider/provider.dart';

// const List<String> kAdminOrderStatuses = ['pending', 'preparing', 'delivered'];

// class AdminOrderDetailScreen extends StatelessWidget {
//   final OrderModel order;

//   const AdminOrderDetailScreen({super.key, required this.order});

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
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6F6F6),
//       appBar: AppBar(
//         backgroundColor: const Color(0xFFCC0000),
//         foregroundColor: Colors.white,
//         title: Center(
//           child: Text(
//             'Order #${order.id.length > 8 ? order.id.substring(0, 8) : order.id}',
//             style: const TextStyle(fontWeight: FontWeight.bold),
//           ),
//         ),
//       ),
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           _card(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       order.customerEmail ?? 'Guest customer',
//                       style: GoogleFonts.poppins(
//                         fontWeight: FontWeight.w800,
//                         fontSize: 16,
//                       ),
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 10,
//                         vertical: 4,
//                       ),
//                       decoration: BoxDecoration(
//                         color: _statusColor(order.status).withOpacity(0.12),
//                         borderRadius: BorderRadius.circular(20),
//                       ),
//                       child: Text(
//                         order.status,
//                         style: TextStyle(
//                           color: _statusColor(order.status),
//                           fontSize: 12,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   DateFormat('MMM d, yyyy • h:mm a').format(order.createdAt),
//                   style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   order.restaurantName,
//                   style: GoogleFonts.poppins(color: Colors.grey, fontSize: 12),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 14),

//           _sectionLabel('Delivery'),
//           _card(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     const Icon(Icons.location_on_outlined,
//                         size: 18, color: Color(0xFFCC0000)),
//                     const SizedBox(width: 8),
//                     Expanded(
//                       child: Text(
//                         order.address ?? 'No address recorded',
//                         style: GoogleFonts.poppins(fontSize: 13),
//                       ),
//                     ),
//                   ],
//                 ),
//                 if (order.lat != null && order.lng != null) ...[
//                   const SizedBox(height: 6),
//                   Text(
//                     '${order.lat!.toStringAsFixed(5)}, ${order.lng!.toStringAsFixed(5)}',
//                     style: GoogleFonts.poppins(
//                         fontSize: 11, color: Colors.grey),
//                   ),
//                 ],
//                 if (order.paymentMethod != null) ...[
//                   const SizedBox(height: 10),
//                   Row(
//                     children: [
//                       const Icon(Icons.payment_outlined,
//                           size: 18, color: Color(0xFFCC0000)),
//                       const SizedBox(width: 8),
//                       Text(
//                         order.paymentMethod!,
//                         style: GoogleFonts.poppins(fontSize: 13),
//                       ),
//                     ],
//                   ),
//                 ],
//               ],
//             ),
//           ),

//           const SizedBox(height: 14),

//           _sectionLabel('Items'),
//           _card(
//             child: Column(
//               children: order.items.map((item) {
//                 final qty = item['quantity'] ?? 1;
//                 final price = item['price'] ?? 0;
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 6),
//                   child: Row(
//                     children: [
//                       Expanded(
//                         child: Text(
//                           '${item['name'] ?? 'Item'}',
//                           style: GoogleFonts.poppins(fontSize: 14),
//                         ),
//                       ),
//                       Text('x$qty',
//                           style: GoogleFonts.poppins(
//                               fontSize: 13, color: Colors.grey)),
//                       const SizedBox(width: 12),
//                       Text(
//                         'Rs. ${price * qty}',
//                         style: GoogleFonts.poppins(
//                             fontSize: 13, fontWeight: FontWeight.w700),
//                       ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),

//           const SizedBox(height: 14),

//           _card(
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Total',
//                   style: GoogleFonts.poppins(
//                       fontSize: 15, fontWeight: FontWeight.w700),
//                 ),
//                 Text(
//                   'Rs. ${order.totalPrice}',
//                   style: GoogleFonts.poppins(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w800,
//                     color: const Color(0xFFCC0000),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           const SizedBox(height: 14),

//           _sectionLabel('Update Status'),
//           _card(
//             child: Row(
//               children: kAdminOrderStatuses.map((s) {
//                 final selected = order.status == s;
//                 return Expanded(
//                   child: GestureDetector(
//                     onTap: selected
//                         ? null
//                         : () => context
//                             .read<AdminViewModel>()
//                             .updateOrderStatus(order.id, s),
//                     child: Container(
//                       margin: const EdgeInsets.symmetric(horizontal: 4),
//                       padding: const EdgeInsets.symmetric(vertical: 12),
//                       decoration: BoxDecoration(
//                         color: selected
//                             ? const Color(0xFFCC0000)
//                             : const Color(0xFFF6F6F6),
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       child: Center(
//                         child: Text(
//                           s,
//                           style: GoogleFonts.poppins(
//                             fontSize: 12,
//                             fontWeight: FontWeight.w700,
//                             color: selected ? Colors.white : Colors.black87,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               }).toList(),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _sectionLabel(String text) => Padding(
//         padding: const EdgeInsets.only(bottom: 8, left: 4),
//         child: Text(
//           text,
//           style: GoogleFonts.poppins(
//             fontSize: 12,
//             fontWeight: FontWeight.w700,
//             color: Colors.grey.shade600,
//             letterSpacing: 0.5,
//           ),
//         ),
//       );

//   Widget _card({required Widget child}) => Container(
//         width: double.infinity,
//         margin: const EdgeInsets.only(bottom: 4),
//         padding: const EdgeInsets.all(16),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: child,
//       );
// }

import 'package:flutter/material.dart';
import 'package:food_ordering_app/viewmodel/admin_view_model.dart';
import 'package:provider/provider.dart';

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() =>
      _AdminOrderScreenState();
}

class _AdminOrderScreenState
    extends State<AdminOrderScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context.read<AdminViewModel>().startOrdersListener();
    });
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdminViewModel>();

    if (vm.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (vm.errorMessage != null) {
      return Center(
        child: Text(vm.errorMessage!),
      );
    }

    if (vm.orders.isEmpty) {
      return const Center(
        child: Text('No orders found'),
      );
    }

    return ListView.builder(
      itemCount: vm.orders.length,
      itemBuilder: (context, index) {
        final order = vm.orders[index];

        return Card(
          child: ListTile(
            title: Text(order.restaurantName),

            subtitle: Text(
              'Rs. ${order.totalPrice}\n'
              'Status: ${order.status}',
            ),

            trailing: DropdownButton<String>(
              value: order.status,

              items: const [
                DropdownMenuItem(
                  value: 'Pending',
                  child: Text('Pending'),
                ),
                DropdownMenuItem(
                  value: 'Confirmed',
                  child: Text('Confirmed'),
                ),
                DropdownMenuItem(
                  value: 'Preparing',
                  child: Text('Preparing'),
                ),
                DropdownMenuItem(
                  value: 'Out for Delivery',
                  child: Text('Out for Delivery'),
                ),
                DropdownMenuItem(
                  value: 'Delivered',
                  child: Text('Delivered'),
                ),
                DropdownMenuItem(
                  value: 'Cancelled',
                  child: Text('Cancelled'),
                ),
              ],

              onChanged: (value) {
                if (value == null) return;

                context
                    .read<AdminViewModel>()
                    .updateOrderStatus(
                      order.id,
                      value,
                    );
              },
            ),
          ),
        );
      },
    );
  }
}