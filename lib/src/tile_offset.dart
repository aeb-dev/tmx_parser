import 'dart:async';


import 'helpers/xml_accessor.dart';
import 'helpers/xml_traverser.dart';

class TileOffset with XmlTraverser {
  late double x;
  late double y;

  TileOffset();

  TileOffset.zero() {
    x = 0.0;
    y = 0.0;
  }

  @override
  void readAttributes(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;
    assert(
      element.localName == "tileoffset",
      "can not parse, element is not a 'tileoffset'",
    );

    x = element.getAttributeDoubleOr("x", 0.0);
    y = element.getAttributeDoubleOr("y", 0.0);
  }
}
