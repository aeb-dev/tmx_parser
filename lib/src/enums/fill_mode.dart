enum FillMode {
  stretch,
  preserveAspectFit,
}

extension StringExtensions on String {
  FillMode toFillMode() {
    switch (this) {
      case "stretch":
        return FillMode.stretch;
      case "preserve-aspect-fit":
        return FillMode.preserveAspectFit;
    }

    throw "Unknown 'FillMode' value: '$this'";
  }
}
