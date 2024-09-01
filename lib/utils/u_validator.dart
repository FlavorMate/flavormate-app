abstract class UValidator {
  static bool isEmpty(String? input) {
    return (input == null || input.isEmpty);
  }

  static bool isMail(String input) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    return emailRegex.hasMatch(input);
  }

  static bool isEqual(String input, String compare) {
    return input == compare;
  }

  static bool isSecure(String input) {
    final passwordRegex =
        RegExp(r'(?=.*[A-Z])(?=.*[!@#.$&*-])(?=.*[0-9])(?=.*[a-z])');

    return passwordRegex.hasMatch(input);
  }
}
