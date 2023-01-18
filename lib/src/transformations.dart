import "dart:async";

import "package:json_events/json_events.dart";
import "package:xml/xml_events.dart";

import "extensions/xml_start_element_event.dart";
import "mixins/xml_traverser.dart";

class Transformations with XmlTraverser, JsonObjectTraverser {
  late bool hFlip = false;
  late bool vFlip = false;
  late bool rotate = false;
  late bool preferUntransformed = false;

  @override
  void readAttributesXml(XmlStartElementEvent element) {
    assert(
      element.localName == "transformations",
      "can not parse, element is not a 'transformations'",
    );

    hFlip = element.getAttribute<bool>(
      "hflip",
      defaultValue: false,
    );
    vFlip = element.getAttribute<bool>(
      "vflip",
      defaultValue: false,
    );
    rotate = element.getAttribute<bool>(
      "rotate",
      defaultValue: false,
    );
    preferUntransformed = element.getAttribute<bool>(
      "preferuntransformed",
      defaultValue: false,
    );
  }

  @override
  Future<void> readJson(String key) async {
    switch (key) {
      case "hflip":
        hFlip = await this.readPropertyJsonContinue<bool>(
          defaultValue: false,
        );
        break;
      case "vflip":
        vFlip = await this.readPropertyJsonContinue<bool>(
          defaultValue: false,
        );
        break;
      case "rotate":
        rotate = await this.readPropertyJsonContinue<bool>(
          defaultValue: false,
        );
        break;
      case "preferuntransformed":
        preferUntransformed = await this.readPropertyJsonContinue<bool>(
          defaultValue: false,
        );
        break;
    }
  }
}
