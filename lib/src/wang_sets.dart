import 'dart:async';

import 'package:collection/collection.dart';
import 'package:meta/meta.dart';
import 'package:tmx_parser/src/helpers/xml_traverser.dart';

import 'helpers/xml_accessor.dart';
import 'wang_set.dart';

class WangSets extends DelegatingList<WangSet> with XmlTraverser {
  WangSets() : super([]);

  @internal
  void readAttributes(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;
    assert(
      element.localName == "wangsets",
      "can not parse, element is not a 'wangsets'",
    );
  }

  @internal
  Future<void> traverse(StreamIterator<XmlAccessor> si) async {
    XmlAccessor child = si.current;
    ;
    switch (child.localName) {
      case "wangset":
        WangSet wangSet = WangSet();
        await wangSet.loadXml(si);
        super.add(wangSet);
        break;
    }
  }
}
