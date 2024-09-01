extension EDouble on double {
  bool get isInt => this % 1 == 0;

  String get beautify {
    return this % 1 == 0 ? '${toInt()}' : toStringAsFixed(2);
  }
}
