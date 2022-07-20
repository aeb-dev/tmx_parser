import 'dart:async';

import 'package:tmx_parser/src/helpers/xml_accessor.dart';

import 'helpers/xml_traverser.dart';
import 'property.dart';

abstract class Layer with XmlTraverser {
  late int id;
  late String name;
  late bool visible;
  late double offsetX;
  late double offsetY;
  late double opacity;
  int? tintColor;

  Map<String, Property>? properties;

  void readAttributes(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;

    id = element.getAttributeInt("id")!;
    name = element.getAttributeStrOr("name", "");
    visible = element.getAttributeBoolOr("visible", true);
    offsetX = element.getAttributeDoubleOr("offsetx", 0.0);
    offsetY = element.getAttributeDoubleOr("offsety", 0.0);
    opacity = element.getAttributeDoubleOr("opacity", 1.0);
    tintColor = element.getAttributeColor("tintcolor");
  }
}
