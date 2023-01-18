enum ObjectType {
  rectangle("rectangle"),
  ellipse("ellipse"),
  point("point"),
  polygon("polygon"),
  polyline("polyline"),
  text("text"),
  ;

  final String tiledName;

  const ObjectType(this.tiledName);
}

extension ObjectTypeExtensions on String {
  ObjectType toObjectType() {
    switch (this) {
      case "rectangle":
        return ObjectType.rectangle;
      case "ellipse":
        return ObjectType.ellipse;
      case "point":
        return ObjectType.point;
      case "polygon":
        return ObjectType.polygon;
      case "polyline":
        return ObjectType.polyline;
      case "text":
        return ObjectType.text;
    }

    throw "Unknown 'ObjectType' value: '$this'";
  }
}
