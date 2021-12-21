import 'package:xml/xml.dart';

import 'extensions/xml_element.dart';
import 'image_layer.dart';
import 'layer.dart';
import 'object_group.dart';
import 'properties.dart';
import 'property.dart';

class Group {
  late int id;
  String name = "";
  double offsetX = 0.0;
  double offsetY = 0.0;
  double opacity = 1.0;
  bool visible = true;
  String? tintColor;

  Map<String, Property>? properties;

  final List<Layer> layers = [];
  final Map<String, ObjectGroup> objectGroups = {};
  final List<ImageLayer> imageLayers = [];
  final List<Group> groups = [];

  final List<dynamic> renderOrderedLayers = [];

  Group.fromXML(XmlElement element) {
    if (element.name.local != "group") {
      throw "can not parse, element is not a 'group'";
    }

    id = element.getAttributeInt("id")!;
    name = element.getAttributeStrOr("name", name);
    offsetX = element.getAttributeDoubleOr("offsetx", offsetX);
    offsetY = element.getAttributeDoubleOr("offsety", offsetY);
    opacity = element.getAttributeDoubleOr("opacity", opacity);
    visible = element.getAttributeBoolOr("visible", visible);
    tintColor = element.getAttributeStr("tintcolor");

    element.children.whereType<XmlElement>().forEach((childElement) {
      switch (childElement.name.local) {
        case "properties":
          properties = Properties.fromXML(childElement);
          break;
        case "layer":
          final Layer layer = Layer.fromXML(childElement);
          layers.add(layer);
          renderOrderedLayers.add(layer);
          break;
        case "objectgroup":
          final ObjectGroup objectGroup = ObjectGroup.fromXML(childElement);
          objectGroups[objectGroup.name] = objectGroup;
          renderOrderedLayers.add(objectGroup);
          break;
        case "imagelayer":
          final ImageLayer imageLayer = ImageLayer.fromXML(childElement);
          imageLayers.add(imageLayer);
          renderOrderedLayers.add(imageLayer);
          break;
        case "group":
          final Group group = Group.fromXML(childElement);
          groups.add(group);
          renderOrderedLayers.add(group);
          break;
      }
    });
  }
}
