import 'package:xml/xml.dart';

import 'extensions/xml_element.dart';
import 'group.dart';
import 'image_layer.dart';
import 'layer.dart';
import 'object_group.dart';
import 'properties.dart';
import 'tile_set.dart';

class TmxMap {
  late String version;
  String? tiledVersion;
  late String orientation;
  String? renderOrder;
  int compressionLevel = -1;
  late double width;
  late double height;
  late double tileWidth;
  late double tileHeight;
  int? hexSideLength;
  String? staggerAxis;
  String? staggerIndex;
  String? backgroundColor; // null means transparent
  bool infinite = false;

  Map<String, dynamic>? properties;

  Map<String, TileSet> tileSets = {};
  List<Layer> layers = [];
  Map<String, ObjectGroup> objectGroups = {};
  List<ImageLayer> imageLayers = [];
  List<Group> groups = [];

  List<dynamic> renderOrderedLayers = [];

  TmxMap.fromXml(XmlElement element) {
    if (element.name.local != "map") {
      throw "can not parse, element is not a 'map'";
    }

    version = element.getAttributeStr("version")!;
    tiledVersion = element.getAttributeStr("tiledversion");
    orientation = element.getAttributeStr("orientation")!;
    renderOrder = element.getAttributeStr("renderorder");
    compressionLevel =
        element.getAttributeIntOr("compressionlevel", compressionLevel);
    width = element.getAttributeDouble("width")!;
    height = element.getAttributeDouble("height")!;
    tileWidth = element.getAttributeDouble("tilewidth")!;
    tileHeight = element.getAttributeDouble("tileheight")!;
    hexSideLength = element.getAttributeInt("hexsidelength");
    staggerAxis = element.getAttributeStr("staggeraxis");
    staggerIndex = element.getAttributeStr("staggerindex");
    backgroundColor = element.getAttributeStr("backgroundcolor");
    infinite = element.getAttributeBoolOr("infinite", infinite);

    element.children.whereType<XmlElement>().forEach(
      (childElement) {
        switch (childElement.name.local) {
          case "tileset":
            final TileSet tileSet = TileSet.fromXML(childElement);
            tileSets[tileSet.name] = tileSet;
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
          case "properties":
            properties = properties = Properties.fromXML(childElement);
        }
      },
    );
  }

  TileSet getTileSetByGid(int gid) {
    final TileSet tileSet =
        tileSets.values.lastWhere((tileset) => tileset.firstGid <= gid);
    return tileSet;
  }

  TileSet getTileSetByName(String name) {
    return tileSets[name]!;
  }
}
