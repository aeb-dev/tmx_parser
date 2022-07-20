import 'dart:async';

import 'package:tmx_parser/src/helpers/xml_traverser.dart';

import 'helpers/xml_accessor.dart';

class Frame with XmlTraverser {
  late int tileId;
  late int duration; // in ms

  void readAttributes(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;
    assert(
      element.localName == "frame",
      "can not parse, element is not a 'frame'",
    );

    tileId = element.getAttributeInt("tileid")!;
    duration = element.getAttributeInt("duration")!;
  }
}
