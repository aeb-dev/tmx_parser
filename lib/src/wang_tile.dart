import 'dart:async';

import 'package:meta/meta.dart';
import 'package:tmx_parser/src/helpers/xml_traverser.dart';

import 'helpers/xml_accessor.dart';

class WangTile with XmlTraverser {
  late int tileId;
  late List<int> wangId;

  @internal
  void readAttributes(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;
    assert(
      element.localName == "wangtile",
      "can not parse, element is not a 'wangtile'",
    );

    tileId = element.getAttributeInt("tileid")!;
    wangId = element
        .getAttributeStr("wangid")!
        .split(",")
        .map((i) => int.parse(i))
        .toList();
  }
}
