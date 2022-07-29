import 'dart:async';

import 'mixins/xml_traverser.dart';
import 'enums/orientation.dart';
import 'helpers/xml_accessor.dart';

class Export with XmlTraverser {
  late String target;
  late String format;

  @override
  void readAttributesXml(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;
    assert(
      element.localName == "export",
      "can not parse, element is not a 'export'",
    );

    target = element.getAttributeStr("target")!;
    format = element.getAttributeStr("format")!;
  }
}
