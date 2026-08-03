import 'package:flutter/foundation.dart';
import 'package:food_ordering_app/model/payment_model.dart';
import '../services/khalti_service.dart';

class PaymentViewModel extends ChangeNotifier {
  final KhaltiService _khaltiService;

  PaymentViewModel(this._khaltiService);

  PaymentStatus status = PaymentStatus.idle;
  String? pidx;
  String? errorMessage;
  PaymentVerificationModel? verification;

  bool get isBusy =>
      status == PaymentStatus.initiating || status == PaymentStatus.verifying;

  /// Step 1: ask your backend to create a pidx for this order.
  /// Call this right before launching the Khalti SDK.
  Future<bool> initiate(OrderPaymentRequest request) async {
    status = PaymentStatus.initiating;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _khaltiService.initiatePayment(request);
      pidx = result.pidx;
      status = PaymentStatus.awaitingUser;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      status = PaymentStatus.failure;
      notifyListeners();
      return false;
    }
  }

  /// Step 2: after the Khalti SDK returns a result, ALWAYS verify
  /// server-side before marking the order as paid in your app/database.
  Future<bool> verify() async {
    if (pidx == null) {
      errorMessage = 'No pidx to verify';
      status = PaymentStatus.failure;
      notifyListeners();
      return false;
    }

    status = PaymentStatus.verifying;
    notifyListeners();

    try {
      final result = await _khaltiService.verifyPayment(pidx!);
      verification = result;
      status = result.isCompleted
          ? PaymentStatus.success
          : PaymentStatus.failure;
      if (!result.isCompleted) {
        errorMessage = 'Payment not completed: ${result.status}';
      }
      notifyListeners();
      return result.isCompleted;
    } catch (e) {
      errorMessage = e.toString();
      status = PaymentStatus.failure;
      notifyListeners();
      return false;
    }
  }

  void reset() {
    status = PaymentStatus.idle;
    pidx = null;
    errorMessage = null;
    verification = null;
    notifyListeners();
  }
}
