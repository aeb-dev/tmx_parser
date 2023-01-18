enum ObjectAlignment {
  bottomLeft("bottomleft"),
  bottomRight("bottomright"),
  bottom("bottom"),
  topLeft("topleft"),
  topRight("topright"),
  top("top"),
  left("left"),
  center("center"),
  right("right"),
  ;

  final String tiledName;

  const ObjectAlignment(this.tiledName);
}

extension ObjectAlignmentExtensions on String {
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
