import 'package:xml/xml.dart';

import 'extensions/xml_element.dart';

abstract class _WangColor {
  late String name;
  late String color;
  late int tile;
  double probability = 0.0;

  void fromXML(XmlElement element) {
    name = element.getAttributeStr("name")!;
    color = element.getAttributeStr("color")!;
    tile = element.getAttributeInt("tile")!;
    probability = element.getAttributeDoubleOr("probability", probability);
  }
}

class WangCornerColor extends _WangColor {
  WangCornerColor.fromXML(XmlElement element) {
    if (element.name.local != "wangcornercolor") {
      throw "can not parse, element is not a 'wangcornercolor'";
    }

    super.fromXML(element);
  }
}

class WangEdgeColor extends _WangColor {
  WangEdgeColor.fromXML(XmlElement element) {
    if (element.name.local != "wangedgecolor") {
      throw "can not parse, element is not a 'wangedgecolor'";
    }

    super.fromXML(element);
  }
}
