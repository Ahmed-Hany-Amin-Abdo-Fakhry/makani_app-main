/// MyFatoorah sandbox configuration.
abstract final class MyFatoorahConfig {
  static const String apiBaseUrl = 'https://apitest.myfatoorah.com';

  /// MyFatoorah sandbox API key (KWD test environment).
  static const String apiKey =
      'SK_KWT_vVZlnnAqu8jRByOWaRPNId4ShzEDNt256dvnjebuyzo52dXjAfRx2ixW5umjWSUx';

  /// Intercepted in-app after payment completes (not a real hosted page).
  static const String callbackUrl = 'https://makani.app/payment/callback';

  static const String errorUrl = 'https://makani.app/payment/error';

  static const double testInvoiceValue = 1.0;

  static bool get isConfigured => apiKey.isNotEmpty;
}
