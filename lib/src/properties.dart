part of tmx_parser;

class Properties {
  Properties._();

  static Map<String, Property> fromXML(XmlElement element) {
    if (element.name.local != "properties") {
      throw "can not parse, element is not a 'properties'";
    }

    final Map<String, Property> properties = {};

    element.children.whereType<XmlElement>().forEach((childElement) {
      switch (childElement.name.local) {
        case "property":
          final Property property = Property.fromXML(childElement);
          properties[property.name] = property;
          break;
      }
    });

    return properties;
  }
}
