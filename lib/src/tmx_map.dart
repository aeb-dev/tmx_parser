import 'dart:async';

import 'package:tmx_parser/src/helpers/xml_accessor.dart';
import 'package:tmx_parser/src/helpers/xml_traverser.dart';

import 'enums/orientation.dart';
import 'enums/render_order.dart';
import 'enums/stagger_axis.dart';
import 'enums/stagger_index.dart';
import 'group.dart';
import 'image_layer.dart';
import 'layer.dart';
import 'tile_layer.dart';
import 'object_group.dart';
import 'properties.dart';
import 'tile_set.dart';

class TmxMap with XmlTraverser {
  late String version;
  String? tiledVersion;
  late String className;
  late Orientation orientation;
  late RenderOrder renderOrder;
  late int compressionLevel;
  late double width;
  late double height;
  late double tileWidth;
  late double tileHeight;
  int? hexSideLength;
  StaggerAxis? staggerAxis;
  StaggerIndex? staggerIndex;
  late double parallaxOriginX;
  late double parallaxOriginY;
  int? backgroundColor; // null means transparent
  late int nextLayerId;
  late int nextObjectId;
  late bool infinite;

  Map<String, dynamic>? properties;

  final Map<String, TileSet> tileSets = {};
  final List<TileLayer> layers = [];
  final Map<String, ObjectGroup> objectGroups = {};
  final List<ImageLayer> imageLayers = [];
  final List<Group> groups = [];

  final List<Layer> renderOrderedLayers = [];

  @override
  void readAttributes(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;
    assert(
      element.localName == "map",
      "can not parse, element is not a 'map'",
    );

    version = element.getAttributeStr("version")!;
    tiledVersion = element.getAttributeStr("tiledversion");
    className = element.getAttributeStrOr("className", "");
    orientation = element.getAttributeStr("orientation")!.toOrientation();
    renderOrder =
        element.getAttributeStrOr("renderorder", "right-down").toRenderOrder();
    compressionLevel = element.getAttributeIntOr("compressionlevel", -1);
    width = element.getAttributeDouble("width")!;
    height = element.getAttributeDouble("height")!;
    tileWidth = element.getAttributeDouble("tilewidth")!;
    tileHeight = element.getAttributeDouble("tileheight")!;
    hexSideLength = element.getAttributeInt("hexsidelength");
    staggerAxis = element.getAttributeStr("staggeraxis")?.toStaggerAxis();
    staggerIndex = element.getAttributeStr("staggerindex")?.toStaggerIndex();
    parallaxOriginX = element.getAttributeDoubleOr("parallaxoriginx", 0.0);
    parallaxOriginY = element.getAttributeDoubleOr("parallaxoriginy", 0.0);
    nextLayerId = element.getAttributeInt("nextlayerid")!;
    nextObjectId = element.getAttributeInt("nextobjectid")!;
    backgroundColor = element.getAttributeColor("backgroundcolor");

    infinite = element.getAttributeBoolOr("infinite", false);
  }

  @override
  Future<void> traverse(StreamIterator<XmlAccessor> si) async {
    XmlAccessor child = si.current;
    switch (child.localName) {
      case "tileset":
        TileSet tileSet = TileSet();
        await tileSet.loadXml(si);
        tileSets[tileSet.name] = tileSet;
        break;
      case "layer":
        TileLayer tileLayer = TileLayer();
        await tileLayer.loadXml(si);
        layers.add(tileLayer);
        renderOrderedLayers.add(tileLayer);
        break;
      case "objectgroup":
        ObjectGroup objectGroup = ObjectGroup();
        await objectGroup.loadXml(si);
        objectGroups[objectGroup.name] = objectGroup;
        renderOrderedLayers.add(objectGroup);
        break;
      case "imagelayer":
        ImageLayer imageLayer = ImageLayer();
        await imageLayer.loadXml(si);
        imageLayers.add(imageLayer);
        renderOrderedLayers.add(imageLayer);
        break;
      case "group":
        Group group = Group();
        await group.loadXml(si);
        groups.add(group);
        renderOrderedLayers.add(group);
        break;
      case "properties":
        properties = Properties();
        await (properties as Properties).loadXml(si);
    }
  }

  TileSet getTileSetByGid(int gid) {
    TileSet tileSet =
        tileSets.values.lastWhere((tileset) => tileset.firstGid <= gid);
    return tileSet;
  }

  TileSet getTileSetByName(String name) {
    return tileSets[name]!;
  }
}
