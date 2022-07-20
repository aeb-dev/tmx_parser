import 'dart:async';

import 'package:meta/meta.dart';
import 'package:tmx_parser/src/helpers/xml_traverser.dart';

import 'helpers/xml_accessor.dart';
import 'properties.dart';
import 'property.dart';
import 'wang_color.dart';
import 'wang_tile.dart';

class WangSet with XmlTraverser {
  late String name;
  late String className;
  late int tile;

  Map<String, Property>? properties;
  final List<WangColor> wangColors = [];
  final Map<int, WangTile> wangTiles = {};

  @internal
  void readAttributes(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;
    assert(
      element.localName == "wangset",
      "can not parse, element is not a 'wangset'",
    );

    name = element.getAttributeStr("name")!;
    className = element.getAttributeStrOr("className", "");
    tile = element.getAttributeIntOr("tile", -1);
  }

  @internal
  Future<void> traverse(StreamIterator<XmlAccessor> si) async {
    XmlAccessor child = si.current;
    ;
    switch (child.localName) {
      case "wangcolor":
        WangColor wangColor = WangColor();
        await wangColor.loadXml(si);
        wangColors.add(wangColor);
        break;
      case "wangtile":
        WangTile wangTile = await WangTile();
        await wangTile.loadXml(si);
        wangTiles[wangTile.tileId] = wangTile;
        break;
      case "properties":
        properties = Properties();
        await (properties as Properties).loadXml(si);
        break;
    }
  }
}
