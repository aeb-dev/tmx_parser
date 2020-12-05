part of tmx_parser;

class TileSet {
  int firstgid;
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
  TileOffset tileOffset;
  Grid grid;
  Map<String, Property> properties;
  Map<String, Terrain> terrainTypes;
  Map<String, WangSet> wangSets;
  List<Tile> tiles = [];

  TileSet.fromXML(XmlElement element) {
    if (element.name.local != "tileset") {
      throw "can not parse, element is not a 'tileset'";
    }

    firstgid = element.getAttributeIntOr("firstgid", firstgid);
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
          tiles.add(tile);
          break;
      }
    });
  }
}

enum ObjectAlignment {
  bottomLeft,
  bottomRight,
  bottom,
  topLeft,
  topRight,
  top,
  left,
  center,
  right,
}