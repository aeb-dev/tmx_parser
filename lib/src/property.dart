part of tmx_parser;

class Property {
  String name;
  String type;
  dynamic value;

  Property.fromXML(XmlElement element) {
    if (element.name.local != "property") {
      throw "can not parse, element is not a 'property'";
    }

    name = element.getAttribute("name");

    switch (element.getAttribute("type")) {
      case "int":
        value = element.getAttributeIntOr("value", 0);
        break;
      case "float":
        value = element.getAttributeDoubleOr("value", 0.0);
        break;
      case "bool":
        value = element.getAttributeBoolOr("value", false);
        break;
      default: // for types file, color (returns ARGB), string
        value = element.getAttributeStrOr("value", "");
        break;
    }
  }
}
