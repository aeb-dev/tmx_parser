import 'package:xml/xml.dart';

import 'extensions/xml_element.dart';

class Property {
  late String name;
  String type = "string";
  late dynamic value;

  Property.fromXML(XmlElement element) {
    if (element.name.local != "property") {
      throw "can not parse, element is not a 'property'";
    }

    name = element.getAttribute("name")!;
    type = element.getAttributeStrOr("type", type);

    switch (type) {
      case "int":
        value = element.getAttributeIntOr("value", 0);
        break;
      case "float":
        value = element.getAttributeDoubleOr("value", 0.0);
        break;
      case "bool":
        value = element.getAttributeBoolOr("value", false);
        break;
      case "color":
        value = element.getAttributeStrOr("value", "#00000000");
        break;
      case "string":
        value = element.getAttributeStrOr("value", "");
        break;
      default:
        throw "Unexpected 'type' value $type";
    }
  }
}
