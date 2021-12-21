import 'package:xml/xml.dart';

import 'extensions/xml_element.dart';

class Grid {
  late String orientation = "orthogonal";
  late double width;
  late double height;

  Grid.fromXML(XmlElement element) {
    if (element.name.local != "grid") {
      throw "can not parse, element is not a 'grid'";
    }

    orientation = element.getAttributeStrOr("orientation", orientation);
    width = element.getAttributeDouble("width")!;
    height = element.getAttributeDouble("height")!;
  }
}
