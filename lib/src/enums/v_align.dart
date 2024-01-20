enum VAlign {
  top("top"),
  center("center"),
  bottom("bottom"),
  ;

  final String tiledName;

  const VAlign(this.tiledName);
}

extension VAlignExtensions on String {
  VAlign toVAlign() {
    switch (this) {
      case "top":
        return VAlign.top;
      case "center":
        return VAlign.center;
      case "bottom":
        return VAlign.bottom;
    }

    throw Exception("Unknown 'VAlign' value: '$this'");
  }
}
