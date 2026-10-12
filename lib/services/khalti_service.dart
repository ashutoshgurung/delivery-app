import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:food_ordering_app/model/payment_model.dart';

<<<<<<< HEAD
/// ⚠️ DEV/TEST-ONLY VERSION ⚠️
/// This calls Khalti's epayment API DIRECTLY from the app using your
/// SECRET key. That means the secret key ships inside your APK/IPA —
/// anyone can decompile the app and extract it, then create fake
/// payment sessions billed to your merchant account.
///
/// This is fine while you're developing and testing locally.
/// Before you publish the app, move `initiatePayment` and
/// `verifyPayment` into a small backend (even a single serverless
/// function) that holds the secret key, and have this class call
/// YOUR backend instead — see the previous version of this file for
/// that shape.
=======

>>>>>>> origin/main
class KhaltiService {
  KhaltiService({required this.secretKey, this.useTestEnvironment = true, http.Client? client})
    : _client = client ?? http.Client();

  /// Your Khalti merchant SECRET key (test or live).
  /// e.g. 'test_secret_key_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx'
  final String secretKey;

  /// true -> dev.khalti.com (sandbox), false -> khalti.com (live/production)
  final bool useTestEnvironment;

  final http.Client _client;

<<<<<<< HEAD
  String get _baseUrl => useTestEnvironment
      ? 'https://dev.khalti.com/api/v2/epayment'
      : 'https://khalti.com/api/v2/epayment';
=======
  KhaltiService({
    required this.baseUrl, 
    http.Client? client,
  }) : _client = client ?? http.Client();
>>>>>>> origin/main

  Map<String, String> get _headers => {
    'Authorization': 'key $secretKey',
    'Content-Type': 'application/json',
  };

  Future<PidxResult> initiatePayment(OrderPaymentRequest request) async {
    final uri = Uri.parse('$_baseUrl/initiate/');

    final response = await _client
        .post(uri, headers: _headers, body: jsonEncode(request.toJson()))
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        'Could not initiate payment (${response.statusCode}): ${response.body}',
      );
    }
    debugPrint('KHALTI STATUS: ${response.statusCode}');
    debugPrint('KHALTI RESPONSE: ${response.body}');

final data = jsonDecode(response.body) as Map<String, dynamic>;
return PidxResult.fromJson(data);

    // final data = jsonDecode(response.body) as Map<String, dynamic>;
    // return PidxResult.fromJson(data);
  }

  Future<PaymentVerificationModel> verifyPayment(String pidx) async {
    final uri = Uri.parse('$_baseUrl/lookup/');

    final response = await _client
        .post(uri, headers: _headers, body: jsonEncode({'pidx': pidx}))
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw Exception(
        'Could not verify payment (${response.statusCode}): ${response.body}',
      );
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return PaymentVerificationModel.fromJson(data);
  }
}