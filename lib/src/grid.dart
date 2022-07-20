import 'dart:async';

import 'helpers/xml_traverser.dart';

import 'enums/orientation.dart';
import 'helpers/xml_accessor.dart';

class Grid with XmlTraverser {
  late Orientation orientation;
  late double width;
  late double height;

  @override
  void readAttributes(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;
    assert(
      element.localName == "grid",
      "can not parse, element is not a 'grid'",
    );

    orientation =
        element.getAttributeStrOr("orientation", "orthogonal").toOrientation();
    width = element.getAttributeDouble("width")!;
    height = element.getAttributeDouble("height")!;
  }
}
