enum StaggerAxis {
  x("x"),
  y("y"),
  ;

  final String tiledName;

  const StaggerAxis(this.tiledName);
}

extension StaggerAxisExtensions on String {
  StaggerAxis toStaggerAxis() {
    switch (this) {
      case "x":
        return StaggerAxis.x;
      case "y":
        return StaggerAxis.y;
    }

    throw "Unknown 'StaggerAxis' value: '$this'";
  }
}
