enum HAlign {
  left,
  center,
  right,
  justify,
  ;
}

extension StringExtensions on String {
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

    throw "Unknown 'HAlign' value: '$this'";
  }
}
