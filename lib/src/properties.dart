import 'dart:async';

import 'package:collection/collection.dart';
import 'package:tmx_parser/src/helpers/xml_traverser.dart';

import 'helpers/xml_accessor.dart';
import 'property.dart';

class Properties extends DelegatingMap<String, Property> with XmlTraverser {
  Properties() : super({});

  @override
  void readAttributes(StreamIterator<XmlAccessor> si) {
    XmlAccessor element = si.current;
    assert(
      element.localName == "properties",
      "can not parse, element is not a 'properties'",
    );
  }

  @override
  Future<void> traverse(StreamIterator<XmlAccessor> si) async {
    XmlAccessor child = si.current;
    switch (child.localName) {
      case "property":
        Property property = Property();
        await property.loadXml(si);
        super[property.name] = property;
        break;
    }
  }
}
