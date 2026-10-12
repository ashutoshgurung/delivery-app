<<<<<<< HEAD
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
=======
// /// Model returned by the backend's /khalti/initiate endpoint
// class PaymentInitiationModel {
//   final String pidx;
//   final String paymentUrl;
//   final String expiresAt;
//   final int expiresIn;

//   PaymentInitiationModel({
//     required this.pidx,
//     required this.paymentUrl,
//     required this.expiresAt,
//     required this.expiresIn,
//   });

//   factory PaymentInitiationModel.fromJson(Map<String, dynamic> json) {
//     return PaymentInitiationModel(
//       pidx: json['pidx'] as String,
//       paymentUrl: json['payment_url'] as String,
//       expiresAt: json['expires_at'] as String? ?? '',
//       expiresIn: json['expires_in'] as int? ?? 0,
//     );
//   }
// }

// /// Model returned by the backend's /khalti/verify (lookup) endpoint
// class PaymentVerificationModel {
//   final String pidx;
//   final String status; // Completed | Pending | Initiated | Refunded | Expired | User canceled
//   final int totalAmount;
//   final String transactionId;
//   final int fee;
//   final bool refunded;

//   PaymentVerificationModel({
//     required this.pidx,
//     required this.status,
//     required this.totalAmount,
//     required this.transactionId,
//     required this.fee,
//     required this.refunded,
//   });

//   bool get isCompleted => status == 'Completed';

//   factory PaymentVerificationModel.fromJson(Map<String, dynamic> json) {
//     return PaymentVerificationModel(
//       pidx: json['pidx'] as String? ?? '',
//       status: json['status'] as String? ?? 'Unknown',
//       totalAmount: json['total_amount'] as int? ?? 0,
//       transactionId: json['transaction_id'] as String? ?? '',
//       fee: json['fee'] as int? ?? 0,
//       refunded: json['refunded'] as bool? ?? false,
//     );
//   }
// }

// /// Simple model representing an order in your food app, passed into the
// /// payment flow so amounts/ids stay consistent between initiate & verify.
// class OrderPaymentRequest {
//   final String orderId;
//   final String orderName;
//   final int amountInPaisa; // Khalti requires amount in paisa (Rs * 100)
//   final String customerName;
//   final String customerEmail;
//   final String customerPhone;

//   OrderPaymentRequest({
//     required this.orderId,
//     required this.orderName,
//     required this.amountInPaisa,
//     required this.customerName,
//     required this.customerEmail,
//     required this.customerPhone,
//   });
// }

// enum PaymentStatus { idle, initiating, awaitingUser, verifying, success, failure }


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


class OrderPaymentRequest {
  final String orderId;
  final String orderName;
  final int amountInPaisa; 
>>>>>>> origin/main
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