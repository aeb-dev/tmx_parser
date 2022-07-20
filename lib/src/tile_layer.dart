import 'dart:async';


import 'data.dart';
import 'flips.dart';
import 'helpers/xml_accessor.dart';
import 'layer.dart';
import 'properties.dart';

class TileLayer extends Layer {
  static const int FLIPPED_HORIZONTALLY_FLAG = 0x80000000;
  static const int FLIPPED_VERTICALLY_FLAG = 0x40000000;
  static const int FLIPPED_DIAGONALLY_FLAG = 0x20000000;

  late int width;
  late int height;
  late double parallaxX;
  late double parallaxY;

  Data? data;

  late List<List<int>> tileMatrix;
  late List<List<Flips?>> tileFlips;

  @override
  void readAttributes(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;
    assert(
      element.localName == "layer",
      "can not parse, element is not a 'layer'",
    );

    super.readAttributes(si);
    width = element.getAttributeInt("width")!;
    height = element.getAttributeInt("height")!;
    parallaxX = element.getAttributeDoubleOr("parallaxx", 0.0);
    parallaxY = element.getAttributeDoubleOr("parallaxy", 0.0);
  }

  @override
  Future<void> traverse(StreamIterator<XmlAccessor> si) async {
    XmlAccessor child = si.current;
    switch (child.localName) {
      case "data":
        data = Data();
        await data!.loadXml(si);
        break;
      case "properties":
        properties = Properties();
        await (properties as Properties).loadXml(si);
        break;
    }
  }

  @override
  void postProcess(StreamIterator<XmlAccessor> si) {
    if (data == null) {
      return;
    }

    if (data!.rawData.length != width * height * 4) {
      throw "data length should match tile size";
    }

    tileMatrix = List.generate(
      height,
      (index) => List.generate(
        width,
        (_) => 0,
        growable: false,
      ),
      growable: false,
    );

    tileFlips = List.generate(
      height,
      (index) => List.generate(
        width,
        (_) => null,
        growable: false,
      ),
      growable: false,
    );

    int tileIndex = 0;
    for (int y = 0; y < height; ++y) {
      for (int x = 0; x < width; ++x) {
        int globalTileId = data!.rawData[tileIndex] |
            data!.rawData[tileIndex + 1] << 8 |
            data!.rawData[tileIndex + 2] << 16 |
            data!.rawData[tileIndex + 3] << 24;

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
