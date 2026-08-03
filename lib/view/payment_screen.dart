import 'package:flutter/material.dart';
import 'package:food_ordering_app/model/payment_model.dart';
import 'package:food_ordering_app/viewmodel/payment_view_model.dart';
import 'package:provider/provider.dart';
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';

// import '../models/payment_model.dart';
// import '../viewmodels/payment_viewmodel.dart';

/// Replace with your own value or load from config/env.
const String kKhaltiTestPublicKey = 'db4a37afc34b44b398edec542b31065f';

class PaymentScreen extends StatefulWidget {
  final OrderPaymentRequest order;

  const PaymentScreen({super.key, required this.order});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Khalti? _khalti;

  Future<void> _payWithKhalti() async {
    final vm = context.read<PaymentViewModel>();

    final initiated = await vm.initiate(widget.order);
    if (!initiated || vm.pidx == null) {
      if (mounted) _showSnack(vm.errorMessage ?? 'Could not start payment');
      return;
    }

    final payConfig = KhaltiPayConfig(
      publicKey: kKhaltiTestPublicKey,
      pidx: vm.pidx!,
      environment: Environment.test, paymentUrl: '', // switch to Environment.prod for release
    );

    _khalti = await Khalti.init(
      enableDebugging: true,
      payConfig: payConfig,
      onPaymentResult: (paymentResult, khalti) async {
        khalti.close(context);
        // Never trust the client-side result alone — verify on the server.
        final success = await context.read<PaymentViewModel>().verify();
        if (mounted) {
          _showSnack(success ? 'Payment successful!' : 'Payment could not be verified');
        }
      },
      onMessage: (
        khalti, {
        description,
        statusCode,
        event,
        needsPaymentConfirmation,
      }) async {
        khalti.close(context);
        if (needsPaymentConfirmation == true) {
          // Edge case: SDK isn't sure of the result, verify anyway.
          await context.read<PaymentViewModel>().verify();
        } else if (mounted) {
          _showSnack(description?.toString() ?? 'Unknown message');
        }
      },
      onReturn: () => debugPrint('Returned from Khalti payment page'),
    );

    if (mounted) _khalti!.open(context);
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Checkout')),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.order.orderName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Rs. ${(widget.order.amountInPaisa / 100).toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 32),
                if (vm.isBusy)
                  const CircularProgressIndicator()
                else
                  ElevatedButton.icon(
                    onPressed: _payWithKhalti,
                    icon: const Icon(Icons.payment),
                    label: const Text('Pay with Khalti'),
                  ),
                if (vm.status == PaymentStatus.success) ...[
                  const SizedBox(height: 24),
                  const Icon(Icons.check_circle, color: Colors.green, size: 48),
                  const Text('Payment confirmed'),
                ],
                if (vm.status == PaymentStatus.failure && vm.errorMessage != null) ...[
                  const SizedBox(height: 24),
                  Text(
                    vm.errorMessage!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}