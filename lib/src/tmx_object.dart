import 'dart:math';

import 'package:xml/xml.dart';

import 'extensions/xml_element.dart';
import 'properties.dart';
import 'property.dart';
import 'text.dart';

class TmxObject {
  int id;
  String name = "";
  String type = "";
  double x = 0.0;
  double y = 0.0;
  double width = 0.0;
  double height = 0.0;
  double rotation = 0.0; // in degrees, clockwise
  int gid;
  bool visible = true;
  // String template;

  String objectType;
  List<Point<double>> points;
  Text text;

  Map<String, Property> properties;

  TmxObject.fromXML(XmlElement element) {
    if (element.name.local != "object") {
      throw "can not parse, element is not a 'object'";
    }

    id = element.getAttributeIntOr("id", id);
    name = element.getAttributeStrOr("name", name);
    type = element.getAttributeStrOr("type", type);
    x = element.getAttributeDoubleOr("x", x);
    y = element.getAttributeDoubleOr("y", y);
    width = element.getAttributeDoubleOr("width", width);
    height = element.getAttributeDoubleOr("height", height);
    rotation = element.getAttributeDoubleOr("rotation", rotation);
    gid = element.getAttributeIntOr("gid", gid);
    visible = element.getAttributeBoolOr("visible", visible);

    element.children.whereType<XmlElement>().forEach(
      (childElement) {
        switch (childElement.name.local) {
          case "properties":
            properties ??= Properties.fromXML(childElement);
            break;
          case "ellipse":
            points = [
              Point(x, y),
              Point(x + (width / 2.0), y + (height / 2.0)),
              Point(x + width, y + height),
              Point(x - (width / 2.0), y - (height / 2.0))
            ];
            break;
          case "point":
            points = [Point(x, y)];
            break;
          case "polygon":
          case "polyline":
            objectType = childElement.name.local;
            points = childElement
                .getAttributeStrOr("points", null)
                .split(" ")
                .map((pointS) {
              final List<String> pointPairs = pointS.split(",");
              return Point(
                double.parse(pointPairs.first),
                double.parse(pointPairs.last),
              );
            }).toList();
            break;
          case "text":
            text ??= Text.fromXML(childElement);
            break;
        }
      },
    );

    if (gid == null && points == null) {
      points = [
        Point(0.0, 0.0),
        Point(0.0, height),
        Point(width, height),
        Point(width, 0.0),
      ];
    }
  }
}
