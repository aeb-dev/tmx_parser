import 'dart:async';

import 'package:tmx_parser/src/helpers/xml_traverser.dart';

import 'frame.dart';
import 'helpers/xml_accessor.dart';

class Animation with XmlTraverser {
  final List<Frame> frameList = [];

  @override
  void readAttributes(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;
    assert(
      element.localName == "animation",
      "can not parse, element is not an 'animation'",
    );
  }

  @override
  Future<void> traverse(StreamIterator<XmlAccessor> si) async {
    XmlAccessor child = si.current;
    switch (child.localName) {
      case "frame":
        frameList.add(await Frame()
          ..loadXml(si));
        break;
    }
  }
}
