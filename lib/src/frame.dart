import "dart:async";

import "package:json_events/json_events.dart";
import "package:xml/xml_events.dart";

import "extensions/xml_start_element_event.dart";
import "mixins/xml_traverser.dart";

class Frame with XmlTraverser, JsonObjectTraverser {
  late int tileId;
  late int duration; // in ms

  @override
  void readAttributesXml(XmlStartElementEvent element) {
    assert(
      element.localName == "frame",
      "can not parse, element is not a 'frame'",
    );

    tileId = element.getAttribute<int>("tileid");
    duration = element.getAttribute<int>("duration");
  }

  @override
  Future<void> readJson(String key) async {
    switch (key) {
      case "tileid":
        tileId = await this.readPropertyJsonContinue<int>();
        break;
      case "duration":
        duration = await this.readPropertyJsonContinue<int>();
        break;
    }
  }
}
