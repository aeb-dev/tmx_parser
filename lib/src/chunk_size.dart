import 'dart:async';

import 'mixins/xml_traverser.dart';
import 'enums/orientation.dart';
import 'helpers/xml_accessor.dart';

class ChunkSize with XmlTraverser {
  late int width;
  late int height;

  @override
  void readAttributesXml(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;
    assert(
      element.localName == "chunksize",
      "can not parse, element is not a 'chunksize'",
    );

    width = element.getAttributeIntOr("width", 16);
    height = element.getAttributeIntOr("height", 16);
  }
}
