enum DrawOrder {
  indexOrder,
  topDown,
  ;
}

extension StringExtensions on String {
  DrawOrder toDrawOrder() {
    switch (this) {
      case "index":
        return DrawOrder.indexOrder;
      case "topdown":
        return DrawOrder.topDown;
    }

    throw "Unknown 'DrawOrder' value: '$this'";
  }
}
