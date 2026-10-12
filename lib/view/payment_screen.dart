<<<<<<< HEAD
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
=======
// // import 'package:flutter/material.dart';
// // import 'package:food_ordering_app/model/payment_model.dart';
// // import 'package:food_ordering_app/viewmodel/payment_view_model.dart';
// // import 'package:provider/provider.dart';
// // import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';

// // const String kKhaltiTestPublicKey = 'db4a37afc34b44b398edec542b31065f';

// // class PaymentScreen extends StatefulWidget {
// //   final OrderPaymentRequest order;

// //   const PaymentScreen({super.key, required this.order});

// //   @override
// //   State<PaymentScreen> createState() => _PaymentScreenState();
// // }

// // class _PaymentScreenState extends State<PaymentScreen> {
// //   Khalti? _khalti;

// //   Future<void> _payWithKhalti() async {
// //     final vm = context.read<PaymentViewModel>();

// //     final initiated = await vm.initiate(widget.order);
// //     if (!initiated || vm.pidx == null) {
// //       if (mounted) _showSnack(vm.errorMessage ?? 'Could not start payment');
// //       return;
// //     }

// //     final payConfig = KhaltiPayConfig(
// //       publicKey: kKhaltiTestPublicKey,
// //       pidx: vm.pidx!,
// //       environment: Environment.test,
// //       paymentUrl: vm.paymentUrl!, // switch to Environment.prod for release
// //     );

// //     _khalti = await Khalti.init(
// //       enableDebugging: true,
// //       payConfig: payConfig,
// //       onPaymentResult: (paymentResult, khalti) async {
// //         khalti.close(context);
// //         // Never trust the client-side result alone — verify on the server.
// //         final success = await context.read<PaymentViewModel>().verify();
// //         if (mounted) {
// //           _showSnack(
// //             success ? 'Payment successful!' : 'Payment could not be verified',
// //           );
// //         }
// //       },
// //       onMessage:
// //           (
// //             khalti, {
// //             description,
// //             statusCode,
// //             event,
// //             needsPaymentConfirmation,
// //           }) async {
// //             khalti.close(context);
// //             if (needsPaymentConfirmation == true) {
// //               // Edge case: SDK isn't sure of the result, verify anyway.
// //               await context.read<PaymentViewModel>().verify();
// //             } else if (mounted) {
// //               _showSnack(description?.toString() ?? 'Unknown message');
// //             }
// //           },
// //       onReturn: () => debugPrint('Returned from Khalti payment page'),
// //     );

// //     if (mounted) _khalti!.open(context);
// //   }

// //   void _showSnack(String message) {
// //     ScaffoldMessenger.of(
// //       context,
// //     ).showSnackBar(SnackBar(content: Text(message)));
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Consumer<PaymentViewModel>(
// //       builder: (context, vm, _) {
// //         return Scaffold(
// //           appBar: AppBar(title: const Text('Checkout')),
// //           body: Padding(
// //             padding: const EdgeInsets.all(24),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: [
// //                 Text(
// //                   widget.order.orderName,
// //                   style: Theme.of(context).textTheme.titleLarge,
// //                 ),
// //                 const SizedBox(height: 8),
// //                 Text(
// //                   'Rs. ${(widget.order.amountInPaisa / 100).toStringAsFixed(2)}',
// //                   style: Theme.of(context).textTheme.headlineSmall,
// //                 ),
// //                 const SizedBox(height: 32),
// //                 if (vm.isBusy)
// //                   const CircularProgressIndicator()
// //                 else
// //                   ElevatedButton.icon(
// //                     onPressed: _payWithKhalti,
// //                     icon: const Icon(Icons.payment),
// //                     label: const Text('Pay with Khalti'),
// //                   ),
// //                 if (vm.status == PaymentStatus.success) ...[
// //                   const SizedBox(height: 24),
// //                   const Icon(Icons.check_circle, color: Colors.green, size: 48),
// //                   const Text('Payment confirmed'),
// //                 ],
// //                 if (vm.status == PaymentStatus.failure &&
// //                     vm.errorMessage != null) ...[
// //                   const SizedBox(height: 24),
// //                   Text(
// //                     vm.errorMessage!,
// //                     style: const TextStyle(color: Colors.red),
// //                     textAlign: TextAlign.center,
// //                   ),
// //                 ],
// //               ],
// //             ),
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }


// import 'package:flutter/material.dart';
// import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';
// import 'package:food_ordering_app/model/payment_model.dart';

// const String kKhaltiTestPublicKey =
//     'db4a37afc34b44b398edec542b31065f';

// class PaymentScreen extends StatefulWidget {
//   final OrderPaymentRequest order;

//   const PaymentScreen({
//     super.key,
//     required this.order,
//   });

//   @override
//   State<PaymentScreen> createState() => _PaymentScreenState();
// }

// class _PaymentScreenState extends State<PaymentScreen> {
//   Khalti? _khalti;

//   Future<void> _openKhalti() async {
//     try {
//       final payConfig = KhaltiPayConfig(
//         publicKey: kKhaltiTestPublicKey,

//         // IMPORTANT:
//         // This requires a valid pidx from Khalti.
//         pidx: widget.order.orderId,

//         environment: Environment.test,

//         paymentUrl: 'https://test-pay.khalti.com',
//       );

//       _khalti = await Khalti.init(
//         enableDebugging: true,
//         payConfig: payConfig,

//         onPaymentResult: (paymentResult, khalti) {
//           khalti.close(context);

//           if (!mounted) return;

//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Payment completed'),
//             ),
//           );
//         },

//         onMessage: (
//           khalti, {
//           description,
//           statusCode,
//           event,
//           needsPaymentConfirmation,
//         }) {
//           debugPrint(
//             'Khalti message: $description',
//           );
//         },

//         onReturn: () {
//           debugPrint('Returned from Khalti');
//         },
//       );

//       if (!mounted) return;

//       _khalti?.open(context);
//     } catch (e) {
//       debugPrint('KHALTI ERROR: $e');

//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Khalti error: $e'),
//         ),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     _khalti?.close(context);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Khalti Payment'),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(24),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               const Icon(
//                 Icons.account_balance_wallet,
//                 size: 80,
//                 color: Colors.purple,
//               ),

//               const SizedBox(height: 24),

//               Text(
//                 widget.order.orderName,
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontSize: 20,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),

//               const SizedBox(height: 10),

//               Text(
//                 'Rs. ${(widget.order.amountInPaisa / 100).toStringAsFixed(2)}',
//                 style: const TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),

//               const SizedBox(height: 30),

//               SizedBox(
//                 width: double.infinity,
//                 height: 55,
//                 child: ElevatedButton.icon(
//                   onPressed: _openKhalti,
//                   icon: const Icon(Icons.payment),
//                   label: const Text(
//                     'Pay with Khalti',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

>>>>>>> origin/main
import 'package:flutter/material.dart';
import 'package:food_ordering_app/model/order_model.dart';
import 'package:food_ordering_app/model/payment_model.dart';
import 'package:food_ordering_app/viewmodel/payment_view_model.dart';
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';
import 'package:provider/provider.dart';

<<<<<<< HEAD
// ------------------------------------------------------------
// KHALTI TEST PUBLIC KEY
// ------------------------------------------------------------

const String kKhaltiTestPublicKey =
    'db4a37afc34b44b398edec542b31065f';
=======
const String kKhaltiTestPublicKey =
  '2ffa9735d42d4ac38dacff5803e8f57a';
>>>>>>> origin/main

class PaymentScreen extends StatefulWidget {
  final OrderPaymentRequest order;

<<<<<<< HEAD
  // This is the actual order that came from CheckoutScreen.
  final OrderModel orderModel;

  const PaymentScreen({
    super.key,
    required this.order,
    required this.orderModel,
=======
  const PaymentScreen({
    super.key,
    required this.order,
>>>>>>> origin/main
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  Khalti? _khalti;

  bool _orderProcessing = false;

  // ------------------------------------------------------------
  // KHALTI PAYMENT
  // ------------------------------------------------------------

  Future<void> _payWithKhalti() async {
    final vm = context.read<PaymentViewModel>();

<<<<<<< HEAD
    try {
      final initiated = await vm.initiate(widget.order);

      if (!initiated || vm.pidx == null) {
        if (mounted) {
          _showSnack(
            vm.errorMessage ?? 'Could not start payment',
          );
        }

        return;
      }

      final payConfig = KhaltiPayConfig(
        publicKey: kKhaltiTestPublicKey,
        pidx: vm.pidx!,
        environment: Environment.test,

        // Khalti test payment URL
        paymentUrl:
            'https://test-pay.khalti.com/?pidx=${vm.pidx!}',
      );

      _khalti = await Khalti.init(
        enableDebugging: true,
        payConfig: payConfig,

        // --------------------------------------------------------
        // PAYMENT RESULT
        // --------------------------------------------------------

        onPaymentResult: (
          paymentResult,
          khalti,
        ) async {
          debugPrint(
            'Khalti payment result: $paymentResult',
          );

          khalti.close(context);

          if (!mounted) return;

          // Verify payment and save order
          await _handleSuccessfulPayment();
        },

        // --------------------------------------------------------
        // KHALTI MESSAGE
        // --------------------------------------------------------

        onMessage: (
          khalti, {
          description,
          statusCode,
          event,
          needsPaymentConfirmation,
        }) async {
          debugPrint(
            'Khalti message: '
            'description=$description, '
            'statusCode=$statusCode, '
            'event=$event, '
            'needsPaymentConfirmation=$needsPaymentConfirmation',
          );

          if (needsPaymentConfirmation == true) {
            try {
              final success =
                  await context.read<PaymentViewModel>().verify();

              if (!mounted) return;

              khalti.close(context);

              if (success) {
                await _handleSuccessfulPayment();
              } else {
                _showSnack(
                  'Payment could not be verified.',
                );
              }
            } catch (e) {
              khalti.close(context);

              if (mounted) {
                _showSnack(
                  'Payment verification failed.',
                );
              }

              debugPrint(
                'Verification error: $e',
              );
            }
          } else {
            khalti.close(context);

            if (mounted) {
              _showSnack(
                description?.toString() ??
                    'Payment cancelled or failed.',
              );
            }
          }
        },

        // --------------------------------------------------------
        // RETURN
        // --------------------------------------------------------

        onReturn: () {
          debugPrint(
            'Returned from Khalti payment page',
          );
        },
      );

      if (!mounted) return;

      _khalti?.open(context);
    } catch (e) {
      debugPrint(
        'Khalti payment error: $e',
      );

      if (mounted) {
        _showSnack(
          'Could not start Khalti payment.',
        );
      }
    }
  }

  // ------------------------------------------------------------
  // HANDLE SUCCESSFUL PAYMENT
  // ------------------------------------------------------------

  Future<void> _handleSuccessfulPayment() async {
    if (_orderProcessing) return;

    _orderProcessing = true;

    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      _orderProcessing = false;

      if (mounted) {
        _showSnack(
          'User is not logged in',
        );
      }

=======
    final initiated = await vm.initiate(widget.order);

    if (!mounted) return;

    if (!initiated || vm.pidx == null || vm.paymentUrl == null) {
      _showSnack(
        vm.errorMessage ?? 'Could not start Khalti payment',
      );
>>>>>>> origin/main
      return;
    }

    try {
<<<<<<< HEAD
      final paymentVM = context.read<PaymentViewModel>();

      // Get verification result from PaymentViewModel
      final verification = paymentVM.verification;

      // ----------------------------------------------------------
      // CHECK PAYMENT VERIFICATION
      // ----------------------------------------------------------

      if (verification == null ||
          !verification.isCompleted) {
        _orderProcessing = false;

        if (mounted) {
          _showSnack(
            'Payment was not completed.',
          );
        }

        return;
      }

      // ----------------------------------------------------------
      // CREATE CENTRAL ORDER DOCUMENT
      // ----------------------------------------------------------

      final orderRef = FirebaseFirestore.instance
          .collection('orders')
          .doc(widget.orderModel.id);

      // Convert OrderModel to Map
      final orderData = widget.orderModel.toMap();

      // ----------------------------------------------------------
      // CUSTOMER INFORMATION
      // ----------------------------------------------------------

      orderData['userId'] = uid;

      // ----------------------------------------------------------
      // ORDER STATUS
      // ----------------------------------------------------------

      orderData['status'] = 'pending';

      // ----------------------------------------------------------
      // PAYMENT INFORMATION
      // ----------------------------------------------------------

      orderData['paymentStatus'] = 'paid';

      orderData['paymentMethod'] = 'Khalti';

      orderData['transactionId'] =
          verification.transactionId;

      // ----------------------------------------------------------
      // ORDER ITEMS
      // ----------------------------------------------------------

      final orderItems = widget.orderModel.items.map((item) {
        return {
          'name': item['name'] ?? '',
          'price': (item['price'] ?? 0).toDouble(),
          'quantity': item['quantity'] ?? 1,
          'image': item['image'] ?? '',
          'size': item['size'] ?? '',
        };
      }).toList();

      orderData['items'] = orderItems;

      // ----------------------------------------------------------
      // SAVE ORDER TO FIRESTORE
      // ----------------------------------------------------------

      await orderRef.set(orderData);

      debugPrint(
        'Order successfully saved: ${widget.orderModel.id}',
      );

      _orderProcessing = false;

      if (!mounted) return;

      _showSnack(
        'Order placed successfully!',
      );

      // ----------------------------------------------------------
      // RETURN TRUE TO CHECKOUT SCREEN
      // ----------------------------------------------------------

      Navigator.pop(context, true);
    } catch (e) {
      _orderProcessing = false;

      debugPrint(
        'Error saving order: $e',
      );

      if (mounted) {
        _showSnack(
          'Payment successful, but order could not be saved.',
        );
      }
=======
      final payConfig = KhaltiPayConfig(
        publicKey: kKhaltiTestPublicKey,
        pidx: vm.pidx!,
        environment: Environment.test,
        paymentUrl: vm.paymentUrl!,
      );

      _khalti = await Khalti.init(
        enableDebugging: true,
        payConfig: payConfig,

        onPaymentResult: (paymentResult, khalti) async {
          khalti.close(context);

          final success =
              await context.read<PaymentViewModel>().verify();

          if (!mounted) return;

          _showSnack(
            success
                ? 'Payment successful!'
                : 'Payment could not be verified',
          );
        },

        onMessage: (
          khalti, {
          description,
          statusCode,
          event,
          needsPaymentConfirmation,
        }) async {
          debugPrint(
            'Khalti message: $description',
          );

          if (needsPaymentConfirmation == true) {
            khalti.close(context);

            final success =
                await context.read<PaymentViewModel>().verify();

            if (!mounted) return;

            _showSnack(
              success
                  ? 'Payment successful!'
                  : 'Payment could not be verified',
            );
          } else {
            if (mounted) {
              _showSnack(
                description?.toString() ??
                    'Khalti payment cancelled',
              );
            }
          }
        },

        onReturn: () {
          debugPrint('Returned from Khalti');
        },
      );

      if (!mounted) return;

      _khalti?.open(context);
    } catch (e) {
      debugPrint('KHALTI ERROR: $e');

      if (!mounted) return;

      _showSnack('Khalti error: $e');
>>>>>>> origin/main
    }
  }

  // ------------------------------------------------------------
  // SNACKBAR
  // ------------------------------------------------------------

  void _showSnack(String message) {
<<<<<<< HEAD
    if (!mounted) return;

=======
>>>>>>> origin/main
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
<<<<<<< HEAD
=======
  }

  @override
  void dispose() {
    // Don't close using context here.
    // Khalti is already closed from callbacks.
    super.dispose();
>>>>>>> origin/main
  }

  // ------------------------------------------------------------
  // UI
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          appBar: AppBar(
<<<<<<< HEAD
            title: const Text('Checkout'),
          ),

=======
            title: const Text('Khalti Payment'),
          ),
>>>>>>> origin/main
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
<<<<<<< HEAD
                // ------------------------------------------------
                // ORDER NAME
                // ------------------------------------------------

                Text(
                  widget.order.orderName,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge,
                ),

                const SizedBox(height: 8),

                // ------------------------------------------------
                // AMOUNT
                // ------------------------------------------------

                Text(
                  'Rs. ${(widget.order.amountInPaisa / 100).toStringAsFixed(2)}',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall,
                ),

                const SizedBox(height: 32),

                // ------------------------------------------------
                // PAYMENT BUTTON / LOADING
                // ------------------------------------------------

                if (vm.isBusy || _orderProcessing)
                  const CircularProgressIndicator()
                else
                  ElevatedButton.icon(
                    onPressed: _payWithKhalti,
                    icon: const Icon(Icons.payment),
                    label: const Text(
                      'Pay with Khalti',
                    ),
                  ),

                // ------------------------------------------------
                // SUCCESS
                // ------------------------------------------------

                if (vm.status == PaymentStatus.success) ...[
                  const SizedBox(height: 24),

                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 48,
                  ),

                  const Text(
                    'Payment confirmed',
                  ),
                ],

                // ------------------------------------------------
                // FAILURE
                // ------------------------------------------------

                if (vm.status == PaymentStatus.failure &&
                    vm.errorMessage != null) ...[
                  const SizedBox(height: 24),

                  Text(
                    vm.errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
=======
                const Icon(
                  Icons.account_balance_wallet,
                  size: 80,
                  color: Colors.purple,
                ),

                const SizedBox(height: 24),

                Text(
                  widget.order.orderName,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  'Rs. ${(widget.order.amountInPaisa / 100).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: vm.isBusy
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : ElevatedButton.icon(
                          onPressed: _payWithKhalti,
                          icon: const Icon(Icons.payment),
                          label: const Text(
                            'Pay with Khalti',
                            style: TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                ),

                if (vm.status == PaymentStatus.success) ...[
                  const SizedBox(height: 20),
                  const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 45,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Payment successful!',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],

                if (vm.status == PaymentStatus.failure &&
                    vm.errorMessage != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    vm.errorMessage!,
>>>>>>> origin/main
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
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