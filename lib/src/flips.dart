class Flips {
  final bool horizontally;
  final bool vertically;
  final bool diagonally;

  const Flips(
    // ignore: avoid_positional_boolean_parameters
    this.horizontally,
    this.vertically,
    this.diagonally,
  );

  const Flips.defaults() : this(false, false, false);

  Flips copyWith({
    bool? horizontally,
    bool? vertically,
    bool? diagonally,
  }) =>
      Flips(
        horizontally ?? this.horizontally,
        vertically ?? this.vertically,
        diagonally ?? this.diagonally,
      );
}
