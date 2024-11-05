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

  static double? add(double? a, double? b) {
    final sum = (a ?? 0) + (b ?? 0);
    return isPositive(sum) ? sum : null;
  }

  static double? multiply(double? a, double? b) {
    final sum = (a ?? 0) * (b ?? 0);
    return isPositive(sum) ? sum : null;
  }
}
