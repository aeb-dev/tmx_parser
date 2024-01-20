import "dart:async";

import "package:json_events/json_events.dart";
import "package:xml/xml_events.dart";

import "extensions/xml_start_element_event.dart";
import "mixins/xml_traverser.dart";

class TileOffset with XmlTraverser, JsonObjectTraverser {
  late int x = 0;
  late int y = 0;

  TileOffset();

  TileOffset.zero() {
    x = 0;
    y = 0;
  }

  @override
  void readAttributesXml(XmlStartElementEvent element) {
    assert(
      element.localName == "tileoffset",
      "can not parse, element is not a 'tileoffset'",
    );

    x = element.getAttribute<int>("x", defaultValue: 0);
    y = element.getAttribute<int>("y", defaultValue: 0);
  }

  @override
  Future<void> readJson(String key) async {
    switch (key) {
      case "x":
        x = await this.readPropertyJsonContinue<int>(defaultValue: 0);
      case "y":
        y = await this.readPropertyJsonContinue<int>(defaultValue: 0);
    }
  }
}
