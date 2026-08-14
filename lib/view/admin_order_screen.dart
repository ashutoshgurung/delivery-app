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
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildBody(context, vm),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AdminOrderViewModel vm,
  ) {
    if (vm.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (vm.errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            vm.errorMessage!,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (vm.orders.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 70,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No orders yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
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

          return _OrderCard(
            order: order,
          );
        },
      ),
    );
  }
}

// ================================================================
// ORDER CARD
// ================================================================

class _OrderCard extends StatefulWidget {
  final OrderModel order;

  const _OrderCard({
    required this.order,
  });

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
            // ======================================================
            // HEADER
            // ======================================================

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
                _StatusBadge(
                  status: widget.order.status,
                ),
              ],
            ),

            const SizedBox(height: 12),

            const Divider(),

            const SizedBox(height: 10),

            // ======================================================
            // CUSTOMER
            // ======================================================

            if (widget.order.customerName != null &&
                widget.order.customerName!.isNotEmpty)
              _InfoRow(
                icon: Icons.person_outline,
                title: 'Customer',
                value: widget.order.customerName!,
              ),

            // ======================================================
            // EMAIL
            // ======================================================

            if (widget.order.customerEmail != null &&
                widget.order.customerEmail!.isNotEmpty)
              _InfoRow(
                icon: Icons.email_outlined,
                title: 'Email',
                value: widget.order.customerEmail!,
              ),

            // ======================================================
            // RESTAURANT
            // ======================================================

            _InfoRow(
              icon: Icons.restaurant_outlined,
              title: 'Restaurant',
              value: widget.order.restaurantName,
            ),

            // ======================================================
            // TOTAL
            // ======================================================

            _InfoRow(
              icon: Icons.currency_rupee,
              title: 'Total',
              value: 'Rs. ${widget.order.totalPrice}',
            ),

            // ======================================================
            // ADDRESS
            // ======================================================

            if (widget.order.address != null &&
                widget.order.address!.isNotEmpty)
              _InfoRow(
                icon: Icons.location_on_outlined,
                title: 'Address',
                value: widget.order.address!,
              ),

            // ======================================================
            // DATE
            // ======================================================

            _InfoRow(
              icon: Icons.access_time,
              title: 'Ordered',
              value: _formatDate(widget.order.createdAt),
            ),

            const SizedBox(height: 12),

            // ======================================================
            // ITEMS
            // ======================================================

            const Text(
              'Items',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 8),

            ...widget.order.items.map(
              (item) => _ItemRow(
                item: item,
              ),
            ),

            const SizedBox(height: 16),

            // ======================================================
            // SELECT STATUS
            // ======================================================

            DropdownButtonFormField<String>(
              value: selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Change Order Status',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: 'pending',
                  child: Text('Pending'),
                ),
                DropdownMenuItem(
                  value: 'preparing',
                  child: Text('Preparing'),
                ),
                DropdownMenuItem(
                  value: 'out_for_delivery',
                  child: Text('Out for Delivery'),
                ),
                DropdownMenuItem(
                  value: 'delivered',
                  child: Text('Delivered'),
                ),
                DropdownMenuItem(
                  value: 'cancelled',
                  child: Text('Cancelled'),
                ),
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

            // ======================================================
            // UPDATE BUTTON
            // ======================================================

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
                onPressed: isUpdating ||
                        selectedStatus == widget.order.status
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
          ],
        ),
      ),
    );
  }

  // ==============================================================
  // UPDATE STATUS
  // ==============================================================

  Future<void> _updateStatus() async {
    setState(() {
      isUpdating = true;
    });

    try {
      final vm = context.read<AdminOrderViewModel>();

      await vm.changeStatus(
        widget.order,
        selectedStatus,
      );

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

// ================================================================
// INFO ROW
// ================================================================

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
          Icon(
            icon,
            size: 20,
          ),
          const SizedBox(width: 10),
          Text(
            '$title: ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// ITEM ROW
// ================================================================

class _ItemRow extends StatelessWidget {
  final Map<String, dynamic> item;

  const _ItemRow({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final name =
        item['name'] ??
        item['title'] ??
        item['foodName'] ??
        'Item';

    final quantity =
        item['qty'] ??
        item['quantity'] ??
        1;

    final price =
        item['price'] ??
        item['totalPrice'] ??
        0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '$name × $quantity',
            ),
          ),
          Text(
            'Rs. $price',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// ================================================================
// STATUS BADGE
// ================================================================

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
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
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}