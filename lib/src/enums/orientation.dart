enum Orientation {
  orthogonal,
  isometric,
  isometricStaggered,
  hexagonal,
  ;
}

extension StringExtensions on String {
  Orientation toOrientation() {
    switch (this) {
      case "orthogonal":
        return Orientation.orthogonal;
      case "isometric":
        return Orientation.isometric;
      case "staggered":
        return Orientation.isometricStaggered;
      case "hexagonal":
        return Orientation.hexagonal;
    }

    throw "Unknown 'Orientation' value: '$this'";
  }
}
