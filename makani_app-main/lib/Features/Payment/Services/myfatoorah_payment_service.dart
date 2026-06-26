import 'package:dio/dio.dart';
import 'package:makani_app/Core/Config/myfatoorah_config.dart';

class MyFatoorahPaymentException implements Exception {
  MyFatoorahPaymentException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Creates MyFatoorah test invoices via SendPayment and returns the hosted URL.
class MyFatoorahPaymentService {
  MyFatoorahPaymentService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Future<String> createTestInvoiceUrl({
    required String customerName,
    double invoiceValue = MyFatoorahConfig.testInvoiceValue,
  }) async {
    if (!MyFatoorahConfig.isConfigured) {
      throw MyFatoorahPaymentException('MyFatoorah API key is not configured.');
    }

    final response = await _dio.post<Map<String, dynamic>>(
      '${MyFatoorahConfig.apiBaseUrl}/v2/SendPayment',
      options: Options(
        headers: {
          'Authorization': 'Bearer ${MyFatoorahConfig.apiKey}',
          'Content-Type': 'application/json',
        },
      ),
      data: {
        'InvoiceValue': invoiceValue,
        'CustomerName': customerName,
        'NotificationOption': 'LNK',
        'CallBackUrl': MyFatoorahConfig.callbackUrl,
        'ErrorUrl': MyFatoorahConfig.errorUrl,
      },
    );

    final body = response.data;
    if (body == null) {
      throw MyFatoorahPaymentException('Empty response from MyFatoorah.');
    }

    final isSuccess = body['IsSuccess'] == true;
    if (!isSuccess) {
      final message = body['Message'] as String? ?? 'Failed to create invoice.';
      throw MyFatoorahPaymentException(message);
    }

    final data = body['Data'] as Map<String, dynamic>?;
    final invoiceUrl = data?['InvoiceURL'] as String?;
    if (invoiceUrl == null || invoiceUrl.isEmpty) {
      throw MyFatoorahPaymentException('Invoice URL missing in MyFatoorah response.');
    }

    return invoiceUrl;
  }
}
