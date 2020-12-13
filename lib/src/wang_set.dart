import 'package:xml/xml.dart';

import 'extensions/xml_element.dart';
import 'properties.dart';
import 'property.dart';
import 'wang_color.dart';
import 'wang_tile.dart';

class WangSet {
  String name;
  int tile;

  Map<String, WangCornerColor> wangCornerColors = {};
  Map<String, WangEdgeColor> wangEdgeColors = {};
  List<WangTile> wangTiles = [];
  Map<String, Property> properties;

  WangSet.fromXML(XmlElement element) {
    if (element.name.local != "wangset") {
      throw "can not parse, element is not a 'wangset'";
    }

    name = element.getAttributeStrOr("name", name);
    tile = element.getAttributeIntOr("tile", tile);

    element.children.whereType<XmlElement>().forEach((childElement) {
      switch (childElement.name.local) {
        case "wangcornercolor":
          final WangCornerColor wangCornerColor =
              WangCornerColor.fromXML(childElement);
          wangCornerColors[wangCornerColor.name] = wangCornerColor;
          break;
        case "wangedgecolor":
          final WangEdgeColor wangEdgeColor =
              WangEdgeColor.fromXML(childElement);
          wangEdgeColors[wangEdgeColor.name] = wangEdgeColor;
          break;
        case "wangtile":
          final WangTile wangTile = WangTile.fromXML(childElement);
          wangTiles.add(wangTile);
          break;
        case "properties":
          properties ??= Properties.fromXML(childElement);
          break;
      }
    });
  }
}
