enum StaggerAxis {
  x,
  y,
  ;
}

extension StringExtensions on String {
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
