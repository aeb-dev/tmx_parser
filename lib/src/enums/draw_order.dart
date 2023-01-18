enum DrawOrder {
  indexOrder("index"),
  topDown("topdown"),
  ;

  final String tiledName;

  const DrawOrder(this.tiledName);
}

extension DrawOrderExtensions on String {
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
