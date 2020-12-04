part of tmx_parser;

class Layer {
  static const int FLIPPED_HORIZONTALLY_FLAG = 0x80000000;
  static const int FLIPPED_VERTICALLY_FLAG = 0x40000000;
  static const int FLIPPED_DIAGONALLY_FLAG = 0x20000000;

  int id;
  String name = "";
  int width;
  int height;
  double opacity = 1.0;
  bool visible = true;
  String tintColor;
  double offsetX = 0.0;
  double offsetY = 0.0;

  Map<String, Property> properties;

  List<List<int>> tileMatrix;
  List<List<Flips>> tileFlips;

  Layer.fromXML(XmlElement element) {
    if (element.name.local != "layer") {
      throw "can not parse, element is not a 'layer'";
    }

    id = element.getAttributeIntOr("id", id);
    name = element.getAttributeStrOr("name", name);
    width = element.getAttributeIntOr("width", width);
    height = element.getAttributeIntOr("height", height);
    visible = element.getAttributeBoolOr("visible", visible);
    tintColor = element.getAttributeStrOr("tintcolor", tintColor);
    offsetX = element.getAttributeDoubleOr("offsetx", offsetX);
    offsetY = element.getAttributeDoubleOr("offsety", offsetY);

    element.children.whereType<XmlElement>().forEach((childElement) {
      switch (childElement.name.local) {
        case "data":
          _parseData(childElement);
          break;
        case "properties":
          properties ??= Properties.fromXML(childElement);
          break;
      }
    });
  }

  void _parseData(XmlElement element) {
    final Uint8List data = Data.fromXML(element);

    if (data.length != width * height * 4) {
      throw "data length should match tile size";
    }

    tileMatrix = List.generate(height, (index) => List<int>(width));
    tileFlips = List.generate(height, (index) => List<Flips>(width));

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

      if (element.children
          .whereType<XmlElement>()
          .any((element) => element != null)) {
        throw "we do not support any child for 'data' node";
      }
    }
  }
}
