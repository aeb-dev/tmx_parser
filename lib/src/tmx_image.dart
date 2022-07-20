import 'dart:async';

import 'package:tmx_parser/src/helpers/xml_traverser.dart';

import 'data.dart';
import 'helpers/xml_accessor.dart';

class TmxImage with XmlTraverser {
  String? format;
  String? source;
  String? trans;
  double? width;
  double? height;
  Data? data;

  @override
  void readAttributes(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;
    assert(
      element.localName == "image",
      "can not parse, element is not an 'image'",
    );

    format = element.getAttributeStr("format");
    source = element.getAttributeStr("source");
    trans = element.getAttributeStr("trans");
    width = element.getAttributeDouble("width");
    height = element.getAttributeDouble("height");
  }

  @override
  Future<void> traverse(StreamIterator<XmlAccessor> si) async {
    XmlAccessor child = si.current;
    switch (child.localName) {
      case "data":
        data = Data();
        await data!.loadXml(si);
        break;
    }
  }
}
