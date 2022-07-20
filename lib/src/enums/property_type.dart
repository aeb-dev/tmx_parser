enum PropertyType {
  string,
  int,
  float,
  bool,
  color,
  file,
  object,
  classType,
}

extension StringExtensions on String {
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
        return PropertyType.classType;
    }

    throw "Unknown 'PropertyType' value: '$this'";
  }
}
