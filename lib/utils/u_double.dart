abstract final class UDouble {
  static double? tryParsePositive(String value) {
    final parsed = double.tryParse(value);

    if (parsed == null || parsed <= 0) {
      return null;
    } else {
      return parsed;
    }
  }

  static bool isPositive(double? value) {
    return value != null && value > 0;
  }
}
