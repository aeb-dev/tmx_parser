import 'dart:async';

import 'package:tmx_parser/src/helpers/xml_traverser.dart';


import 'animation.dart';
import 'helpers/xml_accessor.dart';
import 'object_group.dart';
import 'properties.dart';
import 'property.dart';
import 'tmx_image.dart';

class Tile with XmlTraverser {
  late int id;
  late String className;
  late double probability;
  late double x;
  late double y;
  late double width;
  late double height;

  Map<String, Property>? properties;
  TmxImage? image;
  ObjectGroup? objectGroup;
  Animation? animation;

  @override
  void readAttributes(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;
    assert(
      element.localName == "tile",
      "can not parse, element is not a 'tile'",
    );

    id = element.getAttributeInt("id")!;
    className = element.getAttributeStrOr("className", "");
    probability = element.getAttributeDoubleOr("probability", 0.0);
    x = element.getAttributeDoubleOr("x", 0.0);
    y = element.getAttributeDoubleOr("y", 0.0);
  }

  @override
  Future<void> traverse(StreamIterator<XmlAccessor> si) async {
    XmlAccessor child = si.current;
    switch (child.localName) {
      case "properties":
        properties = Properties();
        await (properties as Properties).loadXml(si);
        break;
      case "image":
        image = TmxImage();
        await image!.loadXml(si);
        break;
      case "objectgroup":
        objectGroup = ObjectGroup();
        await objectGroup!.loadXml(si);
        break;
      case "animation":
        animation = Animation();
        await animation!.loadXml(si);
        break;
    }
  }
}
