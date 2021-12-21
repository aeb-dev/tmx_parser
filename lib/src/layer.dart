import 'dart:typed_data';

import 'package:xml/xml.dart';

import 'data.dart';
import 'extensions/xml_element.dart';
import 'flips.dart';
import 'properties.dart';
import 'property.dart';

class Layer {
  static const int FLIPPED_HORIZONTALLY_FLAG = 0x80000000;
  static const int FLIPPED_VERTICALLY_FLAG = 0x40000000;
  static const int FLIPPED_DIAGONALLY_FLAG = 0x20000000;

  late int id;
  String name = "";
  late int width;
  late int height;
  double opacity = 1.0;
  bool visible = true;
  String? tintColor;
  double offsetX = 0.0;
  double offsetY = 0.0;
  double parallaxX = 0.0;
  double parallaxY = 0.0;

  Map<String, Property>? properties;
  Data? data;

  late List<List<int>> tileMatrix;
  late List<List<Flips?>> tileFlips;

  Layer.fromXML(XmlElement element) {
    if (element.name.local != "layer") {
      throw "can not parse, element is not a 'layer'";
    }

    id = element.getAttributeInt("id")!;
    name = element.getAttributeStrOr("name", name);
    width = element.getAttributeInt("width")!;
    height = element.getAttributeInt("height")!;
    opacity = element.getAttributeDoubleOr("opacity", opacity);
    visible = element.getAttributeBoolOr("visible", visible);
    tintColor = element.getAttributeStr("tintcolor");
    offsetX = element.getAttributeDoubleOr("offsetx", offsetX);
    offsetY = element.getAttributeDoubleOr("offsety", offsetY);
    parallaxX = element.getAttributeDoubleOr("parallaxx", parallaxX);
    parallaxY = element.getAttributeDoubleOr("parallaxy", parallaxY);

    element.children.whereType<XmlElement>().forEach((childElement) {
      switch (childElement.name.local) {
        case "data":
          data = Data.fromXML(childElement);
          _parseData(data!.rawData!);
          break;
        case "properties":
          properties = Properties.fromXML(childElement);
          break;
      }
    });
  }

  void _parseData(Uint8List data) {
    if (data.length != width * height * 4) {
      throw "data length should match tile size";
    }

    tileMatrix =
        List.generate(height, (index) => List.generate(width, (_) => 0, growable: false), growable: false);
    tileFlips =
        List.generate(height, (index) => List.generate(width, (_) => null, growable: false), growable: false);

    int tileIndex = 0;
    for (int y = 0; y < height; ++y) {
      for (int x = 0; x < width; ++x) {
        int globalTileId = data[tileIndex] |
            data[tileIndex + 1] << 8 |
            data[tileIndex + 2] << 16 |
            data[tileIndex + 3] << 24;

        tileIndex += 4;

        final bool flippedHorizontally =
            (globalTileId & FLIPPED_HORIZONTALLY_FLAG) ==
                FLIPPED_HORIZONTALLY_FLAG;
        final bool flippedVertically =
            (globalTileId & FLIPPED_VERTICALLY_FLAG) == FLIPPED_VERTICALLY_FLAG;
        final bool flippedDiagonally =
            (globalTileId & FLIPPED_DIAGONALLY_FLAG) == FLIPPED_DIAGONALLY_FLAG;

        globalTileId &= ~(FLIPPED_HORIZONTALLY_FLAG |
            FLIPPED_VERTICALLY_FLAG |
            FLIPPED_DIAGONALLY_FLAG);

        tileMatrix[y][x] = globalTileId;

        tileFlips[y][x] = Flips(
          flippedHorizontally,
          flippedVertically,
          flippedDiagonally,
        );
      }
    }
  }
}
