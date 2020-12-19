import 'package:xml/xml.dart';

import 'extensions/xml_element.dart';

class TileOffset {
  double x = 0.0;
  double y = 0.0;

  TileOffset.fromXML(XmlElement element) {
    if (element.name.local != "tileoffset") {
      throw "can not parse, element is not a 'tileoffset'";
    }

    x = element.getAttributeDoubleOr("x", x);
    y = element.getAttributeDoubleOr("y", y);
  }

  TileOffset.zero();
}
