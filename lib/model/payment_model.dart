enum PaymentStatus {
  idle,
  initiating,
  awaitingUser,
  verifying,
  success,
  failure,
}

/// Everything needed to start a Khalti payment for one order.
/// amountInPaisa: Khalti works in paisa, so Rs. 100 = 10000.
class OrderPaymentRequest {
  final String orderId;
  final String orderName;
  final int amountInPaisa;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String returnUrl;
  final String websiteUrl;

  const OrderPaymentRequest({
    required this.orderId,
    required this.orderName,
    required this.amountInPaisa,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.returnUrl,
    required this.websiteUrl,
  });

  Map<String, dynamic> toJson() => {
    'return_url': returnUrl,
    'website_url': websiteUrl,
    'amount': amountInPaisa,
    'purchase_order_id': orderId,
    'purchase_order_name': orderName,
    'customer_info': {
      'name': customerName,
      'email': customerEmail,
      'phone': customerPhone,
    },
  };
}

/// What your backend returns right after calling Khalti's "initiate" API.
class PidxResult {
  final String pidx;
  final String? paymentUrl;
  final String? expiresAt;

  const PidxResult({required this.pidx, this.paymentUrl, this.expiresAt});

  factory PidxResult.fromJson(Map<String, dynamic> json) {
    return PidxResult(
      pidx: json['pidx'] as String,
      paymentUrl: json['payment_url'] as String?,
      expiresAt: json['expires_at']?.toString(),
    );
  }
}

/// What your backend returns after calling Khalti's "lookup"/verify API.
class PaymentVerificationModel {
  final String pidx;
  final String status; // Completed, Pending, Expired, User canceled, Refunded
  final int? totalAmount;
  final String? transactionId;
  final String? fee;
  final bool refunded;

  const PaymentVerificationModel({
    required this.pidx,
    required this.status,
    this.totalAmount,
    this.transactionId,
    this.fee,
    this.refunded = false,
  });

  bool get isCompleted => status == 'Completed';

  factory PaymentVerificationModel.fromJson(Map<String, dynamic> json) {
    return PaymentVerificationModel(
      pidx: json['pidx'] as String,
      status: json['status'] as String,
      totalAmount: json['total_amount'] as int?,
      transactionId: json['transaction_id']?.toString(),
      fee: json['fee']?.toString(),
      refunded: json['refunded'] as bool? ?? false,
    );
  }
}