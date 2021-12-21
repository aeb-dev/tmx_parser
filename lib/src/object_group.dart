import 'package:xml/xml.dart';

import 'extensions/xml_element.dart';
import 'properties.dart';
import 'property.dart';
import 'tmx_object.dart';

class ObjectGroup {
  late int id;
  String name = "";
  String color = "#a0a0a4";
  double opacity = 1.0;
  bool visible = true;
  String? tintColor;
  double offsetX = 0.0;
  double offsetY = 0.0;
  String drawOrder = "topdown";

  Map<String, Property>? properties;
  Map<String, TmxObject> objectMapByName = {};
  Map<int, TmxObject> objectMapById = {};

  ObjectGroup.fromXML(XmlElement element) {
    if (element.name.local != "objectgroup") {
      throw "can not parse, element is not a 'objectgroup'";
    }

    id = element.getAttributeInt("id")!;
    name = element.getAttributeStrOr("name", name);
    color = element.getAttributeStrOr("color", color);
    opacity = element.getAttributeDoubleOr("opacity", opacity);
    visible = element.getAttributeBoolOr("visible", visible);
    tintColor = element.getAttributeStr("tintcolor");
    offsetX = element.getAttributeDoubleOr("offsetx", offsetX);
    offsetY = element.getAttributeDoubleOr("offsety", offsetY);
    drawOrder = element.getAttributeStrOr("draworder", drawOrder);

    final List<TmxObject> objectList = [];
    element.children.whereType<XmlElement>().forEach((childElement) {
      switch (childElement.name.local) {
        case "properties":
          properties = Properties.fromXML(childElement);
          break;
        case "object":
          final TmxObject object = TmxObject.fromXML(childElement);
          objectList.add(object);
          break;
      }
    });

    if (drawOrder == "topdown") {
      objectList.sort((first, second) => first.y.compareTo(second.y));
    }

    objectList.forEach((object) {
      objectMapByName[object.name] = object;
      objectMapById[object.id] = object;
    });
  }
}
