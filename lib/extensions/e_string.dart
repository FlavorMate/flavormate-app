extension EString on String {
  /// Shortens the current string to a specified length.
  ///
  /// This function truncates the string to the given [length]. If the string
  /// contains newline characters, it will truncate at the first newline and
  /// recursively shorten the resulting substring. Once the string is of the
  /// desired length, an ellipsis (`...`) is appended if it was shortened
  /// as part of a recursive call or if it has been truncated.
  ///
  /// - [length]: The maximum length of the shortened string. Defaults to 48.
  /// - [deep]: The recursion depth used to track when to append
  ///   the ellipsis. Defaults to 0.
  ///
  /// Returns the shortened string with an ellipsis appended if necessary.
  ///
  /// Example usage:
  /// ```
  /// String text = "This is a long string that will be shortened.";
  /// String shortText = text.shorten(length: 20);
  /// print(shortText); // Output: "This is a long..."
  /// ```
  String shorten({int length = 48, int deep = 0}) {
    final newLine = indexOf(RegExp(r'[\r\n]'));

    if (newLine >= 0) {
      return substring(0, newLine).shorten(deep: deep + 1);
    }

    if (this.length <= length && deep != 0) {
      return '$this...';
    } else if (this.length <= length) {
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
