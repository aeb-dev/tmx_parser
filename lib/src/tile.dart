import 'package:xml/xml.dart';

import 'extensions/xml_element.dart';

import 'animation.dart';
import 'object_group.dart';
import 'properties.dart';
import 'property.dart';
import 'tmx_image.dart';

class Tile {
  late int id;
  String? type;
  String? terrain;
  double probability = 0.0;

  Map<String, Property>? properties;
  TmxImage? image;
  ObjectGroup? objectGroup;
  Animation? animation;

  Tile.fromXML(XmlElement element) {
    if (element.name.local != "tile") {
      throw "can not parse, element is not a 'tile'";
    }

    id = element.getAttributeInt("id")!;
    type = element.getAttributeStr("type");
    terrain = element.getAttributeStr("terrain");
    probability = element.getAttributeDoubleOr("probability", probability);

    element.children.whereType<XmlElement>().forEach((childElement) {
      switch (childElement.name.local) {
        case "properties":
          properties = Properties.fromXML(childElement);
          break;
        case "image":
          image = TmxImage.fromXML(childElement);
          break;
        case "objectgroup":
          objectGroup = ObjectGroup.fromXML(childElement);
          break;
        case "animation":
          animation = Animation.fromXML(childElement);
          break;
      }
    });
  }
}
