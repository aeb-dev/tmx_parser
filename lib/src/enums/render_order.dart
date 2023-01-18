enum RenderOrder {
  rightDown("right-down"),
  rightUp("right-up"),
  leftDown("left-down"),
  leftUp("left-up"),
  ;

  final String tiledName;

  const RenderOrder(this.tiledName);
}

extension RenderOrderExtensions on String {
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
