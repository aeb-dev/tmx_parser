import 'dart:async';

import 'package:tmx_parser/src/enums/fill_mode.dart';
import 'package:tmx_parser/src/enums/tile_render_size.dart';
import 'package:tmx_parser/src/helpers/xml_traverser.dart';

import 'enums/object_alignment.dart';
import 'grid.dart';
import 'helpers/xml_accessor.dart';
import 'properties.dart';
import 'property.dart';
import 'tile.dart';
import 'tile_offset.dart';
import 'tmx_image.dart';
import 'transformations.dart';
import 'wang_set.dart';
import 'wang_sets.dart';

class TileSet with XmlTraverser {
  late int firstGid;
  late String? source;
  late String name;
  late String className;
  late double tileWidth;
  late double tileHeight;
  late double spacing;
  late double margin;
  late int tileCount;
  late int columns;
  late ObjectAlignment objectAlignment;
  late TileRenderSize tileRenderSize;
  late FillMode fillMode;

  TmxImage? image;
  TileOffset tileOffset = TileOffset.zero();
  Grid? grid;
  Map<String, Property>? properties;
  List<WangSet>? wangSets;
  Transformations? transformations;

  final Map<int, Tile> tiles = {};

  @override
  void readAttributes(StreamIterator<XmlAccessor> si) async {
    XmlAccessor element = si.current;
    assert(
      element.localName == "tileset",
      "can not parse, element is not a 'tileset'",
    );
    firstGid = element.getAttributeInt("firstgid")!;
    source = element.getAttributeStr("source");

    // final String? sourceExtension = source?.split(".").last;
    // if (sourceExtension != null && sourceExtension == "tsx") {
    //   File file = File(source!);
    //   XmlDocument tsx = XmlDocument.parse(file.readAsStringSync());
    //   element = tsx.rootElement;

    //   source = element.getAttributeStr("source");
    // }

    name = element.getAttributeStr("name")!;
    className = element.getAttributeStrOr("className", "");
    tileWidth = element.getAttributeDouble("tilewidth")!;
    tileHeight = element.getAttributeDouble("tileheight")!;
    spacing = element.getAttributeDoubleOr("spacing", 0.0);
    margin = element.getAttributeDoubleOr("margin", 0.0);
    tileCount = element.getAttributeInt("tilecount")!;
    columns = element.getAttributeInt("columns")!;
    objectAlignment = element
        .getAttributeStrOr("objectalignment", "unspecified")
        .toObjectAlignment();
    tileRenderSize =
        element.getAttributeStrOr("tilerendersize", "tile").toTileRenderSize();
    fillMode = element.getAttributeStrOr("fillmode", "stretch").toFillMode();
  }

  @override
  Future<void> traverse(StreamIterator<XmlAccessor> si) async {
    XmlAccessor child = si.current;
    switch (child.localName) {
      case "image":
        image = TmxImage();
        await image!.loadXml(si);
        break;
      case "tileoffset":
        tileOffset = TileOffset();
        await tileOffset.loadXml(si);
        break;
      case "grid":
        grid = Grid();
        await grid!.loadXml(si);
        break;
      case "properties":
        properties = Properties();
        await (properties as Properties).loadXml(si);
        break;
      case "wangsets":
        wangSets = WangSets();
        await (wangSets as WangSets).loadXml(si);
        break;
      case "transformations":
        transformations = Transformations();
        await transformations!.loadXml(si);
        break;
      case "tile":
        Tile tile = Tile();
        await tile.loadXml(si);
        tiles[tile.id] = tile;
        break;
    }
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
