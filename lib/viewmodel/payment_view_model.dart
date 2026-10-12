import 'package:flutter/foundation.dart';
import 'package:food_ordering_app/model/payment_model.dart';
import 'package:food_ordering_app/services/khalti_service.dart';

class PaymentViewModel extends ChangeNotifier {
  final KhaltiService _khaltiService;

  PaymentViewModel(this._khaltiService);

  PaymentStatus status = PaymentStatus.idle;
  String? pidx;
  String? paymentUrl;
  String? errorMessage;
  PaymentVerificationModel? verification;

  bool get isBusy =>
      status == PaymentStatus.initiating || status == PaymentStatus.verifying;

 
  Future<bool> initiate(OrderPaymentRequest request) async {
    status = PaymentStatus.initiating;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _khaltiService.initiatePayment(request);
      pidx = result.pidx;
      paymentUrl = result.paymentUrl;
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
    paymentUrl = null;
    errorMessage = null;
    verification = null;
    notifyListeners();
  }
}