extension EString on String {
  String shorten({int length = 48}) {
    if (this.length <= length) {
      return this;
    } else {
      var spaceAtIndex = indexOf(RegExp(r'\s'), length);
      if (spaceAtIndex < 0 || spaceAtIndex >= length + 8) {
        return '${substring(0, length)}...';
      }
      return '${substring(0, spaceAtIndex)}...';
    }
  }

  static bool isEmpty(String? input) {
    return input?.trim().isEmpty ?? true;
  }

  static bool isNotEmpty(String? input) {
    return !isEmpty(input);
  }

  static String? trimToNull(String? input) {
    if (isEmpty(input)) return null;
    return input!.trim();
  }

  bool containsIgnoreCase(String value) {
    return toLowerCase().contains(value.toLowerCase());
  }

  int compareToIgnoreCase(String value) {
    return toLowerCase().compareTo(value.toLowerCase());
  }
}
