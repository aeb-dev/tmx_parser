import "dart:async";

import "package:json_events/json_events.dart";
import "package:xml/xml_events.dart";

import "extensions/json_traverser.dart";
import "extensions/string.dart";
import "extensions/xml_event.dart";
import "extensions/xml_start_element_event.dart";
import "mixins/xml_traverser.dart";
import "property.dart";

class WangColor with XmlTraverser, JsonObjectTraverser {
  late String name;
  late String className = "";
  late int color;
  late int tile = -1;
  late double probability = 0.0;

  final Map<String, Property> properties = {};

  @override
  void readAttributesXml(XmlStartElementEvent element) {
    assert(
      element.localName == "wangcolor",
      "can not parse, element is not a 'wangcolor'",
    );

    name = element.getAttribute<String>("name");
    className = element.getAttribute<String>("class", defaultValue: "");
    color = element.getAttribute<String>("color").toColor();
    tile = element.getAttribute<int>("tile", defaultValue: -1);
    probability =
        element.getAttribute<double>("probability", defaultValue: 0.0);
  }

  @override
  Future<void> traverseXml() async {
    switch (six.current.asStartElement.localName) {
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
        className = await this.readPropertyJsonContinue(defaultValue: "");
        break;
      case "color":
        color = (await this.readPropertyJsonContinue<String>()).toColor();
        break;
      case "tile":
        tile = await this.readPropertyJsonContinue<int>(defaultValue: -1);
        break;
      case "probability":
        probability =
            await this.readPropertyJsonContinue<double>(defaultValue: 0.0);
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
