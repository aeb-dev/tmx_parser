enum FillMode {
  stretch("stretch"),
  preserveAspectFit("preserve-aspect-fit"),
  ;

  final String tiledName;

  const FillMode(this.tiledName);
}

extension FillModeExtensions on String {
  FillMode toFillMode() {
    switch (this) {
      case "stretch":
        return FillMode.stretch;
      case "preserve-aspect-fit":
        return FillMode.preserveAspectFit;
    }

    throw Exception("Unknown 'FillMode' value: '$this'");
  }
}
