abstract final class UInt {
  static int? tryParsePositive(String value) {
    final parsed = int.tryParse(value);

    if (parsed == null || parsed <= 0) {
      return null;
    } else {
      return parsed;
    }
  }

  static bool isPositive(int? value) {
    return value != null && value > 0;
  }
}
