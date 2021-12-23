import 'package:universal_io/io.dart';
import 'package:xml/xml.dart';

import 'enums/object_alignment.dart';
import 'extensions/string.dart';
import 'extensions/xml_element.dart';
import 'grid.dart';
import 'properties.dart';
import 'property.dart';
import 'terrain.dart';
import 'terrain_types.dart';
import 'tile.dart';
import 'tile_offset.dart';
import 'tmx_image.dart';
import 'wang_set.dart';
import 'wang_sets.dart';

class TileSet {
  late int firstGid;
  late String? source;
  late String name;
  late double tileWidth;
  late double tileHeight;
  double spacing = 0.0;
  double margin = 0.0;
  late int tileCount;
  late int columns;
  ObjectAlignment objectAlignment = ObjectAlignment.bottomLeft;

  TileOffset tileOffset = TileOffset.zero();

  TmxImage? image;
  Grid? grid;
  Map<String, Property>? properties;
  Map<String, Terrain>? terrainTypes;
  Map<String, WangSet>? wangSets;

  final Map<int, Tile> tiles = {};

  TileSet.fromXML(XmlElement element) {
    if (element.name.local != "tileset") {
      throw "can not parse, element is not a 'tileset'";
    }

    firstGid = element.getAttributeInt("firstgid")!;
    source = element.getAttributeStr("source");

    final String? sourceExtension = source?.split(".").last;
    if (sourceExtension != null && sourceExtension == "tsx") {
      final File file = File(source!);
      final XmlDocument tsx = XmlDocument.parse(file.readAsStringSync());
      element = tsx.rootElement;

      source = element.getAttributeStr("source");
    }

    name = element.getAttributeStr("name")!;
    tileWidth = element.getAttributeDouble("tilewidth")!;
    tileHeight = element.getAttributeDouble("tileheight")!;
    spacing = element.getAttributeDoubleOr("spacing", spacing);
    margin = element.getAttributeDoubleOr("margin", margin);
    tileCount = element.getAttributeInt("tilecount")!;
    columns = element.getAttributeInt("columns")!;
    objectAlignment = element
        .getAttributeStrOr("objectalignment", "unspecified")
        .toObjectAlignment();

    element.children.whereType<XmlElement>().forEach((childElement) {
      switch (childElement.name.local) {
        case "image":
          image = TmxImage.fromXML(childElement);
          break;
        case "tileoffset":
          tileOffset = TileOffset.fromXML(childElement);
          break;
        case "grid":
          grid = Grid.fromXML(childElement);
          break;
        case "properties":
          properties = Properties.fromXML(childElement);
          break;
        case "terraintypes":
          terrainTypes = TerrainTypes.fromXML(childElement);
          break;
        case "wangsets":
          wangSets = WangSets.fromXML(childElement);
          break;
        case "tile":
          final Tile tile = Tile.fromXML(childElement);
          tiles[tile.id] = tile;
          break;
      }
    });
  }

  Tile? getTileByGid(int gid) {
    int tileIndex = gid - firstGid;
    Tile? tile = tiles[tileIndex];

    return tile;
  }

  Tile? getTileById(int id) {
    return tiles[id];
  }
}
