import 'dart:io';

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
  int firstGid;
  String source;
  String name;
  double tileWidth;
  double tileHeight;
  double spacing = 0.0;
  double margin = 0.0;
  int tileCount;
  int columns;
  ObjectAlignment objectAlignment = ObjectAlignment.bottomLeft;

  TmxImage image;
  TileOffset tileOffset = TileOffset.zero();
  Grid grid;
  Map<String, Property> properties;
  Map<String, Terrain> terrainTypes;
  Map<String, WangSet> wangSets;
  Map<int, Tile> tiles = {};

  TileSet.fromXML(XmlElement element) {
    if (element.name.local != "tileset") {
      throw "can not parse, element is not a 'tileset'";
    }

    firstGid = element.getAttributeIntOr("firstgid", firstGid);
    source = element.getAttributeStrOr("source", source);

    final String sourceExtension = source?.split(".")?.last;
    if (sourceExtension == "tsx") {
      final File file = File(source);
      final XmlDocument tsx = XmlDocument.parse(file.readAsStringSync());
      element = tsx.rootElement;
    }

    source = element.getAttributeStrOr("source", source);
    name = element.getAttributeStrOr("name", name);
    tileWidth = element.getAttributeDoubleOr("tilewidth", tileWidth);
    tileHeight = element.getAttributeDoubleOr("tileheight", tileHeight);
    spacing = element.getAttributeDoubleOr("spacing", spacing);
    margin = element.getAttributeDoubleOr("margin", margin);
    tileCount = element.getAttributeIntOr("tilecount", tileCount);
    columns = element.getAttributeIntOr("columns", columns);
    objectAlignment = element
        .getAttributeStrOr("objectalignment", "unspecified")
        .toObjectAlignment();

    element.children.whereType<XmlElement>().forEach((childElement) {
      switch (childElement.name.local) {
        case "image":
          image ??= TmxImage.fromXML(childElement);
          break;
        case "tileoffset":
          tileOffset ??= TileOffset.fromXML(childElement);
          break;
        case "grid":
          grid ??= Grid.fromXML(childElement);
          break;
        case "properties":
          properties ??= Properties.fromXML(childElement);
          break;
        case "terraintypes":
          terrainTypes ??= TerrainTypes.fromXML(childElement);
          break;
        case "wangsets":
          wangSets ??= WangSets.fromXML(childElement);
          break;
        case "tile":
          final Tile tile = Tile.fromXML(childElement);
          tiles[tile.id] = tile;
          break;
      }
    });
  }

  Tile getTileByGid(int gid) {
    int tileIndex = gid - firstGid;
    Tile tile = tiles[tileIndex];

    return tile;
  }

  Tile getTileById(int id) {
    return tiles[id];
  }
}
