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

  TmxObjectType objectType;
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
            objectType = TmxObjectType.ellipse;
            break;
          case "point":
            objectType = TmxObjectType.point;
            break;
          case "polygon":
          case "polyline":
            objectType = childElement.name.local == "polygon" ? TmxObjectType.polygon : TmxObjectType.polyline;
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
            objectType = TmxObjectType.text;
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

enum TmxObjectType {
  ellipse,
  point,
  polygon,
  polyline,
  text,
}
