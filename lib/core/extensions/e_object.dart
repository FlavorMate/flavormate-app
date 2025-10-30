extension EObject<T> on T {
  /// Simulates Kotlin's `also`: runs [block] and returns the object.
  T also(void Function(T it) block) {
    block(this);
    return this;
  }

  /// Simulates Kotlin's `let`: runs [block] and returns the result.
  R let<R>(R Function(T it) block) => block(this);
}
