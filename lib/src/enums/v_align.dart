enum VAlign {
  top,
  center,
  bottom,
  ;
}

extension StringExtensions on String {
  VAlign toVAlign() {
    switch (this) {
      case "top":
        return VAlign.top;
      case "center":
        return VAlign.center;
      case "bottom":
        return VAlign.bottom;
    }

    throw "Unknown 'VAlign' value: '$this'";
  }
}
