import 'dart:async';

import 'package:meta/meta.dart';
import 'package:tmx_parser/src/helpers/xml_accessor.dart';
import 'package:tmx_parser/src/helpers/xml_traverser.dart';

import 'property.dart';
import 'properties.dart';

class WangColor with XmlTraverser {
  late String name;
  late String className;
  late int color;
  late int tile;
  late double probability;

  Map<String, Property>? properties;

  @internal
  void readAttributes(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;
    assert(
      element.localName == "wangcolor",
      "can not parse, element is not a 'wangcolor'",
    );

    name = element.getAttributeStr("name")!;
    className = element.getAttributeStrOr("className", "");
    color = element.getAttributeColor("color")!;
    tile = element.getAttributeIntOr("tile", -1);
    probability = element.getAttributeDoubleOr("probability", 0.0);
  }

  @internal
  Future<void> traverse(StreamIterator<XmlAccessor> si) async {
    XmlAccessor child = si.current;
    ;
    switch (child.localName) {
      case "properties":
        properties = Properties();
        await (properties as Properties).loadXml(si);
        break;
    }
  }
}
