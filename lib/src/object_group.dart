part of tmx_parser;

class ObjectGroup {
  int id;
  String name;
  String color;
  double opacity = 1.0;
  bool visible = true;
  String tintColor;
  double offsetX = 0.0;
  double offsetY = 0.0;
  String drawOrder = "topdown";

  Map<String, Property> properties;
  Map<String, TmxObject> objects = {};

  ObjectGroup.fromXML(XmlElement element) {
    if (element.name.local != "objectgroup") {
      throw "can not parse, element is not a 'objectgroup'";
    }

    id = element.getAttributeIntOr("id", id);
    name = element.getAttributeStrOr("name", name);
    color = element.getAttributeStrOr("color", color);
    opacity = element.getAttributeDoubleOr("opacity", opacity);
    visible = element.getAttributeBoolOr("visible", visible);
    tintColor = element.getAttributeStrOr("tintcolor", tintColor);
    offsetX = element.getAttributeDoubleOr("offsetx", offsetX);
    offsetY = element.getAttributeDoubleOr("offsety", offsetY);
    drawOrder = element.getAttributeStrOr("draworder", drawOrder);

    final List<TmxObject> objectList = [];
    element.children.whereType<XmlElement>().forEach((childElement) {
      switch (childElement.name.local) {
        case "properties":
          properties ??= Properties.fromXML(childElement);
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

    objectList.forEach((object) => objects[object.name] = object);
  }
}
