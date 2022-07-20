enum RenderOrder {
  rightDown,
  rightUp,
  leftDown,
  leftUp,
  ;
}

extension StringExtensions on String {
  RenderOrder toRenderOrder() {
    switch (this) {
      case "right-down":
        return RenderOrder.rightDown;
      case "right-up":
        return RenderOrder.rightUp;
      case "left-down":
        return RenderOrder.leftDown;
      case "left-up":
        return RenderOrder.leftUp;
    }

    throw "Unknown 'RenderOrder' value: '$this'";
  }
}