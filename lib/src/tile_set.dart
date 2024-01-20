import "dart:async";

import "package:json_events/json_events.dart";
import "package:xml/xml_events.dart";

import "enums/fill_mode.dart";
import "enums/object_alignment.dart";
import "enums/tile_render_size.dart";
import "extensions/json_traverser.dart";
import "extensions/string.dart";
import "extensions/xml_event.dart";
import "extensions/xml_start_element_event.dart";
import "grid.dart";
import "mixins/xml_traverser.dart";
import "property.dart";
import "tile.dart";
import "tile_offset.dart";
import "tmx_image.dart";
import "transformations.dart";
import "wang_set.dart";

class TileSet with XmlTraverser, JsonObjectTraverser {
  late int firstGid;
  late String name;
  late String className = "";
  late int tileWidth;
  late int tileHeight;
  late int spacing = 0;
  late int margin = 0;
  late int tileCount;
  late int columns;
  late ObjectAlignment objectAlignment = ObjectAlignment.bottomLeft;
  late TileRenderSize tileRenderSize = TileRenderSize.tile;
  late FillMode fillMode = FillMode.stretch;

  String? source;
  TmxImage? image;
  TileOffset tileOffset = TileOffset.zero();
  Grid? grid;
  Transformations? transformations;

  final Map<int, Tile> tiles = <int, Tile>{};
  final Map<String, WangSet> wangSets = <String, WangSet>{};
  final Map<String, Property> properties = <String, Property>{};

  @override
  void readAttributesXml(XmlStartElementEvent element) async {
    assert(
      element.localName == "tileset",
      "can not parse, element is not a 'tileset'",
    );
    firstGid = element.getAttribute<int>("firstgid");
    source = element.getAttribute<String?>("source");

    // final String? sourceExtension = source?.split(".").last;
    // if (sourceExtension != null && sourceExtension == "tsx") {
    //   File file = File(source!);
    //   XmlDocument tsx = XmlDocument.parse(file.readAsStringSync());
    //   element = tsx.rootElement;

    //   source = element.getAttributeStr("source");
    // }

    name = element.getAttribute<String>("name");
    className = element.getAttribute<String>("class", defaultValue: "");
    tileWidth = element.getAttribute<int>("tilewidth");
    tileHeight = element.getAttribute<int>("tileheight");
    spacing = element.getAttribute<int>("spacing", defaultValue: 0);
    margin = element.getAttribute<int>("margin", defaultValue: 0);
    tileCount = element.getAttribute<int>("tilecount");
    columns = element.getAttribute<int>("columns");
    objectAlignment = element
        .getAttribute<String>("objectalignment", defaultValue: "unspecified")
        .toObjectAlignment();
    tileRenderSize = element
        .getAttribute<String>("tilerendersize", defaultValue: "tile")
        .toTileRenderSize();
    fillMode = element
        .getAttribute<String>("fillmode", defaultValue: "stretch")
        .toFillMode();
  }

  @override
  Future<void> traverseXml() async {
    switch (six.current.asStartElement.localName) {
      case "image":
        image = TmxImage();
        await image!.loadXml(six);
      case "tileoffset":
        tileOffset = TileOffset();
        await tileOffset.loadXml(six);
      case "grid":
        grid = Grid();
        await grid!.loadXml(six);
      case "property":
        Property property = Property();
        await property.loadXml(six);
        properties[property.name] = property;
      case "wangset":
        WangSet wangSet = WangSet();
        await wangSet.loadXml(six);
        wangSets[wangSet.name] = wangSet;
      case "transformations":
        transformations = Transformations();
        await transformations!.loadXml(six);
      case "tile":
        Tile tile = Tile();
        await tile.loadXml(six);
        tiles[tile.id] = tile;
    }
  }

  @override
  Future<void> readJson(String key) async {
    switch (key) {
      case "firstgid":
        firstGid = await this.readPropertyJsonContinue<int>();
      case "source":
        source = await this.readPropertyJsonContinue<String>();
      case "name":
        name = await this.readPropertyJsonContinue<String>();
      case "class":
        className =
            await this.readPropertyJsonContinue<String>(defaultValue: "");
      case "tilewidth":
        tileWidth = await this.readPropertyJsonContinue<int>();
      case "tileheight":
        tileHeight = await this.readPropertyJsonContinue<int>();
      case "spacing":
        spacing = await this.readPropertyJsonContinue<int>();
      case "margin":
        margin = await this.readPropertyJsonContinue<int>();
      case "tilecount":
        tileCount = await this.readPropertyJsonContinue<int>();
      case "columns":
        columns = await this.readPropertyJsonContinue<int>();
      case "objectalignment":
        objectAlignment = (await this.readPropertyJsonContinue<String?>(
          defaultValue: "unspecified",
        ))!
            .toObjectAlignment();
      case "tilerendersize":
        tileRenderSize = (await this
                .readPropertyJsonContinue<String?>(defaultValue: "tile"))!
            .toTileRenderSize();
      case "fillmode":
        fillMode = (await this
                .readPropertyJsonContinue<String?>(defaultValue: "stretch"))!
            .toFillMode();
      // case "format":
      //   image ??= TmxImage();
      //   image!.format = await this.readPropertyJsonContinue<String?>();
      //   break;
      case "image":
        image ??= TmxImage();
        image!.source = await this.readPropertyJsonContinue<String>();
      case "transparentcolor":
        image ??= TmxImage();
        image!.transparentColor =
            (await this.readPropertyJsonContinue<String?>())?.toColor();
      case "imagewidth":
        image ??= TmxImage();
        image!.width = await this.readPropertyJsonContinue<int?>();
      case "imageheight":
        image ??= TmxImage();
        image!.height = await this.readPropertyJsonContinue<int?>();
      case "tileoffset":
        tileOffset = await this.readObjectJsonContinue(creator: TileOffset.new);
      case "grid":
        grid = await this.readObjectJsonContinue(creator: Grid.new);
      case "properties":
        await loadMapJson<String, Property>(
          m: properties,
          keySelector: (Property property) => property.name,
          creator: Property.new,
        );
      case "wangsets":
        await loadMapJson<String, WangSet>(
          m: wangSets,
          keySelector: (WangSet wangSet) => wangSet.name,
          creator: WangSet.new,
        );
      case "transformations":
        transformations =
            await this.readObjectJsonContinue(creator: Transformations.new);
      case "tiles":
        await loadMapJson<int, Tile>(
          m: tiles,
          keySelector: (Tile tile) => tile.id,
          creator: Tile.new,
        );
    }
  }

  Tile? getTileByGid(int gid) {
    int tileIndex = gid - firstGid;
    Tile? tile = tiles[tileIndex];

    return tile;
  }

  Tile? getTileById(int id) => tiles[id];
}
