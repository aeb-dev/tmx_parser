part of tmx_parser;

class Grid {
  String orientation = "orthogonal";
  double width;
  double height;

  Grid.fromXML(XmlElement element) {
    if (element.name.local != "grid") {
      throw "can not parse, element is not a 'grid'";
    }

    orientation = element.getAttributeStrOr("orientation", orientation);
    width = element.getAttributeDoubleOr("width", width);
    height = element.getAttributeDoubleOr("height", height);
  }
}
