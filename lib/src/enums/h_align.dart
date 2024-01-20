enum HAlign {
  left("left"),
  center("center"),
  right("right"),
  justify("justify"),
  ;

  final String tiledName;

  const HAlign(this.tiledName);
}

extension HAlignExtensions on String {
  HAlign toHAlign() {
    switch (this) {
      case "left":
        return HAlign.left;
      case "center":
        return HAlign.center;
      case "right":
        return HAlign.right;
      case "justify":
        return HAlign.justify;
    }

    throw Exception("Unknown 'HAlign' value: '$this'");
  }
}
