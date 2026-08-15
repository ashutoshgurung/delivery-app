import 'dart:convert';
import 'package:food_ordering_app/model/payment_model.dart';
import 'package:http/http.dart' as http;


class KhaltiService {
  final String baseUrl;
  final http.Client _client;

  KhaltiService({
    required this.baseUrl, 
    http.Client? client,
  }) : _client = client ?? http.Client();

  Future<PaymentInitiationModel> initiatePayment(
    OrderPaymentRequest request,
  ) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/khalti/initiate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'amount': request.amountInPaisa,
        'purchase_order_id': request.orderId,
        'purchase_order_name': request.orderName,
        'customer_info': {
          'name': request.customerName,
          'email': request.customerEmail,
          'phone': request.customerPhone,
        },
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return PaymentInitiationModel.fromJson(jsonDecode(response.body));
    }
    throw KhaltiException(
      'Failed to initiate payment: ${response.statusCode} ${response.body}',
    );
  }

  Future<PaymentVerificationModel> verifyPayment(String pidx) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/khalti/verify'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'pidx': pidx}),
    );

    if (response.statusCode == 200) {
      return PaymentVerificationModel.fromJson(jsonDecode(response.body));
    }
    throw KhaltiException(
      'Failed to verify payment: ${response.statusCode} ${response.body}',
    );
  }
}

class KhaltiException implements Exception {
  final String message;
  KhaltiException(this.message);

  @override
  String toString() => 'KhaltiException: $message';
}