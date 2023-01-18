import "dart:async";

import "package:json_events/json_events.dart";
import "package:xml/xml_events.dart";

import "enums/orientation.dart";
import "extensions/xml_start_element_event.dart";
import "mixins/xml_traverser.dart";

class Grid with XmlTraverser, JsonObjectTraverser {
  late Orientation orientation = Orientation.orthogonal;
  late int width;
  late int height;

  @override
  void readAttributesXml(XmlStartElementEvent element) {
    assert(
      element.localName == "grid",
      "can not parse, element is not a 'grid'",
    );

    orientation = element
        .getAttribute<String>(
          "orientation",
          defaultValue: "orthogonal",
        )
        .toOrientation();
    width = element.getAttribute<int>("width");
    height = element.getAttribute<int>("height");
  }

  @override
  Future<void> readJson(String key) async {
    switch (key) {
      case "orientation":
        orientation = (await this
                .readPropertyJsonContinue<String>(defaultValue: "orthogonal"))
            .toOrientation();
        break;
      case "width":
        width = await this.readPropertyJsonContinue<int>();
        break;
      case "height":
        height = await this.readPropertyJsonContinue<int>();
        break;
    }
  }
}
