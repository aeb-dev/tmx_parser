import 'dart:async';
import 'dart:math';

import 'package:tmx_parser/src/helpers/xml_traverser.dart';

import 'enums/object_type.dart';
import 'helpers/xml_accessor.dart';
import 'properties.dart';
import 'property.dart';
import 'text.dart';

class TmxObject with XmlTraverser {
  late int id;
  late String name;
  late String type;
  late double x;
  late double y;
  late double width;
  late double height;
  late double rotation; // in degrees, clockwise
  late int? gid;
  late bool visible;
  // String template;

  ObjectType objectType = ObjectType.rectangle;
  List<Point<double>>? points;
  Text? text;

  Map<String, Property>? properties;

  @override
  void readAttributes(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;
    assert(
      element.localName == "object",
      "can not parse, element is not an 'object'",
    );

    id = element.getAttributeInt("id")!;
    name = element.getAttributeStrOr("name", "");
    type = element.getAttributeStrOr("class", "");
    x = element.getAttributeDoubleOr("x", 0.0);
    y = element.getAttributeDoubleOr("y", 0.0);
    width = element.getAttributeDoubleOr("width", 0.0);
    height = element.getAttributeDoubleOr("height", 0.0);
    rotation = element.getAttributeDoubleOr("rotation", 0.0);
    gid = element.getAttributeInt("gid");
    visible = element.getAttributeBoolOr("visible", true);
  }

  @override
  Future<void> traverse(StreamIterator<XmlAccessor> si) async {
    XmlAccessor child = si.current;
    ;
    switch (child.localName) {
      case "ellipse":
        objectType = ObjectType.ellipse;
        break;
      case "point":
        objectType = ObjectType.point;
        break;
      case "polygon":
      case "polyline":
        objectType = child.localName.toObjectType();
        points = child.getAttributeStr("points")!.split(" ").map((pointS) {
          final List<String> pointPairs = pointS.split(",");
          return Point(
            double.parse(pointPairs.first),
            double.parse(pointPairs.last),
          );
        }).toList();
        break;
      case "text":
        objectType = ObjectType.text;
        text = Text();
        await text!.loadXml(si);
        break;
      case "properties":
        properties = Properties();
        await (properties as Properties).loadXml(si);
        break;
    }
  }
}
