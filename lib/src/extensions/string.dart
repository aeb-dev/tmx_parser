extension StringExtensions on String {
  int toInt({int radix: 10}) => int.parse(
        this,
        radix: radix,
      );

  double toDouble() => double.parse(this);

  bool toBool() =>
      this == "1" || this == "true" || this == "True" || this == "TRUE";
}
