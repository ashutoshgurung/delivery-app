/// Model returned by the backend's /khalti/initiate endpoint
class PaymentInitiationModel {
  final String pidx;
  final String paymentUrl;
  final String expiresAt;
  final int expiresIn;

  PaymentInitiationModel({
    required this.pidx,
    required this.paymentUrl,
    required this.expiresAt,
    required this.expiresIn,
  });

  factory PaymentInitiationModel.fromJson(Map<String, dynamic> json) {
    return PaymentInitiationModel(
      pidx: json['pidx'] as String,
      paymentUrl: json['payment_url'] as String,
      expiresAt: json['expires_at'] as String? ?? '',
      expiresIn: json['expires_in'] as int? ?? 0,
    );
  }
}

/// Model returned by the backend's /khalti/verify (lookup) endpoint
class PaymentVerificationModel {
  final String pidx;
  final String status; // Completed | Pending | Initiated | Refunded | Expired | User canceled
  final int totalAmount;
  final String transactionId;
  final int fee;
  final bool refunded;

  PaymentVerificationModel({
    required this.pidx,
    required this.status,
    required this.totalAmount,
    required this.transactionId,
    required this.fee,
    required this.refunded,
  });

  bool get isCompleted => status == 'Completed';

  factory PaymentVerificationModel.fromJson(Map<String, dynamic> json) {
    return PaymentVerificationModel(
      pidx: json['pidx'] as String? ?? '',
      status: json['status'] as String? ?? 'Unknown',
      totalAmount: json['total_amount'] as int? ?? 0,
      transactionId: json['transaction_id'] as String? ?? '',
      fee: json['fee'] as int? ?? 0,
      refunded: json['refunded'] as bool? ?? false,
    );
  }
}

/// Simple model representing an order in your food app, passed into the
/// payment flow so amounts/ids stay consistent between initiate & verify.
class OrderPaymentRequest {
  final String orderId;
  final String orderName;
  final int amountInPaisa; // Khalti requires amount in paisa (Rs * 100)
  final String customerName;
  final String customerEmail;
  final String customerPhone;

  OrderPaymentRequest({
    required this.orderId,
    required this.orderName,
    required this.amountInPaisa,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
  });
}

enum PaymentStatus { idle, initiating, awaitingUser, verifying, success, failure }