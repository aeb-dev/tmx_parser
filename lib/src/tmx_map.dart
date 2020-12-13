import 'package:xml/xml.dart';

import 'extensions/xml_element.dart';
import 'group.dart';
import 'image_layer.dart';
import 'layer.dart';
import 'object_group.dart';
import 'properties.dart';
import 'tile.dart';
import 'tile_set.dart';

class TmxMap {
  String version;
  String tiledVersion;
  String orientation;
  String renderOrder;
  int compressionLevel = -1;
  double width;
  double height;
  double tileWidth;
  double tileHeight;
  int hexSideLength;
  String staggerAxis;
  String staggerIndex;
  String backgroundColor;
  bool infinite;

  Map<String, dynamic> properties;

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

    version = element.getAttributeStrOr("version", version);
    tiledVersion = element.getAttributeStrOr("tiledversion", tiledVersion);
    orientation = element.getAttributeStrOr("orientation", orientation);
    renderOrder = element.getAttributeStrOr("renderorder", renderOrder);
    compressionLevel = element.getAttributeIntOr("compressionlevel", compressionLevel);
    width = element.getAttributeDoubleOr("width", width);
    height = element.getAttributeDoubleOr("height", height);
    tileWidth = element.getAttributeDoubleOr("tilewidth", tileWidth);
    tileHeight = element.getAttributeDoubleOr("tileheight", tileHeight);
    hexSideLength = element.getAttributeIntOr("hexsidelength", hexSideLength);
    staggerAxis = element.getAttributeStrOr("staggeraxis", staggerAxis);
    staggerIndex = element.getAttributeStrOr("staggerindex", staggerIndex);
    backgroundColor = element.getAttributeStrOr("backgroundcolor", backgroundColor);
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
            properties ??= properties = Properties.fromXML(childElement);
        }
      },
    );
  }

  /// Retrieve a tile based on its GID
  ///
  /// GID is 1-based
  /// From offical documentation:
  /// In order to find out from which tileset the tile is you need to find the
  /// tileset with the highest firstgid that is still lower or equal than the gid.
  /// The tilesets are always stored with increasing firstgids.
  /// A GID of 0 is always an "empty" tile
  TileSet getTileSetByGID(int gid) {
    final TileSet tileSet =
        tileSets.values.lastWhere((tileset) => tileset.firstgid <= gid);
    return tileSet;
  }

  // Returns a tileset based on its name
  TileSet getTileset(String name) {
    return tileSets[name];
  }

  /// Looks up a tile by its tileset and local tile id.
  Tile getTileByLocalID(String tilesetName, int localTileId) {
    final tileset = getTileset(tilesetName);
    return tileset.tiles[localTileId];
  }
}
