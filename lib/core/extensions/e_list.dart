import 'dart:math';

extension EList<T> on List<T> {
  T? random() {
    return elementAtOrNull(Random().nextInt(length));
  }

  void addOrRemove(T item) {
    if (!remove(item)) {
      add(item);
    }
  }

  void addOrRemoveObject(bool Function(T) selector, T item) {
    final contains = any(selector);
    if (contains) {
      removeWhere(selector);
    } else {
      add(item);
    }
  }

  List<T> swapItems(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = removeAt(oldIndex);
    insert(newIndex, item);

    return this;
  }
}

extension ESet<T> on Set<T> {
  void addOrRemove(T item) {
    if (!remove(item)) {
      add(item);
    }
  }

  void addOrRemoveObject(bool Function(T) selector, T item) {
    final contains = any(selector);
    if (contains) {
      removeWhere(selector);
    } else {
      add(item);
    }
  }
}
