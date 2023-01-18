import "dart:async";

import "package:json_events/json_events.dart";
import "package:xml/xml_events.dart";

import "extensions/xml_start_element_event.dart";
import "mixins/xml_traverser.dart";

class Export with XmlTraverser, JsonObjectTraverser {
  late String target;
  late String format;

  @override
  void readAttributesXml(XmlStartElementEvent element) {
    assert(
      element.localName == "export",
      "can not parse, element is not a 'export'",
    );

    target = element.getAttribute<String>("target");
    format = element.getAttribute<String>("format");
  }

  @override
  Future<void> readJson(String key) async {
    switch (key) {
      case "target":
        target = await this.readPropertyJsonContinue<String>();
        break;
      case "format":
        format = await this.readPropertyJsonContinue<String>();
        break;
    }
  }
}
