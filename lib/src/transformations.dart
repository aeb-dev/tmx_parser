import 'dart:async';

import 'package:tmx_parser/src/helpers/xml_accessor.dart';
import 'package:tmx_parser/src/helpers/xml_traverser.dart';


class Transformations with XmlTraverser {
  late bool hFlip;
  late bool vFlip;
  late bool rotate;
  late bool preferUntransformed;

  @override
  void readAttributes(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;
    assert(
      element.localName == "transformations",
      "can not parse, element is not a 'transformations'",
    );

    hFlip = element.getAttributeBoolOr("hflip", false);
    vFlip = element.getAttributeBoolOr("vflip", false);
    rotate = element.getAttributeBoolOr("tile", false);
    preferUntransformed =
        element.getAttributeBoolOr("preferuntransformed", false);
  }
}
