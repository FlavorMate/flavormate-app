import 'dart:math';

extension EList<T> on List<T> {
  T? random() {
    return elementAtOrNull(Random().nextInt(length));
  }
}
