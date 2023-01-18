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

  final Map<String, Property> properties = {};
  final List<WangColor> wangColors = [];
  final Map<int, WangTile> wangTiles = {};

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
        break;
      case "wangtile":
        WangTile wangTile = WangTile();
        await wangTile.loadXml(six);
        wangTiles[wangTile.tileId] = wangTile;
        break;
      case "property":
        Property property = Property();
        await property.loadXml(six);
        properties[property.name] = property;
        break;
    }
  }

  @override
  Future<void> readJson(String key) async {
    switch (key) {
      case "name":
        name = await this.readPropertyJsonContinue<String>();
        break;
      case "class":
        className =
            await this.readPropertyJsonContinue<String>(defaultValue: "");
        break;
      case "tile":
        tile = await this.readPropertyJsonContinue<int>(defaultValue: -1);
        break;
      case "colors":
        await this.loadListJson(
          l: wangColors,
          creator: WangColor.new,
        );
        break;
      case "wangtiles":
        await loadMapJson<int, WangTile>(
          m: wangTiles,
          keySelector: (wangTile) => wangTile.tileId,
          creator: WangTile.new,
        );
        break;
      case "properties":
        await loadMapJson<String, Property>(
          m: properties,
          keySelector: (property) => property.name,
          creator: Property.new,
        );
        break;
    }
  }
}
