enum PropertyType {
  string("string"),
  int("int"),
  float("float"),
  bool("bool"),
  color("color"),
  file("file"),
  object("object"),
  $class("class"),
  ;

  final String tiledName;

  const PropertyType(this.tiledName);
}

extension PropertyTypeExtensions on String {
  PropertyType toPropertyType() {
    switch (this) {
      case "string":
        return PropertyType.string;
      case "int":
        return PropertyType.int;
      case "float":
        return PropertyType.float;
      case "bool":
        return PropertyType.bool;
      case "color":
        return PropertyType.color;
      case "file":
        return PropertyType.file;
      case "object":
        return PropertyType.object;
      case "class":
        return PropertyType.$class;
    }

    throw "Unknown 'PropertyType' value: '$this'";
  }
}
