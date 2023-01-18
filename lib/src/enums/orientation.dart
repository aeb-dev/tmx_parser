enum Orientation {
  orthogonal("orthogonal"),
  isometric("isometric"),
  isometricStaggered("staggered"),
  hexagonal("hexagonal"),
  ;

  final String tiledName;

  const Orientation(this.tiledName);
}

extension OrientationExtensions on String {
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
