import 'dart:async';

import 'package:tmx_parser/src/helpers/xml_traverser.dart';
import 'package:xml/xml_events.dart';

import 'enums/property_type.dart';
import 'helpers/xml_accessor.dart';
import 'properties.dart';

class Property with XmlTraverser {
  late String name;
  late PropertyType type;

  dynamic value;
  Map<String, Property>? properties;

  @override
  void readAttributes(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;
    assert(
      element.localName == "property",
      "can not parse, element is not a 'property'",
    );

    name = element.getAttributeStr("name")!;
    type = element.getAttributeStrOr("type", "string").toPropertyType();

    switch (type) {
      case PropertyType.int:
      case PropertyType.object:
        value = element.getAttributeIntOr("value", 0);
        break;
      case PropertyType.float:
        value = element.getAttributeDoubleOr("value", 0.0);
        break;
      case PropertyType.bool:
        value = element.getAttributeBoolOr("value", false);
        break;
      case PropertyType.color:
        value = element.getAttributeStrOr("value", "#00000000");
        break;
      case PropertyType.string:
        value = element.getAttributeStr("value");
        break;
      case PropertyType.file:
        value = element.getAttributeStrOr("value", ".");
        break;
      case PropertyType.classType:
        break;
    }
  }

  @override
  void readText(StreamIterator<XmlAccessor> si) {
    XmlTextEvent element = si.current.element as XmlTextEvent;
    value ??= element.text;
  }

  @override
  Future<void> traverse(StreamIterator<XmlAccessor> si) async {
    XmlAccessor child = si.current;
    switch (child.localName) {
      case "properties":
        properties = Properties();
        await (properties as Properties).loadXml(si);
        break;
    }
  }
}
