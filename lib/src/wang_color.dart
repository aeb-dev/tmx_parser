part of tmx_parser;

abstract class _WangColor {
  String name;
  String color;
  int tile;
  double probability = 0.0;

  void fromXML(XmlElement element) {
    name = element.getAttributeStrOr("name", name);
    color = element.getAttributeStrOr("color", color);
    tile = element.getAttributeIntOr("tile", tile);
    probability = element.getAttributeDoubleOr("probability", probability);
  }
}

class WangCornerColor extends _WangColor {
  WangCornerColor.fromXML(XmlElement element) {
    if (element.name.local != "wangcornercolor") {
      throw "can not parse, element is not a 'wangcornercolor'";
    }

    fromXML(element);
  }
}

class WangEdgeColor extends _WangColor {
  WangEdgeColor.fromXML(XmlElement element) {
    if (element.name.local != "wangedgecolor") {
      throw "can not parse, element is not a 'wangedgecolor'";
    }

    fromXML(element);
  }
}
