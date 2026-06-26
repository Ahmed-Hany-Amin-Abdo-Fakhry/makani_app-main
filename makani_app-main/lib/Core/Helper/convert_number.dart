/// Converts Arabic-Indic digits (٠–٩) to English digits (0–9).
/// Use when parsing OTP or numeric input in Arabic locale.
String convertToEnglishDigits(String value) {
  const arabicDigits = '٠١٢٣٤٥٦٧٨٩';
  const englishDigits = '0123456789';
  String result = value;
  for (int i = 0; i < arabicDigits.length; i++) {
    result = result.replaceAll(arabicDigits[i], englishDigits[i]);
  }
  return result;
}
