import "dart:async";

import "package:json_events/json_events.dart";
import "package:xml/xml_events.dart";

import "extensions/xml_start_element_event.dart";
import "mixins/xml_traverser.dart";

class ChunkSize with XmlTraverser, JsonObjectTraverser {
  late int width = 16;
  late int height = 16;

  @override
  void readAttributesXml(XmlStartElementEvent element) {
    assert(
      element.localName == "chunksize",
      "can not parse, element is not a 'chunksize'",
    );

    width = element.getAttribute<int>(
      "width",
      defaultValue: 16,
    );
    height = element.getAttribute<int>(
      "height",
      defaultValue: 16,
    );
  }

  @override
  Future<void> readJson(String key) async {
    switch (key) {
      case "width":
        width = await this.readPropertyJsonContinue<int>(
          defaultValue: 16,
        );
        break;
      case "height":
        height = await this.readPropertyJsonContinue<int>(
          defaultValue: 16,
        );
        break;
    }
  }
}
