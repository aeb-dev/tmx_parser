import "dart:async";

import "package:json_events/json_events.dart";
import "package:xml/xml_events.dart";

import "enums/property_type.dart";
import "extensions/json_traverser.dart";
import "extensions/string.dart";
import "extensions/xml_event.dart";
import "extensions/xml_start_element_event.dart";
import "mixins/xml_traverser.dart";

class Property with XmlTraverser, JsonObjectTraverser {
  late String name;
  late PropertyType type = PropertyType.string;

  dynamic value;
  final Map<String, Property> properties = <String, Property>{};

  @override
  void readAttributesXml(XmlStartElementEvent element) {
    assert(
      element.localName == "property",
      "can not parse, element is not a 'property'",
    );

    name = element.getAttribute<String>("name");
    type = element
        .getAttribute<String>(
          "type",
          defaultValue: "string",
        )
        .toPropertyType();

    switch (type) {
      case PropertyType.int:
      case PropertyType.object:
        value = element.getAttribute<int>("value", defaultValue: 0);
      case PropertyType.float:
        value = element.getAttribute<double>("value", defaultValue: 0.0);
      case PropertyType.bool:
        value = element.getAttribute<bool>("value", defaultValue: false);
      case PropertyType.color:
        value = element.getAttribute<String>("value", defaultValue: "0");
      case PropertyType.string:
        value = element.getAttribute<String>("value", defaultValue: "");
      case PropertyType.file:
        value = element.getAttribute<String>("value", defaultValue: ".");
      case PropertyType.$class:
        break;
    }
  }

  @override
  void readTextXml(XmlTextEvent element) {
    value ??= element.value;
  }

  @override
  Future<void> traverseXml() async {
    switch (six.current.asStartElement.localName) {
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
      case "type":
        type = (await this.readPropertyJsonContinue<String>(
          defaultValue: "string",
        ))
            .toPropertyType();
      case "value":
        value = await this.readPropertyJsonContinue<dynamic>();
      case "properties":
        await this.loadMapJson<String, Property>(
          m: properties,
          keySelector: (Property property) => property.name,
          creator: Property.new,
        );
    }
  }

  @override
  Future<void> postProcessJson() async {
    switch (type) {
      case PropertyType.int:
      case PropertyType.object:
        value = (value as num?)?.toInt() ?? 0;
      case PropertyType.float:
        value = (value as num?)?.toDouble() ?? 0.0;
      case PropertyType.bool:
        value = value as bool? ?? false;
      case PropertyType.color:
        value = (value as String?)?.toColor() ?? 0;
      case PropertyType.string:
        value = value as String? ?? "";
      case PropertyType.file:
        value = value as String? ?? ".";
      case PropertyType.$class:
        break;
    }
  }
}
