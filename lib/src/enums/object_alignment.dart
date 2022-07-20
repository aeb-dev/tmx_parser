enum ObjectAlignment {
  bottomLeft,
  bottomRight,
  bottom,
  topLeft,
  topRight,
  top,
  left,
  center,
  right,
  ;
}

extension StringExtensions on String {
  ObjectAlignment toObjectAlignment() {
    switch (this) {
      case "unspecified":
      case "bottomleft":
        return ObjectAlignment.bottomLeft;
      case "bottomright":
        return ObjectAlignment.bottomRight;
      case "bottom":
        return ObjectAlignment.bottom;
      case "topleft":
        return ObjectAlignment.topLeft;
      case "topright":
        return ObjectAlignment.topRight;
      case "top":
        return ObjectAlignment.top;
      case "left":
        return ObjectAlignment.left;
      case "center":
        return ObjectAlignment.center;
      case "right":
        return ObjectAlignment.right;
    }

    throw "Unknown 'ObjectAlignment' value: '$this'";
  }
}
