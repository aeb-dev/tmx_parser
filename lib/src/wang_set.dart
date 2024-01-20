import "dart:async";

import "package:json_events/json_events.dart";
import "package:meta/meta.dart";
import "package:xml/xml_events.dart";

import "extensions/json_traverser.dart";
import "extensions/xml_event.dart";
import "extensions/xml_start_element_event.dart";
import "mixins/xml_traverser.dart";
import "property.dart";
import "wang_color.dart";
import "wang_tile.dart";

class WangSet with XmlTraverser, JsonObjectTraverser {
  late String name;
  late String className = "";
  late int tile = -1;

  final Map<String, Property> properties = <String, Property>{};
  final List<WangColor> wangColors = <WangColor>[];
  final Map<int, WangTile> wangTiles = <int, WangTile>{};

  @override
  @internal
  void readAttributesXml(XmlStartElementEvent element) {
    assert(
      element.localName == "wangset",
      "can not parse, element is not a 'wangset'",
    );

    name = element.getAttribute<String>("name");
    className = element.getAttribute<String>("class", defaultValue: "");
    tile = element.getAttribute<int>("tile", defaultValue: -1);
  }

  @override
  @internal
  Future<void> traverseXml() async {
    switch (six.current.asStartElement.localName) {
      case "wangcolor":
        WangColor wangColor = WangColor();
        await wangColor.loadXml(six);
        wangColors.add(wangColor);
      case "wangtile":
        WangTile wangTile = WangTile();
        await wangTile.loadXml(six);
        wangTiles[wangTile.tileId] = wangTile;
      case "property":
        Property property = Property();
        await property.loadXml(six);
        properties[property.name] = property;
    }
  }

  @override
  Future<void> readJson(String key) async {
    switch (key) {
      case "name":
        name = await this.readPropertyJsonContinue<String>();
      case "class":
        className =
            await this.readPropertyJsonContinue<String>(defaultValue: "");
      case "tile":
        tile = await this.readPropertyJsonContinue<int>(defaultValue: -1);
      case "colors":
        await this.loadListJson(
          l: wangColors,
          creator: WangColor.new,
        );
      case "wangtiles":
        await loadMapJson<int, WangTile>(
          m: wangTiles,
          keySelector: (WangTile wangTile) => wangTile.tileId,
          creator: WangTile.new,
        );
      case "properties":
        await loadMapJson<String, Property>(
          m: properties,
          keySelector: (Property property) => property.name,
          creator: Property.new,
        );
    }
  }
}
