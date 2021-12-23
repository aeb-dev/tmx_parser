import 'package:xml/xml.dart';

import 'extensions/xml_element.dart';
import 'properties.dart';
import 'property.dart';
import 'tmx_image.dart';

class ImageLayer {
  late int id;
  String name = "";
  double offsetX = 0.0;
  double offsetY = 0.0;
  double opacity = 1.0;
  bool visible = true;

  Map<String, Property>? properties;
  TmxImage? image;

  ImageLayer.fromXML(XmlElement element) {
    if (element.name.local != "imagelayer") {
      throw "can not parse, element is not an 'imagelayer'";
    }

    id = element.getAttributeInt("id")!;
    name = element.getAttributeStrOr("name", name);
    offsetX = element.getAttributeDoubleOr("offsetx", offsetX);
    offsetY = element.getAttributeDoubleOr("offsety", offsetY);
    opacity = element.getAttributeDoubleOr("opacity", opacity);
    visible = element.getAttributeBoolOr("visible", visible);

    element.children.whereType<XmlElement>().forEach((childElement) {
      switch (childElement.name.local) {
        case "properties":
          properties = Properties.fromXML(childElement);
          break;
        case "image":
          image = TmxImage.fromXML(childElement);
          break;
      }
    });
  }
}
